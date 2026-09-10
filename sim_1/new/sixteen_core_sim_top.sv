`timescale 1ps / 1ps

module sixteen_core_sim_top();
    reg aclk, aclk450, apb_clk, pcie_axi_clk;
    reg aresetn, aresetn450, pcie_axi_aresetn, APB_0_PRESET_N, APB_1_PRESET_N;
    
    assign refclk450 = aclk450;
    
    reg HBM_REF_CLK_0; //Free running HBM Refrence Clock
    reg APB_PCLK; //100MHz APB Clock
    
    wire [31:0] APB_0_PWDATA;
    assign APB_0_PWDATA = 32'b0;
    wire [21:0] APB_0_PADDR;
    assign APB_0_PADDR = 22'b0;
    //wire APB_0_PCLK;
    assign APB_0_PCLK = APB_PCLK;
    wire APB_0_PENABLE;
    assign APB_0_PENABLE = 1'b0;
    //wire APB_0_PRESET_N;
    //assign APB_0_PRESET_N = 1'b1;
    wire APB_0_PSEL;
    assign APB_0_PSEL = 1'b0;
    wire APB_0_PWRITE;
    assign APB_0_PWRITE = 1'b0;
    
    wire [31:0] APB_1_PWDATA;
    assign APB_1_PWDATA = 32'b0;
    wire [21:0] APB_1_PADDR;
    assign APB_1_PADDR = 22'b0;
    wire APB_1_PCLK;
    assign APB_1_PCLK = APB_PCLK;
    wire APB_1_PENABLE;
    assign APB_1_PENABLE = 1'b0;
    //wire APB_1_PRESET_N;
    //assign APB_1_PRESET_N = 1'b1;
    wire APB_1_PSEL;
    assign APB_1_PSEL = 1'b0;
    wire APB_1_PWRITE;
    assign APB_1_PWRITE = 1'b0;
    
   assign dbg_clk = aclk;
    
    /*
    AXI4 #(33, 256) hbm [31:0] (.aclk(aclk450), .aresetn(aresetn450)); //Here HBM AXI interface running at 450MHz
    FIFO_input #(512) rxFIFO_in [31:0] (.clk(aclk), .reset(~aresetn));
    FIFO_output #(512) txFIFO_out [31:0] (.clk(aclk), .reset(~aresetn));
    
    AXIStream_simple #(512) to_rxFIFO_small (.aclk(pcie_axi_clk), .aresetn(pcie_axi_aresetn));
    AXIStream_simple #(512) to_rxFIFO (.aclk(aclk), .aresetn(aresetn)); //After synchronized to Core clock (from PCIE AXI clock using Async FIFO)
    AXIStream #(512, 5) to_rxFIFO_with_dest (.aclk(aclk), .aresetn(aresetn));
    AXIStream_simple #(512) after_switch [31:0] (.aclk(aclk), .aresetn(aresetn));
    pcie_tdest_generator tdest_gen(.s(to_rxFIFO), .m(to_rxFIFO_with_dest));
    
    AXIStream_simple #(512) before_switch [31:0] (.aclk(aclk), .aresetn(aresetn));
    AXIStream_simple #(512) from_txFIFO (.aclk(aclk), .aresetn(aresetn));
    AXIStream_simple #(512) from_txFIFO_small (.aclk(pcie_axi_clk), .aresetn(pcie_axi_aresetn));
    
   
    
    switch_1_32 s_1_32(
        .s(to_rxFIFO_with_dest),
        .m(after_switch)
    );
    
    switch_32_1 s_32_1(
        .s(before_switch),
        .m(from_txFIFO)
    );
    */
    
    //Modifications to check if single_core synthesis is clean
    
    AXI4 #(33, 256) hbm [32] ({32{aclk450}}, {32{aresetn450}}); //Here HBM AXI interface running at 450MHz
    FIFO_input #(512) rxFIFO_in [16] ({16{aclk}}, {16{~aresetn}});
    FIFO_output #(512) txFIFO_out [16] ({16{aclk}}, {16{~aresetn}});
    
    AXIStream_simple #(512) to_rxFIFO_small (.aclk(pcie_axi_clk), .aresetn(pcie_axi_aresetn));
    AXIStream_simple #(512) to_rxFIFO (.aclk(aclk), .aresetn(aresetn)); //After synchronized to Core clock (from PCIE AXI clock using Async FIFO)
    AXIStream #(512, 5) to_rxFIFO_with_dest (.aclk(aclk), .aresetn(aresetn));
    AXIStream_simple #(512) after_switch [16] ({16{aclk}}, {16{aresetn}});
    AXIStream_simple #(512) after_switch_regslice [16] ({16{aclk}}, {16{aresetn}});
    pcie_tdest_generator tdest_gen(.s(to_rxFIFO), .m(to_rxFIFO_with_dest));
    
    AXIStream_simple #(512) before_switch_regslice [16] ({16{aclk}}, {16{aresetn}});
    AXIStream_simple #(512) before_switch [16] ({16{aclk}}, {16{aresetn}});
    AXIStream_simple #(512) from_txFIFO (.aclk(aclk), .aresetn(aresetn));
    AXIStream_simple #(512) from_txFIFO_small (.aclk(pcie_axi_clk), .aresetn(pcie_axi_aresetn));
    
    
    /*
    switch_1_2 s_1_2(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tvalid(to_rxFIFO_with_dest.tvalid),
        .s_axis_tdata(to_rxFIFO_with_dest.tdata),
        .s_axis_tdest(to_rxFIFO_with_dest.tdest),
        .s_axis_tready(to_rxFIFO_with_dest.tready),
        .m_axis_tvalid({after_switch[1].tvalid, after_switch[0].tvalid}),
        .m_axis_tdata({after_switch[1].tdata, after_switch[0].tdata}),
        .m_axis_tready({after_switch[1].tready, after_switch[0].tready}),
        .m_axis_tdest(),
        .s_decode_err()
    );
    */
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
    /*
    switch_2_1 s_2_1(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tvalid({before_switch[1].tvalid, before_switch[0].tvalid}),
        .s_axis_tdata({before_switch[1].tdata, before_switch[0].tdata}),
        .s_axis_tready({before_switch[1].tready, before_switch[0].tready}),
        .m_axis_tvalid(from_txFIFO.tvalid),
        .m_axis_tdata(from_txFIFO.tdata),
        .m_axis_tready(from_txFIFO.tready),
        .s_req_suppress(2'b0),
        .s_decode_err()
    );
    */
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
    wire  [12:0] curr_bram_waddr[0:31];
    wire  [12:0] curr_uram_waddr[0:31];
    wire  hbm2eep_rden[0:31];
    wire  hbm2iep_rden[0:31];
    wire  hbm2pfc_rden[0:31];
    wire  execRun_done[0:31];
    
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
    
    /*
    generate
        for(j=0; j<32; j=j+1) begin
            AXIS_to_FIFO_input AXIS_to_rxFIFO(
                .a(after_switch[j].Slave),
                .f(rxFIFO_in[j].Source)
            );
            if(j<1) begin
                core_wrapper my_core(
                    .aclk(aclk),
                    .aclk450(aclk450), //Core receives the derived 450MHz clock.
                    .async_resetn(aresetn),
                    .async_resetn450(aresetn450),
                    .num_outputs(num_outputs[j]),
                    .num_inputs(num_inputs[j]),
                    .threshold(threshold[j]),
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
                    .hbm2pfc_rden(hbm2pfc_rden[j]) 
                );
            end else begin
                dummy_core my_core(
                    .aclk(aclk),
                    .async_resetn(async_resetn),
                    .num_outputs(17'b0),
                    .num_inputs(17'b0),
                    .threshold(16'b0),
                    .exec_neuron_model(2'b0),
                    
                    .core_number(j[4:0]),
                    
                    .hbm(hbm[j]),
                    .rxFIFO_in(rxFIFO_in[j]),
                    .txFIFO_out(txFIFO_out[j])
                );
            end
            FIFO_output_to_AXIS txFIFO_to_AXIS(
                .f(txFIFO_out[j].Sink),
                .a(before_switch[j].Master)
            );
        end
    endgenerate
    */
     //Modifications to check if single_core synthesis is clean
    genvar j;
    generate
        for(j=0; j<32; j=j+1) begin 
               if(j<2) begin
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
                 core_wrapper my_core(
                    .aclk(aclk),
                    .aclk450(aclk450), //Core receives the derived 450MHz clock.
                    .async_resetn(aresetn),
                    .async_resetn450(aresetn450),
                    .num_outputs(num_outputs[j]),
                    .num_inputs(num_inputs[j]),
                    .threshold(threshold[j]),
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
                    .execRun_done(execRun_done[j])
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
               end else begin
                dummy_core my_core(
                    .aclk(aclk),
                    .async_resetn(async_resetn),
                    .num_outputs(17'b0),
                    .num_inputs(17'b0),
                    .threshold(16'b0),
                    .exec_neuron_model(2'b0),
                    
                    .core_number(j[4:0]),
                    
                    .hbm(hbm[j])
                    //.rxFIFO_in(rxFIFO_in[j]),
                    //.txFIFO_out(txFIFO_out[j])
                );
                end
         end
      endgenerate
    
/*
    FIFO_512_ASYNC rx_cdc(
        .s(to_rxFIFO_small),
        .m(to_rxFIFO)
    );
    
    FIFO_512_ASYNC tx_cdc(
        .s(from_txFIFO),
        .m(from_txFIFO_small)
    );
*/
 //Modifications to check if single_core synthesis is clean
 
    FIFO_512_ASYNC rx_cdc(
        .s(to_rxFIFO_small),
        .m(to_rxFIFO)
    );
    
    FIFO_512_ASYNC tx_cdc(
        .s(from_txFIFO),
        .m(from_txFIFO_small)
    );
  
    

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
        .AXI_``M``_WDATA_PARITY(~hbm[N].wdata),         \
        .AXI_``M``_WLAST(hbm[N].wlast),                \
        .AXI_``M``_WSTRB(hbm[N].wstrb),                \
        .AXI_``M``_WVALID(hbm[N].wvalid),              \
        .AXI_``M``_ARREADY(hbm[N].arready),            \
        .AXI_``M``_AWREADY(hbm[N].awready),            \
        .AXI_``M``_RDATA_PARITY(),\
        .AXI_``M``_RDATA(hbm[N].rdata),                \
        .AXI_``M``_RID(hbm[N].rid),                    \
        .AXI_``M``_RLAST(hbm[N].rlast),                \
        .AXI_``M``_RRESP(hbm[N].rresp),                \
        .AXI_``M``_RVALID(hbm[N].rvalid),              \
        .AXI_``M``_WREADY(hbm[N].wready),              \
        .AXI_``M``_BID(hbm[N].bid),                    \
        .AXI_``M``_BRESP(hbm[N].bresp),                \
        .AXI_``M``_BVALID(hbm[N].bvalid),              \
        
    hbm_left hbm1 (
        .HBM_REF_CLK_0(refclk450),              // input wire HBM_REF_CLK_0
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
        .APB_0_PRDATA(APB_0_PRDATA),                // output wire [31 : 0] APB_0_PRDATA
        .APB_0_PREADY(APB_0_PREADY),                // output wire APB_0_PREADY
        .APB_0_PSLVERR(APB_0_PSLVERR),              // output wire APB_0_PSLVERR
        .APB_0_PWDATA(APB_0_PWDATA),                // input wire [31 : 0] APB_0_PWDATA
        .APB_0_PADDR(APB_0_PADDR),                  // input wire [21 : 0] APB_0_PADDR
        .APB_0_PCLK(APB_0_PCLK),                    // input wire APB_0_PCLK
        .APB_0_PENABLE(APB_0_PENABLE),              // input wire APB_0_PENABLE
        .APB_0_PRESET_N(APB_0_PRESET_N),            // input wire APB_0_PRESET_N
        .APB_0_PSEL(APB_0_PSEL),                    // input wire APB_0_PSEL
        .APB_0_PWRITE(APB_0_PWRITE),                // input wire APB_0_PWRITE
        .apb_complete_0(apb_complete_0),            // output wire apb_complete_0
        .DRAM_0_STAT_CATTRIP(DRAM_0_STAT_CATTRIP),  // output wire DRAM_0_STAT_CATTRIP
        .DRAM_0_STAT_TEMP(DRAM_0_STAT_TEMP)        // output wire [6 : 0] DRAM_0_STAT_TEMP
    );

    hbm_right hbm2 (
        .HBM_REF_CLK_0(refclk450),              // input wire HBM_REF_CLK_0
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
        .APB_0_PRDATA(APB_1_PRDATA),                // output wire [31 : 0] APB_0_PRDATA
        .APB_0_PREADY(APB_1_PREADY),                // output wire APB_0_PREADY
        .APB_0_PSLVERR(APB_1_PSLVERR),              // output wire APB_0_PSLVERR
        .APB_0_PWDATA(APB_1_PWDATA),                // input wire [31 : 0] APB_0_PWDATA
        .APB_0_PADDR(APB_1_PADDR),                  // input wire [21 : 0] APB_0_PADDR
        .APB_0_PCLK(APB_1_PCLK),                    // input wire APB_0_PCLK
        .APB_0_PENABLE(APB_1_PENABLE),              // input wire APB_0_PENABLE
        .APB_0_PRESET_N(APB_1_PRESET_N),            // input wire APB_0_PRESET_N
        .APB_0_PSEL(APB_1_PSEL),                    // input wire APB_0_PSEL
        .APB_0_PWRITE(APB_1_PWRITE),                // input wire APB_0_PWRITE
        .apb_complete_0(apb_complete_1),            // output wire apb_complete_0
        .DRAM_0_STAT_CATTRIP(DRAM_1_STAT_CATTRIP),  // output wire DRAM_0_STAT_CATTRIP
        .DRAM_0_STAT_TEMP(DRAM_1_STAT_TEMP)        // output wire [6 : 0] DRAM_0_STAT_TEMP
    );
      
    reg [511:0] data_in;
    reg valid_in;
    wire ready_in;   
    
    wire ready_out;
    wire [511:0] data_out;
    wire valid_out;
        
          
    
    assign to_rxFIFO_small.tdata = data_in;
    assign to_rxFIFO_small.tvalid = valid_in;
    assign ready_in = to_rxFIFO_small.tready;
        
    assign ready_out = 1;
    assign from_txFIFO.tready = ready_out;
    assign data_out = from_txFIFO.tdata;
    assign valid_out = from_txFIFO.tvalid;
     
     
    wire ready_out_pcie;
    wire [511:0] data_out_pcie;
    wire valid_out_pcie;
    assign ready_out_pcie = 1;
    assign from_txFIFO_small.tready = ready_out_pcie;
    assign data_out_pcie = from_txFIFO_small.tdata;
    assign valid_out_pcie = from_txFIFO_small.tvalid;
    
        
    integer data_file;
    integer i;
    integer k;
    initial begin
        //data_file = $fopen("dec7_hexdump", "r");
        //data_file = $fopen("stepwise_exec.txt", "r"); //Stepwise Execution
        //data_file = $fopen("multicore_config.txt", "r"); //Running on other cores
        //data_file = $fopen("jun19_hundred_step_multicore.txt", "r");
        //data_file = $fopen("jul13.txt", "r");
        //data_file = $fopen("jan19.txt", "r"); //Continuous Execution
        //data_file = $fopen("oct12_hexdump", "r");
        //data_file = $fopen("/Volumes/export/isn/gopa/Downloads/Jul6.txt", "r");
        //data_file = $fopen("jul26Dump257Axon2.txt", "r");
        //data_file = $fopen("simdump_multineurontype_0120.txt", "r");
        //data_file = $fopen("test_stride_cnn_dump.txt", "r");
        //data_file = $fopen("10x10.txt", "r");
        //data_file = $fopen("jul16_twoModel.txt", "r");
        data_file = $fopen("aug2_oneModel.txt", "r");
        //data_file = $fopen("3x3.txt", "r");
        data_in <= 0;
        valid_in <= 0;
    
        aresetn <= 0;
        aresetn450 <= 0;
        APB_0_PRESET_N <= 0;
        APB_1_PRESET_N <= 0;
        pcie_axi_aresetn <= 0;
        #10ns;
        aresetn <= 1;
        #100ns;
        aresetn450 <= 1;
        APB_0_PRESET_N <= 1;
        APB_1_PRESET_N <= 0;
        pcie_axi_aresetn <= 1;
        #60000ns;
        i = 0;
        //while(i<57903) begin //test_stride_cnn_dump.txt
        //while(i<111) begin //10x10.txt
        //while(i<139) begin//jul16_twoModel.txt
        while(i<136) begin//aug2_oneModel.txt
        //while(i<85) begin //3X3.txt
        //for (i=0; i<10; i=i+1) begin
        //for (i=0; i<2839; i=i+1) begin //HBM initialization and URAm initilization Commands
            @(posedge pcie_axi_clk);
            //$fscanf(data_file, "%h", data_in);
            valid_in = 0;
            wait(ready_in);
            @(posedge pcie_axi_clk);
            if(ready_in) begin 
                $fscanf(data_file, "%h", data_in);
                valid_in = 1;
                i=i+1;
            end
            #10ns;
            //#4444.44;
        end
        valid_in <= 0;
        #40000ns; //40us delay for HBM data to be written
        //#1200000ns; //1200us delay for HBM data to be written
        
        //Stepwise Execution
        for (k=0; k<10; k=k+1) begin  //Number of steps to execute
            i = 0;
            //while (i<12) begin //test_stride_cnn_dump.txt
            while (i<3) begin //10x10.txt
            //for (i=0; i<1; i=i+1) begin //No input packet for QUBO model
                @(posedge pcie_axi_clk);
                //$fscanf(data_file, "%h", data_in);
                valid_in = 0;
                wait(ready_in);
                @(posedge pcie_axi_clk);
                if(ready_in) begin 
                    $fscanf(data_file, "%h", data_in);
                    valid_in = 1;
                    i = i+1;
                end
                #10ns;
             
             end
             valid_in <= 0;
             #4000ns; //4 us for processing delay
             valid_in <= 0;
        end
        $display("Test done");
        
        /*
        for (i=0; i<1; i=i+1) begin //Continous mode execution command
            @(posedge pcie_axi_clk);
            $fscanf(data_file, "%h", data_in);
            valid_in = 0;
            wait(ready_in);
            valid_in = 1;
            #8ns;
        end
        for (k=0; k<24; k=k+1) begin  //Number of Inputs for continuous mode
            for (i=0; i<1; i=i+1) begin //Axon inputs for continous mode execution
                @(posedge pcie_axi_clk);
                $fscanf(data_file, "%h", data_in);
                valid_in = 0;
                wait(ready_in);
                valid_in = 1;
                #8ns;
             
            end
            valid_in <= 0;
            valid_in <= 0;
        end
        $display("Test done");
        */
       
        
    end
    
    ////////////////////////////////////////////////////////////////////////////////
    // Generating 450MHz REF clock
    ////////////////////////////////////////////////////////////////////////////////
    
    initial begin
        HBM_REF_CLK_0 = 1'b0;
        #1111.11;
        HBM_REF_CLK_0 = 1'b1;
        forever HBM_REF_CLK_0 = #1111.11 ~HBM_REF_CLK_0;
    end
    ////////////////////////////////////////////////////////////////////////////////
    // Generating 100MHz APB clock and Reset
    ////////////////////////////////////////////////////////////////////////////////
    
    initial begin
        APB_PCLK = 1'b0;
        #1111.11;
        forever APB_PCLK = #(10000/2.0) ~APB_PCLK;
    end
    
    initial begin
        aclk <= 0;
        //#1ns;
        #1111.11;
        forever begin
            aclk <= ~aclk;
            #2ns;
            //#1111.11;
            #2ns;
            //#1111.11;
        end
    end
    initial begin
        aclk450 <= 0;
        //#1ns;
        #1112.11;
        forever begin
            aclk450 <= ~aclk450;
            #2ns;
            //#1111.11;
            aclk450 <= ~aclk450;
            #2ns;
            //#1111.11;
        end
    end
    initial begin
        pcie_axi_clk <= 0;
        //#1ns;
        #1111.11;
        forever begin
            pcie_axi_clk <= ~pcie_axi_clk;
            #2.5ns;
            //#1111.11;
            #2.5ns;
            //#1111.11;
        end
    end
endmodule
