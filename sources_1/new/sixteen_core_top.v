`timescale 1ns / 1ps
/*
Clocks:
refclk45 - free running 450MHz reference clock which is used to derive other clocks
pcie_clk_in - free running 100MHz clock for PCIe, required for PCIe DMA
apb_clk - 100MHz clock derived from refclk450, used for 
aclk - 150MHz derived clock that runs the core logic, hopefully will be increased to >300MHz
pcie_axi_clk - 250MHz clock created by PCIe endpoint which must drive all logic directly connected to PCIe DMA

FIXED: Added proper tie-offs for unused HBM ports (16-31) to prevent synthesis errors
*/
module sixteen_core_top(
    input orig_clk_p,
    input orig_clk_n,
//    output dbg_clk,
    input sys_rst_n,
    
    output [7:0] pci_exp_txp,
    output [7:0] pci_exp_txn,
    input [7:0] pci_exp_rxp,
    input [7:0] pci_exp_rxn,
    
    input [0:0]pcie_clk_in_clk_n,
    input [0:0]pcie_clk_in_clk_p,
    
    input refclk450_p,
    input refclk450_n
    );
    genvar j;
    
    wire [0:0]pcie_clk_gt;
    wire [0:0]pcie_clk_out;
    
    wire pcie_axi_clk;
    wire pcie_axi_aresetn;
    
    wire aclk;
    wire aclk450;
    wire apb_clk;
    wire refclk450;
    
    wire async_resetn;
    wire aresetn;
    
    
    wire [31:0] APB_0_PWDATA;
    assign APB_0_PWDATA = 32'b0;
    wire [21:0] APB_0_PADDR;
    assign APB_0_PADDR = 22'b0;
    wire APB_0_PCLK;
    assign APB_0_PCLK = apb_clk;
    wire APB_0_PENABLE;
    assign APB_0_PENABLE = 1'b0;
    wire APB_0_PSEL;
    assign APB_0_PSEL = 1'b0;
    wire APB_0_PWRITE;
    assign APB_0_PWRITE = 1'b0;
    
    wire [31:0] APB_1_PWDATA;
    assign APB_1_PWDATA = 32'b0;
    wire [21:0] APB_1_PADDR;
    assign APB_1_PADDR = 22'b0;
    wire APB_1_PCLK;
    assign APB_1_PCLK = apb_clk;
    wire APB_1_PENABLE;
    assign APB_1_PENABLE = 1'b0;
    wire APB_1_PSEL;
    assign APB_1_PSEL = 1'b0;
    wire APB_1_PWRITE;
    assign APB_1_PWRITE = 1'b0;
    
    pulse_stretcher #(
        .ACTIVE("low"),
        .pulse_width(15)
    ) reset_stretcher (
        .clk(aclk),
        .pulse_in(pcie_axi_aresetn),
        .pulse_out(async_resetn)
    );
    
    reset_synchronizer #(
        .ACTIVE("low")
    ) top_reset_sync (
        .clk(aclk),
        .reset_in(pcie_axi_aresetn),
        .reset_out(aresetn)
    );
    wire APB_0_PRESET_N;
    reset_synchronizer #(
        .ACTIVE("low")
    ) apb_0_reset_sync (
        .clk(apb_clk),
        .reset_in(pcie_axi_aresetn),
        .reset_out(APB_0_PRESET_N)
    );
    wire APB_1_PRESET_N;
    reset_synchronizer #(
        .ACTIVE("low")
    ) apb_1_reset_sync (
        .clk(apb_clk),
        .reset_in(pcie_axi_aresetn),
        .reset_out(APB_1_PRESET_N)
    );
    reset_synchronizer #(
        .ACTIVE("low")
    ) reset_sync_450 (
        .clk(aclk450),
        .reset_in(pcie_axi_aresetn),
        .reset_out(aresetn450)
    );

    clock_and_buffer clock_and_buffer_i(
        .refclk450_clk_p(refclk450_p),
        .refclk450_clk_n(refclk450_n),
        .aclk(aclk),
        .aclk450(aclk450),
        .apb_clk(apb_clk),
        .refclk450(refclk450),
        .pcie_clk_in_clk_n(pcie_clk_in_clk_n),
        .pcie_clk_in_clk_p(pcie_clk_in_clk_p),
        .pcie_clk_gt(pcie_clk_gt),
        .pcie_clk_out(pcie_clk_out)
    );
    
    // Note: dbg_clk output is commented out in port list
    // assign dbg_clk = aclk;
    
    // =========================================================================
    // HBM AXI Interfaces - 32 total (16 for hbm_left, 16 for hbm_right)
    // Only hbm[0:15] are used by cores, hbm[16:31] must be tied off
    // =========================================================================
    AXI4 #(33, 256) hbm [32] ({32{aclk450}}, {32{aresetn450}});
    
    // =========================================================================
    // TIE-OFF UNUSED HBM PORTS (16-31) - ACTIVE CORES ONLY USE 0-15
    // This prevents synthesis errors from unconnected BlackBox pins
    // =========================================================================
    generate
        for (j = 16; j < 32; j = j + 1) begin : gen_hbm_tieoff
            // Tie off all master-driven signals to idle state
            // Read address channel - no reads
            assign hbm[j].araddr  = 33'b0;
            assign hbm[j].arburst = 2'b01;      // INCR burst type (valid default)
            assign hbm[j].arid    = 6'b0;
            assign hbm[j].arlen   = 4'b0;
            assign hbm[j].arsize  = 3'b101;     // 32 bytes (256 bits)
            assign hbm[j].arvalid = 1'b0;       // No read requests
            
            // Write address channel - no writes
            assign hbm[j].awaddr  = 33'b0;
            assign hbm[j].awburst = 2'b01;      // INCR burst type (valid default)
            assign hbm[j].awid    = 6'b0;
            assign hbm[j].awlen   = 4'b0;
            assign hbm[j].awsize  = 3'b101;     // 32 bytes (256 bits)
            assign hbm[j].awvalid = 1'b0;       // No write requests
            
            // Write data channel - no writes
            assign hbm[j].wdata   = 256'b0;
            assign hbm[j].wlast   = 1'b0;
            assign hbm[j].wstrb   = 32'b0;
            assign hbm[j].wvalid  = 1'b0;       // No write data
            
            // Response channels - always ready to accept (won't get any)
            assign hbm[j].rready  = 1'b1;       // Ready to accept read data
            assign hbm[j].bready  = 1'b1;       // Ready to accept write response
        end
    endgenerate
    
    // =========================================================================
    // Core FIFOs and AXI Stream Interfaces
    // =========================================================================
    FIFO_input #(512) rxFIFO_in [16] ({16{aclk}}, {16{~aresetn}});
    FIFO_output #(512) txFIFO_out [16] ({16{aclk}}, {16{~aresetn}});
    
    AXIStream_simple #(512) to_rxFIFO_small (.aclk(pcie_axi_clk), .aresetn(pcie_axi_aresetn));
    AXIStream_simple #(512) to_rxFIFO (.aclk(aclk), .aresetn(aresetn));
    AXIStream #(512, 5) to_rxFIFO_with_dest (.aclk(aclk), .aresetn(aresetn));
    AXIStream_simple #(512) after_switch [16] ({16{aclk}}, {16{aresetn}});
    AXIStream_simple #(512) after_switch_regslice [16] ({16{aclk}}, {16{aresetn}});
    pcie_tdest_generator tdest_gen(.s(to_rxFIFO), .m(to_rxFIFO_with_dest));
    
    AXIStream_simple #(512) before_switch_regslice [16] ({16{aclk}}, {16{aresetn}});
    AXIStream_simple #(512) before_switch [16] ({16{aclk}}, {16{aresetn}});
    AXIStream_simple #(512) from_txFIFO (.aclk(aclk), .aresetn(aresetn));
    AXIStream_simple #(512) from_txFIFO_small (.aclk(pcie_axi_clk), .aresetn(pcie_axi_aresetn));
    
    // =========================================================================
    // AXI Stream Switches
    // =========================================================================
    switch_1_16 out_switch(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tvalid(to_rxFIFO_with_dest.tvalid),
        .s_axis_tdata(to_rxFIFO_with_dest.tdata),
        .s_axis_tdest(to_rxFIFO_with_dest.tdest),
        .s_axis_tready(to_rxFIFO_with_dest.tready),
        .m_axis_tvalid({after_switch[15].tvalid, after_switch[14].tvalid, after_switch[13].tvalid, after_switch[12].tvalid, after_switch[11].tvalid, after_switch[10].tvalid, after_switch[9].tvalid, after_switch[8].tvalid, after_switch[7].tvalid, after_switch[6].tvalid, after_switch[5].tvalid, after_switch[4].tvalid, after_switch[3].tvalid, after_switch[2].tvalid, after_switch[1].tvalid, after_switch[0].tvalid}),
        .m_axis_tdata({after_switch[15].tdata, after_switch[14].tdata, after_switch[13].tdata, after_switch[12].tdata, after_switch[11].tdata, after_switch[10].tdata, after_switch[9].tdata, after_switch[8].tdata, after_switch[7].tdata, after_switch[6].tdata, after_switch[5].tdata, after_switch[4].tdata, after_switch[3].tdata, after_switch[2].tdata, after_switch[1].tdata, after_switch[0].tdata}),
        .m_axis_tready({after_switch[15].tready, after_switch[14].tready, after_switch[13].tready, after_switch[12].tready, after_switch[11].tready, after_switch[10].tready, after_switch[9].tready, after_switch[8].tready, after_switch[7].tready, after_switch[6].tready, after_switch[5].tready, after_switch[4].tready, after_switch[3].tready, after_switch[2].tready, after_switch[1].tready, after_switch[0].tready}),
        .m_axis_tdest(),
        .s_decode_err()
    );

    switch_16_1 in_switch(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tvalid({before_switch[15].tvalid, before_switch[14].tvalid, before_switch[13].tvalid, before_switch[12].tvalid, before_switch[11].tvalid, before_switch[10].tvalid, before_switch[9].tvalid, before_switch[8].tvalid, before_switch[7].tvalid, before_switch[6].tvalid, before_switch[5].tvalid, before_switch[4].tvalid, before_switch[3].tvalid, before_switch[2].tvalid, before_switch[1].tvalid, before_switch[0].tvalid}),
        .s_axis_tdata({before_switch[15].tdata, before_switch[14].tdata, before_switch[13].tdata, before_switch[12].tdata, before_switch[11].tdata, before_switch[10].tdata, before_switch[9].tdata, before_switch[8].tdata, before_switch[7].tdata, before_switch[6].tdata, before_switch[5].tdata, before_switch[4].tdata, before_switch[3].tdata, before_switch[2].tdata, before_switch[1].tdata, before_switch[0].tdata}),
        .s_axis_tready({before_switch[15].tready, before_switch[14].tready, before_switch[13].tready, before_switch[12].tready, before_switch[11].tready, before_switch[10].tready, before_switch[9].tready, before_switch[8].tready, before_switch[7].tready, before_switch[6].tready, before_switch[5].tready, before_switch[4].tready, before_switch[3].tready, before_switch[2].tready, before_switch[1].tready, before_switch[0].tready}),
        .m_axis_tvalid(from_txFIFO.tvalid),
        .m_axis_tdata(from_txFIFO.tdata),
        .m_axis_tready(from_txFIFO.tready),
        .s_req_suppress(16'b0),
        .s_decode_err()
    );
   
    // =========================================================================
    // Debug and Status Signals
    // =========================================================================
    wire [16:0] num_outputs[0:31];
    wire [16:0] num_inputs[0:31];
    wire [15:0] threshold[0:31];
    wire [1:0] exec_neuron_model[0:31];
    wire exec_hbm_rvalidready[0:31];
    wire hbmFIFO_empty[0:31];
    wire [3:0] iep_curr_state[0:31];
    wire [3:0] hbm_curr_state[0:31];
    wire [2:0] eep_curr_state[0:31];
    wire exec_hbm_rx_phase2_done[0:31];
    wire exec_hbm_rx_phase1_done[0:31];
    wire [12:0] curr_bram_waddr[0:31];
    wire [12:0] curr_uram_waddr[0:31];
    wire hbm2eep_rden[0:31];
    wire hbm2iep_rden[0:31];
    wire hbm2pfc_rden[0:31];
    wire execRun_done[0:31];
    
    // =========================================================================
    // NoC Interface Wires
    // =========================================================================
    
    // Per-core spike outputs to NoC
    wire [16:0] noc_spike_out_addr [0:15];
    wire        noc_spike_out_valid [0:15];
    wire        noc_spike_out_ready [0:15];
    
    // Per-core NoC relay inputs
    wire [16:0] noc_relay_din [0:15];
    wire        noc_relay_wren [0:15];
    wire        noc_relay_full [0:15];
    wire        exec_eep_phase3_done [0:15];
    
    // NoC host spike outputs (spikes routed to PCIe - for monitoring)
    wire [16:0] noc_host_spike_addr [0:15];
    wire        noc_host_spike_valid [0:15];
    wire        noc_host_spike_ready [0:15];
    
    // NoC routing configuration
    wire        noc_route_cfg_valid;
    wire [3:0]  noc_route_cfg_core;
    wire [7:0]  noc_route_cfg_addr;
    wire [5:0]  noc_route_cfg_data;
    
    // NoC status
    wire [3:0]  noc_l1_bus_busy;
    wire        noc_l2_bus_busy;
    wire [15:0] noc_router_overflow;
    wire [15:0] noc_injector_overflow;
    
    // =========================================================================
    // VIO for Debug
    // =========================================================================
    top_vio my_vio(
        .clk(aclk),
        .probe_in0(sys_rst_n),
        .probe_in1(APB_0_PRESET_N),
        .probe_in2(msix_enable),
        .probe_in3(user_lnk_up),
        .probe_in4(aresetn),
        .probe_in5(apb_clk),
        .probe_in6(pcie_axi_aresetn),
        .probe_in7(num_outputs[0]),
        .probe_in8(num_inputs[0]),
        .probe_in9(threshold[0]),
        .probe_in10(exec_neuron_model[0]),
        .probe_in11(exec_hbm_rvalidready[0]),
        .probe_in12(hbmFIFO_empty[0]),
        .probe_in13(iep_curr_state[0]),
        .probe_in14(hbm_curr_state[0]),
        .probe_in15(eep_curr_state[0]),
        .probe_in16(exec_hbm_rx_phase1_done[0]),
        .probe_in17(exec_hbm_rx_phase2_done[0]),
        .probe_in18(curr_bram_waddr[0]),
        .probe_in19(curr_uram_waddr[0]),
        .probe_in20(hbm2eep_rden[0]),
        .probe_in21(hbm2iep_rden[0]),
        .probe_in22(hbm2pfc_rden[0]),
        .probe_in23(to_rxFIFO_with_dest.tdata[255:0]),
        .probe_in24(to_rxFIFO_with_dest.tdata[511:256]),
        .probe_in25(to_rxFIFO_with_dest.tvalid),
        .probe_in26(to_rxFIFO_with_dest.tdest),
        .probe_in27(from_txFIFO.tdata[255:0]),
        .probe_in28(from_txFIFO.tdata[511:256]),
        .probe_in29(from_txFIFO.tvalid),
        .probe_in30(execRun_done[0])
    );
    
    // =========================================================================
    // Core Generation (16 cores using hbm[0:15])
    // =========================================================================
    generate
        for(j=0; j<16; j=j+1) begin : gen_cores
            axis_register_slice_0 rxFIFO_axis_reg(
                .aclk(aclk),
                .aresetn(aresetn),
                .s_axis_tvalid(after_switch[j].tvalid),
                .s_axis_tready(after_switch[j].tready),
                .s_axis_tdata(after_switch[j].tdata),
                .m_axis_tvalid(after_switch_regslice[j].tvalid),
                .m_axis_tready(after_switch_regslice[j].tready),
                .m_axis_tdata(after_switch_regslice[j].tdata)
            );      
            
            AXIS_to_FIFO_input AXIS_to_rxFIFO(
                .a(after_switch_regslice[j].Slave),
                .f(rxFIFO_in[j].Source)
            );
            
            core_wrapper #(
                .CORE_ID(j[3:0])
            ) my_core (
                .aclk(aclk),
                .aclk450(aclk450),
                .async_resetn(aresetn),
                .async_resetn450(aresetn450),
                .num_outputs(num_outputs[j]),
                .num_inputs(num_inputs[j]),
                .threshold({20'b0, threshold[j]}),
                .exec_neuron_model(exec_neuron_model[j]),
                
                .core_number(j[4:0]),
                
                .hbm(hbm[j]),
                .rxFIFO_in(rxFIFO_in[j]),
                .txFIFO_out(txFIFO_out[j]),
                .exec_hbm_rvalidready(exec_hbm_rvalidready[j]),
                .hbmFIFO_empty(hbmFIFO_empty[j]),
                .iep_curr_state(iep_curr_state[j]),
                .hbm_curr_state(hbm_curr_state[j]),
                .eep_curr_state(eep_curr_state[j]),
                .exec_hbm_rx_phase1_done(exec_hbm_rx_phase1_done[j]),
                .exec_hbm_rx_phase2_done(exec_hbm_rx_phase2_done[j]),
                .curr_bram_waddr(curr_bram_waddr[j]),
                .curr_uram_waddr(curr_uram_waddr[j]),
                .hbm2eep_rden(hbm2eep_rden[j]),
                .hbm2iep_rden(hbm2iep_rden[j]),
                .hbm2pfc_rden(hbm2pfc_rden[j]),
                .execRun_done(execRun_done[j]),
                // NoC Interface
                .noc_spike_out_addr(noc_spike_out_addr[j]),
                .noc_spike_out_valid(noc_spike_out_valid[j]),
                .noc_spike_out_ready(noc_spike_out_ready[j]),
                .noc_relay_din(noc_relay_din[j]),
                .noc_relay_wren(noc_relay_wren[j]),
                .noc_relay_full(noc_relay_full[j]),
                .exec_eep_phase3_done(exec_eep_phase3_done[j])
            );
              
            FIFO_output_to_AXIS txFIFO_to_AXIS(
                .f(txFIFO_out[j].Sink),
                .a(before_switch_regslice[j].Master)
            );
            
            axis_register_slice_0 txFIFO_axis_reg(
                .aclk(aclk),
                .aresetn(aresetn),
                .s_axis_tvalid(before_switch_regslice[j].tvalid),
                .s_axis_tready(before_switch_regslice[j].tready),
                .s_axis_tdata(before_switch_regslice[j].tdata),
                .m_axis_tvalid(before_switch[j].tvalid),
                .m_axis_tready(before_switch[j].tready),
                .m_axis_tdata(before_switch[j].tdata)
            );  
        end
    endgenerate
    
    // =========================================================================
    // Network-on-Chip (NoC) Instantiation
    // =========================================================================
    
    // Pack arrays for NoC module
    wire [16:0] noc_core_spike_addr_packed [15:0];
    wire [15:0] noc_core_spike_valid_packed;
    wire [15:0] noc_core_spike_ready_packed;
    wire [16:0] noc_core_relay_addr_packed [15:0];
    wire [15:0] noc_core_relay_valid_packed;
    wire [15:0] noc_core_relay_full_packed;
    wire [15:0] noc_core_exec_run_packed;
    
    // Signal mapping from arrays to packed format
    genvar noc_idx;
    generate
        for (noc_idx = 0; noc_idx < 16; noc_idx = noc_idx + 1) begin : noc_signal_gen
            assign noc_core_spike_addr_packed[noc_idx] = noc_spike_out_addr[noc_idx];
            assign noc_core_spike_valid_packed[noc_idx] = noc_spike_out_valid[noc_idx];
            assign noc_spike_out_ready[noc_idx] = noc_core_spike_ready_packed[noc_idx];
            
            assign noc_relay_din[noc_idx] = noc_core_relay_addr_packed[noc_idx];
            assign noc_relay_wren[noc_idx] = noc_core_relay_valid_packed[noc_idx];
            assign noc_core_relay_full_packed[noc_idx] = noc_relay_full[noc_idx];
            
            assign noc_core_exec_run_packed[noc_idx] = 1'b0;
        end
    endgenerate
    
    cores_with_noc #(
        .NUM_CORES(16),
        .NUM_CLUSTERS(4),
        .CORES_PER_CLUSTER(4),
        .DATA_WIDTH(32)
    ) noc_inst (
        .clk(aclk),
        .resetn(aresetn),
        
        // Core spike outputs
        .core_spike_addr(noc_core_spike_addr_packed),
        .core_spike_valid(noc_core_spike_valid_packed),
        .core_spike_ready(noc_core_spike_ready_packed),
        
        // Core NoC relay inputs
        .core_noc_relay_addr(noc_core_relay_addr_packed),
        .core_noc_relay_valid(noc_core_relay_valid_packed),
        .core_noc_relay_full(noc_core_relay_full_packed),
        
        // Host spike outputs (for monitoring - not connected)
        .host_spike_addr(),
        .host_spike_valid(),
        .host_spike_ready(16'hFFFF),
        
        // Routing configuration (disabled for initial testing)
        .route_cfg_valid(noc_route_cfg_valid),
        .route_cfg_core(noc_route_cfg_core),
        .route_cfg_addr(noc_route_cfg_addr),
        .route_cfg_data(noc_route_cfg_data),
        
        // Timestep sync
        .core_exec_run(noc_core_exec_run_packed),
        
        // Status
        .l1_bus_busy(noc_l1_bus_busy),
        .l2_bus_busy(noc_l2_bus_busy),
        .router_overflow(noc_router_overflow),
        .injector_overflow(noc_injector_overflow)
    );
    
    // Routing configuration - disabled for initial testing
    assign noc_route_cfg_valid = 1'b0;
    assign noc_route_cfg_core  = 4'd0;
    assign noc_route_cfg_addr  = 8'd0;
    assign noc_route_cfg_data  = 6'd0;

    // =========================================================================
    // Clock Domain Crossing FIFOs
    // =========================================================================
    FIFO_512_ASYNC rx_cdc(
        .s(to_rxFIFO_small),
        .m(to_rxFIFO)
    );
    
    FIFO_512_ASYNC tx_cdc(
        .s(from_txFIFO),
        .m(from_txFIFO_small)
    );
  
    // =========================================================================
    // ILA for Debug
    // =========================================================================
    top_ila my_ila(
        .clk(aclk),
        .probe0(from_txFIFO_small.tdata),
        .probe1(from_txFIFO_small.tvalid),
        .probe2(from_txFIFO_small.tready),
        .probe3(to_rxFIFO_small.tdata),
        .probe4(to_rxFIFO_small.tvalid),
        .probe5(to_rxFIFO_small.tready),
        .probe6(from_txFIFO.tdata),
        .probe7(from_txFIFO.tvalid),
        .probe8(from_txFIFO.tready),
        .probe9(to_rxFIFO.tdata),
        .probe10(to_rxFIFO.tvalid),
        .probe11(to_rxFIFO.tready)
    );
    
    // =========================================================================
    // Missed Input Counter (Debug)
    // =========================================================================
    reg [31:0] missed_inputs;
    always @(posedge pcie_axi_clk) begin
        if (!pcie_axi_aresetn) begin
            missed_inputs <= 0;
        end else begin
            missed_inputs <= missed_inputs + (to_rxFIFO_small.tvalid & ~to_rxFIFO_small.tready);
        end
    end
    
    // =========================================================================
    // PCIe DMA Engine
    // =========================================================================
    xdma_0 pcie_dma (
        .sys_clk(pcie_clk_out),
        .sys_clk_gt(pcie_clk_gt),
        .sys_rst_n(sys_rst_n),
        .user_lnk_up(user_lnk_up),
        .pci_exp_txp(pci_exp_txp),
        .pci_exp_txn(pci_exp_txn),
        .pci_exp_rxp(pci_exp_rxp),
        .pci_exp_rxn(pci_exp_rxn),
        .axi_aclk(pcie_axi_clk),
        .axi_aresetn(pcie_axi_aresetn),
        .usr_irq_req(1'b0),
        .usr_irq_ack(usr_irq_ack),
        .msix_enable(msix_enable),
        .s_axis_c2h_tdata_0(from_txFIFO_small.tvalid ? from_txFIFO_small.tdata : {{480{1'b1}}, missed_inputs}),
        .s_axis_c2h_tkeep_0({64{1'b1}}),
        .s_axis_c2h_tlast_0(1'b0),
        .s_axis_c2h_tvalid_0(1'b1),
        .s_axis_c2h_tready_0(from_txFIFO_small.tready),
        
        .m_axis_h2c_tdata_0(to_rxFIFO_small.tdata),
        .m_axis_h2c_tkeep_0(),
        .m_axis_h2c_tlast_0(),
        .m_axis_h2c_tvalid_0(to_rxFIFO_small.tvalid),
        .m_axis_h2c_tready_0(to_rxFIFO_small.tready)
    );
   
    // =========================================================================
    // HBM Macro for Port Connections
    // =========================================================================
`define hbmAXI(M, N) \
        .AXI_``M``_ACLK(aclk450),                      \
        .AXI_``M``_ARESET_N(aresetn450),               \
        .AXI_``M``_ARADDR(hbm[N].araddr),              \
        .AXI_``M``_ARBURST(hbm[N].arburst),            \
        .AXI_``M``_ARID(hbm[N].arid),                  \
        .AXI_``M``_ARLEN(hbm[N].arlen),                \
        .AXI_``M``_ARSIZE(hbm[N].arsize),              \
        .AXI_``M``_ARVALID(hbm[N].arvalid),            \
        .AXI_``M``_AWADDR(hbm[N].awaddr),              \
        .AXI_``M``_AWBURST(hbm[N].awburst),            \
        .AXI_``M``_AWID(hbm[N].awid),                  \
        .AXI_``M``_AWLEN(hbm[N].awlen),                \
        .AXI_``M``_AWSIZE(hbm[N].awsize),              \
        .AXI_``M``_AWVALID(hbm[N].awvalid),            \
        .AXI_``M``_RREADY(hbm[N].rready),              \
        .AXI_``M``_BREADY(hbm[N].bready),              \
        .AXI_``M``_WDATA(hbm[N].wdata),                \
        .AXI_``M``_WDATA_PARITY(~hbm[N].wdata),        \
        .AXI_``M``_WLAST(hbm[N].wlast),                \
        .AXI_``M``_WSTRB(hbm[N].wstrb),                \
        .AXI_``M``_WVALID(hbm[N].wvalid),              \
        .AXI_``M``_ARREADY(hbm[N].arready),            \
        .AXI_``M``_AWREADY(hbm[N].awready),            \
        .AXI_``M``_RDATA_PARITY(),                     \
        .AXI_``M``_RDATA(hbm[N].rdata),                \
        .AXI_``M``_RID(hbm[N].rid),                    \
        .AXI_``M``_RLAST(hbm[N].rlast),                \
        .AXI_``M``_RRESP(hbm[N].rresp),                \
        .AXI_``M``_RVALID(hbm[N].rvalid),              \
        .AXI_``M``_WREADY(hbm[N].wready),              \
        .AXI_``M``_BID(hbm[N].bid),                    \
        .AXI_``M``_BRESP(hbm[N].bresp),                \
        .AXI_``M``_BVALID(hbm[N].bvalid),

    // =========================================================================
    // HBM Left Stack (uses hbm[0:15] - driven by cores)
    // =========================================================================
    hbm_left hbm1 (
        .HBM_REF_CLK_0(refclk450),
        `hbmAXI(00, 0)
        `hbmAXI(01, 1)
        `hbmAXI(02, 2)
        `hbmAXI(03, 3)
        `hbmAXI(04, 4)
        `hbmAXI(05, 5)
        `hbmAXI(06, 6)
        `hbmAXI(07, 7)
        `hbmAXI(08, 8)
        `hbmAXI(09, 9)
        `hbmAXI(10, 10)
        `hbmAXI(11, 11)
        `hbmAXI(12, 12)
        `hbmAXI(13, 13)
        `hbmAXI(14, 14)
        `hbmAXI(15, 15)
        .APB_0_PRDATA(APB_0_PRDATA),
        .APB_0_PREADY(APB_0_PREADY),
        .APB_0_PSLVERR(APB_0_PSLVERR),
        .APB_0_PWDATA(APB_0_PWDATA),
        .APB_0_PADDR(APB_0_PADDR),
        .APB_0_PCLK(APB_0_PCLK),
        .APB_0_PENABLE(APB_0_PENABLE),
        .APB_0_PRESET_N(APB_0_PRESET_N),
        .APB_0_PSEL(APB_0_PSEL),
        .APB_0_PWRITE(APB_0_PWRITE),
        .apb_complete_0(apb_complete_0),
        .DRAM_0_STAT_CATTRIP(DRAM_0_STAT_CATTRIP),
        .DRAM_0_STAT_TEMP(DRAM_0_STAT_TEMP)
    );

    // =========================================================================
    // HBM Right Stack (uses hbm[16:31] - ACTIVE TIE-OFFS, no cores connected)
    // The tie-offs in gen_hbm_tieoff provide valid idle AXI signals
    // =========================================================================
    hbm_right hbm2 (
        .HBM_REF_CLK_0(refclk450),
        `hbmAXI(00, 16)
        `hbmAXI(01, 17)
        `hbmAXI(02, 18)
        `hbmAXI(03, 19)
        `hbmAXI(04, 20)
        `hbmAXI(05, 21)
        `hbmAXI(06, 22)
        `hbmAXI(07, 23)
        `hbmAXI(08, 24)
        `hbmAXI(09, 25)
        `hbmAXI(10, 26)
        `hbmAXI(11, 27)
        `hbmAXI(12, 28)
        `hbmAXI(13, 29)
        `hbmAXI(14, 30)
        `hbmAXI(15, 31)
        .APB_0_PRDATA(APB_1_PRDATA),
        .APB_0_PREADY(APB_1_PREADY),
        .APB_0_PSLVERR(APB_1_PSLVERR),
        .APB_0_PWDATA(APB_1_PWDATA),
        .APB_0_PADDR(APB_1_PADDR),
        .APB_0_PCLK(APB_1_PCLK),
        .APB_0_PENABLE(APB_1_PENABLE),
        .APB_0_PRESET_N(APB_1_PRESET_N),
        .APB_0_PSEL(APB_1_PSEL),
        .APB_0_PWRITE(APB_1_PWRITE),
        .apb_complete_0(apb_complete_1),
        .DRAM_0_STAT_CATTRIP(DRAM_1_STAT_CATTRIP),
        .DRAM_0_STAT_TEMP(DRAM_1_STAT_TEMP)
    );
       
endmodule