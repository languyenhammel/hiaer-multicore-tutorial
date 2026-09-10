`timescale 1ns / 1ps

//=============================================================================
// command_interpreter.v
// 
// MODIFIED FOR MULTI-CORE SUPPORT
// 
// Changes from original:
//   1. Added CORE_ID parameter to identify which core (0-15) this instance belongs to
//   2. Modified spike packet assembly to include core_id in bits [20:17]
//   3. Bits [22:21] reserved for future FPGA_ID (inter-FPGA communication)
//
// New Individual Spike Packet Format (32 bits):
//   [31:24] = execRun_ctr[7:0]  (timestamp - unchanged)
//   [23]    = valid bit         (unchanged)
//   [22:21] = 2'b00             (reserved for FPGA_ID)
//   [20:17] = CORE_ID[3:0]      (NEW: identifies source core 0-15)
//   [16:0]  = neuron address    (unchanged)
//
// Outgoing Spike PCIe Packet Format (512 bits) - UNCHANGED:
//   [511:480] = 0xEEEEEEEE (header)
//   [479:32]  = 14 Individual Spike Packets
//   [31:0]    = execRun_ctr (full timestamp)
//
//=============================================================================

module command_interpreter #(
   parameter AXI_ADDR_BITS  = 32,
   parameter AXI_DATA_WIDTH = 32,
   parameter HBM_ADDR_BITS  = 33,
   parameter HBM_DATA_WIDTH = 256,
   parameter HBM_BYTE_COUNT = 32,
   
   // NEW: Core identification for multi-core support
   parameter [3:0] CORE_ID  = 4'd0    // Core ID (0-15), set during instantiation
   )(
   input aclk,
   input aresetn,
   
   // Global core parameters
  // input [16:0]            num_inputs,          // number of inputs/axons (Now moved to PCIe command)
   
   
   ////////////////////
   // PCIe interface //
   ////////////////////
   
   // RX FIFO (host->card)
   input                   rxFIFO_empty,
   input           [511:0] rxFIFO_dout,
   output reg              rxFIFO_rden,
   
   // TX FIFO (card->host)
   input                   txFIFO_full,
   output reg      [511:0] txFIFO_din,
   output reg              txFIFO_wren,
   
   
   //////////////////////////////////////
   // External events (axon) processor //
   //  Write axon event to future BRAM //
   //////////////////////////////////////
   
   output                  axonEvent_set,
   output reg       [12:0] axonEvent_addr,      // [13:0]=row address
   output            [15:0] axonEvent_data,      // [7:0]=data mask
   
   
   ////////////////////////////////////////////
   // HBM (synapse) processor                //
   //  Read/write pointers and synaptic data //
   ////////////////////////////////////////////
   
   input                   ci2hbm_full,
   output     [1+23+255:0] ci2hbm_din,          // [279]=r/w; [278:256]=row address; [255:0]=data
   output reg              ci2hbm_wren,
   input                   hbm2ci_empty,
   input           [255:0] hbm2ci_dout,         // [255:0]=data
   output reg              hbm2ci_rden,
   
   
   ////////////////////////////////////////
   // Internal events (neuron) processor //
   //  Read/write membrane potentials    // 
   ////////////////////////////////////////
   
   input                   ci2iep_full,
   output reg              ci2iep_wren,
   //output      [1+17+15:0] ci2iep_din,          // [33]=r/w; [32:16]=neuron address; [15:0]=data
   output      [1+17+35:0] ci2iep_din,          // [53]=r/w; [52:36]=neuron address; [35:0]=data
   input                   iep2ci_empty,
   output reg              iep2ci_rden,
   //input         [17+15:0] iep2ci_dout,         // [32:16]=neuron address; [15:0]=data
   input         [17+35:0] iep2ci_dout,         // [52:36]=neuron address; [15:0]=data
   
   /////////////////////////////////
   // Spike event FIFO            //
   //  Spike is sent out via PCIe //
   /////////////////////////////////
   
   input            [16:0] spk2ciFIFO_dout,     // [16:0]=spiked neuron address
   input                   spk2ciFIFO_empty,
   output reg              spk2ciFIFO_rden,
   
   
   ///////////////////////
   // Network execution //
   ///////////////////////
   
   input             exec_iep_phase2_done,      // internal events (neuron) processor finished phase 2
   
   output reg        exec_run,                  // algorithm time step execution
   output reg        execRun_running,           // execution: actively running
   output reg        execRun_done,              // execution: finished running
   output reg [31:0] execRun_limit,             // execution: user-defined number of time steps (= number of input data samples)
   output reg [31:0] execRun_ctr,               // execution: time step counter
   output reg [63:0] execRun_timer,             // execution: FPGA clock cycle counter during execution ("timer")
   
   
   // Debugging   
   output [2:0] vio_rx_curr_state,
   output [1:0] vio_tx_curr_state,
   
   output reg [16:0] num_outputs,
   output reg [16:0] num_inputs,
   output reg signed [35:0] threshold, 
   output reg [1:0] exec_neuron_model,
   output reg [5:0] leak,
   output reg [5:0] shift,
   
   input exec_hbm_rvalidready,
   
   //Network_param_mem interface signals
   
   input [3:0] rd_addr_neuron_param_mem,
   output [83:0] dout_neuron_param_mem
);



// Command list
wire [7:0] rx_command = rxFIFO_dout[511:504];   // [511:504]= 8-bit command

localparam [7:0] CMD_EEP_W        = 8'd1;       // write single input data sample to future external events (axon) BRAM
localparam [7:0] CMD_HBM_RW       = 8'd2;       // read/write HBM (synapse) processor
localparam [7:0] CMD_IEP_RW       = 8'd3;       // read/write internal events (neuron) processor
localparam [7:0] CMD_NTWK_PARAM_W = 8'd4;       // Write Network parameters (Num_inputs, Num_outputs, Threshold, exec_neuron_model)
localparam [7:0] CMD_EXEC_STEP    = 8'd6;       // execute network time step
localparam [7:0] CMD_EXEC_CONT    = 8'd7;       // execute network continuously
localparam [7:0] CMD_NTWK_PARAM_MEM_W  = 8'd8;       //Write to network_params_sram

// Read/write HBM (synapse) processor
assign ci2hbm_din = rxFIFO_dout[1+23+255:0];    // [279]=r/w; [278:256]=row address; [255:0]=data


// Read/write internal events (neuron) processor
//assign ci2iep_din = rxFIFO_dout[1+17+15:0];     // [33]=r/w; [32:16]=neuron address; [15:0]=data
assign ci2iep_din = rxFIFO_dout[1+17+35:0];     // [53]=r/w; [52:36]=neuron address; [35:0]=data

// Register execution signals
//  -Execution counter and counter limit
//  -Execution status flags ('running' and 'done')
//  -Execution timer/counter
reg exec_run_rst;                               // reset execution counter and timer; also used for registering execution limit
reg exec_run_set;                               // set execution counter limit
reg exec_run_inc;                               // increment execution counter 
reg exec_run_done;                              // indicates execution has finished

always @(posedge aclk) begin
   if (!aresetn | (exec_run_rst & !exec_run_set))
      execRun_limit <= 32'd0;
   else if (exec_run_set)
      execRun_limit <= rxFIFO_dout[31:0];

   if (!aresetn | exec_run_rst)
      execRun_ctr <= 32'd0;
   else if (exec_run_inc)
      execRun_ctr <= execRun_ctr + 1'b1;
      
   if (!aresetn | exec_run_rst)
      execRun_timer <= 64'd0;
   else if (execRun_running)
      execRun_timer <= execRun_timer + 1'b1;
      
   if (!aresetn) begin
      execRun_running <= 1'b0;
      execRun_done    <= 1'b0;
   end else if (exec_run_rst) begin
      execRun_running <= 1'b1;
      execRun_done    <= 1'b0;
   end else if (exec_run_done) begin
      execRun_running <= 1'b0;
      execRun_done    <= 1'b1;
   end
end   


// Register axon data and address during loading of input data sample
//  Shift register PCIe data and use lower 8 bits for axon event data 
reg [511:0] axon_data_sr;                       // shift register for incoming 512-bit PCIe data packet
reg         axon_data_set;                      // register PCIe data packet into shift register
reg         axon_addr_rst;                      // reset 'axonEvent_addr'
reg         axon_addr_inc;                      // set axon event, shift axon data, and increment axon address

//wire [13:0] axon_addr_limit = num_inputs[16:3]; // 8 axons per axon row address -> ignore lower 3 bits of number of inputs
wire [12:0] axon_addr_limit = num_inputs[16:4]; // 16 axons per axon row address -> ignore lower 4 bits of number of inputs
// Shift axon data and increment axon address
always @(posedge aclk) begin
   if (!aresetn | axon_addr_rst) begin
      axonEvent_addr <= 13'd0; //Previously 14'd0
      axon_data_sr   <= 512'd0;
   end else if (axon_data_set)
      axon_data_sr   <= rxFIFO_dout;
   else if (axon_addr_inc) begin
      axonEvent_addr <= axonEvent_addr + 1'b1;
      axon_data_sr   <= {16'd0, axon_data_sr[511:16]}; //Previously axon_data_sr   <= {8'd0, axon_data_sr[511:8]};
   end
end

// Set/send axon event at every axon address increment
assign axonEvent_set  = axon_addr_inc;
assign axonEvent_data = axon_data_sr[15:0];      // current axon data = LSB of shift register (previously [7:0])



///////////////////////////////////
// RX (host->card) state machine //
///////////////////////////////////

reg [2:0] rx_curr_state, rx_next_state;

localparam [2:0] RX_STATE_RESET                   = 3'd0;
localparam [2:0] RX_STATE_IDLE                    = 3'd1;
localparam [2:0] RX_STATE_REGISTER_PCIE_AXON_DATA = 3'd2;
localparam [2:0] RX_STATE_SET_AXON_DATA           = 3'd3;
localparam [2:0] RX_STATE_EXEC_STEP               = 3'd4;
localparam [2:0] RX_STATE_WAIT_RUN                = 3'd5;
localparam [2:0] RX_STATE_EXEC_DONE               = 3'd6;

always @(posedge aclk)
   if (~aresetn) rx_curr_state <= RX_STATE_RESET;
   else          rx_curr_state <= rx_next_state;



reg network_params_wren, network_params_mem_wren;

reg [31:0] latency_ctr;
reg [31:0] hbm_access_ctr;

reg wea_neuron_param_mem;
reg [3:0] wr_addr_neuron_param_mem;
reg [83:0] din_neuron_param_mem;
//wire [83:0] dout_neuron_param_mem;

//Network params Mem
neuron_params_mem neuron_param
  (
    .clka(aclk),
    .clkb(aclk),
    .wea(wea_neuron_param_mem),
    .addra(wr_addr_neuron_param_mem),
    .addrb(rd_addr_neuron_param_mem),
    .dina(din_neuron_param_mem),
    .doutb(dout_neuron_param_mem)
  );


   
always @(posedge aclk) begin

    if (~aresetn) begin
        num_inputs <= 17'd0;
        num_outputs <= 17'd0;
        threshold <= 36'd0;
        exec_neuron_model <= 2'd0;
        latency_ctr <=32'b0;
        hbm_access_ctr <= 32'b0;
        wea_neuron_param_mem <= 1'b0;
        din_neuron_param_mem <= 84'b0;
        wr_addr_neuron_param_mem <= 4'b0;
    end else if (network_params_wren) begin
        num_inputs <= rxFIFO_dout[16:0];            //17-bit NUM_INPUTs
        num_outputs <= rxFIFO_dout[33:17];         //17-bit NUM_OUTPUTs
        threshold <= rxFIFO_dout[69:34];           //36-bit Theshold
        exec_neuron_model <= rxFIFO_dout[71:70];   //2-bit Neuron Model
        shift <= rxFIFO_dout[77:72];  //6b shift parameter
        leak <= rxFIFO_dout[83:78];
    end else begin
        wea_neuron_param_mem <= network_params_mem_wren;
        if (network_params_mem_wren) din_neuron_param_mem <= rxFIFO_dout[83:0];
        if (wea_neuron_param_mem) wr_addr_neuron_param_mem <= wr_addr_neuron_param_mem + 1;
    end
    if(rx_curr_state == RX_STATE_WAIT_RUN) begin
        latency_ctr <=latency_ctr+1;
        if(exec_hbm_rvalidready) hbm_access_ctr <= hbm_access_ctr+1;
    end
end

// Wait to ensure that spk2ciFIFO has been completely emptied after execution finished (and before moving to next time step)
//  Since simple round-robin is used, up to 8 clock cycles may occur before an intermediate spike FIFO
//   sends a spike to spk2ciFIFO. As a guarantee, we are using 15 clock cycles of no activity to ensure
//   all spikes have been transmitted (and be able to move to next time step) 
reg  [7:0] wait_clks_cnt;
wire [7:0] wait_clks_limit = 8'd255;



always @(posedge aclk) begin
    
   if ((rx_curr_state==RX_STATE_WAIT_RUN) & exec_iep_phase2_done & spk2ciFIFO_empty)
      wait_clks_cnt <= wait_clks_cnt + 1'b1;
   else
      wait_clks_cnt <= 8'd0;
end


// State machine
always @(*) begin
   
   rxFIFO_rden   = 1'b0;
   rx_next_state = rx_curr_state;
   
   // HBM (synapse) processor
   ci2hbm_wren = 1'b0;
   
   // Execution via PCIe
   exec_run_rst  = 1'b0;
   exec_run_set  = 1'b0;
   exec_run_inc  = 1'b0;
   exec_run      = 1'b0;
   exec_run_done = 1'b0;
   
   // External inputs (axon) processor
   axon_data_set = 1'b0;
   axon_addr_rst = 1'b0;
   axon_addr_inc = 1'b0;
   
   // Internal events (neuron) processor
   ci2iep_wren = 1'b0;
   
   network_params_wren = 1'b0;
   network_params_mem_wren = 1'b0;
   case (rx_curr_state)
   
      RX_STATE_RESET: begin
         rx_next_state = RX_STATE_IDLE;
      end
      
      // Wait for rxFIFO data to be received
      RX_STATE_IDLE: begin
         if (!rxFIFO_empty) begin
         
            // Verify command (upper rxFIFO_dout byte)
            case (rx_command)
               // write single input data sample to external events (axon) processor
               CMD_EEP_W: begin
                  axon_addr_rst = 1'b1;   // reset 'axonEvent_addr'
                  rxFIFO_rden   = 1'b1;
                  rx_next_state = RX_STATE_REGISTER_PCIE_AXON_DATA;
               end 
               
               // read/write HBM data
               CMD_HBM_RW: begin
                  if (~ci2hbm_full) begin
                     ci2hbm_wren = 1'b1;
                     rxFIFO_rden = 1'b1;
                     rx_next_state = RX_STATE_IDLE;
                  end
               end
            
               // read/write neuron membrane potential
               CMD_IEP_RW: begin
                  if (~ci2iep_full) begin
                     ci2iep_wren = 1'b1;
                     rxFIFO_rden = 1'b1;
                     rx_next_state = RX_STATE_IDLE;
                  end
               end
              //Write Network Parameters
              CMD_NTWK_PARAM_W: begin
                  network_params_wren = 1'b1;
                  rxFIFO_rden = 1'b1;
                  rx_next_state = RX_STATE_IDLE;
              end
               // execute algorithm time step (does NOT load any axon events)
               //  set execRun_limit=0
               CMD_EXEC_STEP: begin
                  axon_addr_rst = 1'b1;   // reset 'axonEvent_addr'
                  exec_run_rst  = 1'b1;   // reset 'execRun_ctr' and 'execRun_timer'
                  rxFIFO_rden   = 1'b1;
                  rx_next_state = RX_STATE_EXEC_STEP;
               end
               
               // continuously execute network via PCIe
               //  set execRun_limit=rxFIFO_dout[31:0]
               CMD_EXEC_CONT: begin
                  axon_addr_rst = 1'b1;   // reset 'axonEvent_addr'
                  exec_run_rst  = 1'b1;   // reset 'execRun_ctr' and 'execRun_timer'
                  exec_run_set  = 1'b1;   // set 'execRun_limit'
                  rxFIFO_rden   = 1'b1;
                  rx_next_state = RX_STATE_REGISTER_PCIE_AXON_DATA;
               end
               CMD_NTWK_PARAM_MEM_W: begin
                  network_params_mem_wren = 1'b1;
                  rxFIFO_rden = 1'b1;
                  rx_next_state = RX_STATE_IDLE;
               end
               default: begin
                  rx_next_state = rx_curr_state;
               end
            endcase
         end
      end
      
      // Register 'axon_data_sr'
      RX_STATE_REGISTER_PCIE_AXON_DATA: begin
         if (!rxFIFO_empty) begin
            axon_data_set = 1'b1;
            rxFIFO_rden   = 1'b1;
            rx_next_state = RX_STATE_SET_AXON_DATA;
         end
      end
      
      // Set axon event, shift axon data, and increment axon address
      //  if reached axon address limit
      //    if not executing network -> done
      //    else -> wait for network execution
      //  else, if reached 64 x 8-bit axon events -> fetch next PCIe packet
      // Set axon event, shift axon data, and increment axon address
      // FIX for Case A: Handle boundary when num_inputs is exact multiple of 256
      // Problem: When num_inputs=256, axon_addr_limit=16. At addr=15, we check 15>=16 (false),
      // then check addr[3:0]==15 (true) and fetch next packet. Addr becomes 16, then 16>=16 exits
      // but the last 16 axons (addr 15) were never processed because we jumped to fetch state.
      // Solution: Check if NEXT address would exceed limit before fetching new packet.
      RX_STATE_SET_AXON_DATA: begin
         // Increment address while below limit
         if (axonEvent_addr < axon_addr_limit) begin
            axon_addr_inc = 1'b1;
         end else begin
            axon_addr_inc = 1'b0;
         end

         // Check if we've finished processing all axons
         if (axonEvent_addr >= axon_addr_limit) begin
            // All axons processed, move to next state
            if (!execRun_running) rx_next_state = RX_STATE_IDLE;
            else                  rx_next_state = RX_STATE_EXEC_STEP;
         end else if ((axonEvent_addr[3:0] == 4'd15) && ((axonEvent_addr + 1'b1) < axon_addr_limit)) begin
            // At packet boundary (every 16 axons) AND more axons remain to process
            // Only fetch next packet if we haven't reached the limit
            rx_next_state = RX_STATE_REGISTER_PCIE_AXON_DATA;
         end
         // If at packet boundary but next addr >= limit, stay in this state and let
         // the >= check above handle the exit on next cycle
      end
      
      // Execute algorithm time step
      RX_STATE_EXEC_STEP: begin
         exec_run = 1'b1;
         rx_next_state = RX_STATE_WAIT_RUN;
      end
      
      // Execute algorithm time step (after previous time step has been completed)
      //  if 'wait_clks_cnt' reached limit (i.e. internal events processor done and spk2ciFIFO empty for 15 clock cycles)
      //    -if reached execution counter limit -> done
      //    -else -> increment execution counter, restart axon address, and fetch new input data sample from PCIe
      RX_STATE_WAIT_RUN: begin
         
          if (execRun_ctr==execRun_limit) begin
            if (wait_clks_cnt==wait_clks_limit) rx_next_state = RX_STATE_EXEC_DONE;
          end else if (!rxFIFO_empty && wait_clks_cnt>=wait_clks_limit) begin  //Wait until atleast new timestep spikes are available and enough wait after the prev exec_run
                    exec_run_inc  = 1'b1;      // increment 'execRun_ctr' 
                    axon_addr_rst = 1'b1;      // reset 'axonEvent_addr'
                    rx_next_state = RX_STATE_REGISTER_PCIE_AXON_DATA;
           end
      end
      
      // Stop 'execRun_timer' and set 'execRun_done' flag
      RX_STATE_EXEC_DONE: begin
         exec_run_done = 1'b1;
         rx_next_state = RX_STATE_IDLE;
      end
      
      default: begin
         rx_next_state = rx_curr_state;
      end
   endcase
end


//=============================================================================
// MODIFIED: Spike Event Assembly with CORE_ID
//=============================================================================
// Register spike events from 'spk2ciFIFO'
//  Shift register used for grouping spikes in batches of 14
//
// NEW Individual Spike Packet Format (32 bits):
//   [31:24] = execRun_ctr[7:0]   - timestamp (lower 8 bits)
//   [23]    = 1'b1               - valid bit
//   [22:21] = 2'b00              - reserved for FPGA_ID (future expansion)
//   [20:17] = CORE_ID[3:0]       - NEW: source core identifier (0-15)
//   [16:0]  = spk2ciFIFO_dout    - neuron address within core
//
// This allows the host to identify: FPGA (future) + Core + Neuron
//=============================================================================

reg [447:0] spike_sr;                        // shift register for incoming spike event
reg         spike_rst, spike_inc;            // reset,increment spike counter
reg   [3:0] spike_ctr;                       // spike event counter (number of received spikes)
wire  [3:0] spike_limit = 4'd14;             // 1 spike = 32 bits (8-bit sub-timestamp + 7-bit zero-padding + 17-bit neuron address)
                                             // 512-bit PCIe data packet -> 32-bit opcode + 14 x 32-bit spikes + 32-bit timestamp ('execRun_ctr')
reg         spikes_sent;                     // indicates if last packet of spikes has already been sent

// Assemble individual spike packet with CORE_ID
// Format: {timestamp[7:0], valid, fpga_id[1:0], core_id[3:0], neuron_addr[16:0]}
wire [31:0] spike_packet = {
    execRun_ctr[7:0],      // [31:24] timestamp (lower 8 bits)
    1'b1,                  // [23]    valid bit
    2'b00,                 // [22:21] reserved for FPGA_ID (future inter-FPGA support)
    CORE_ID[3:0],          // [20:17] CORE_ID - identifies which core (0-15)
    spk2ciFIFO_dout[16:0]  // [16:0]  neuron address within this core
};

always @(posedge aclk) begin
   if (!aresetn | spike_rst) begin
      spike_ctr   <= 4'd0;
      spike_sr    <= 448'd0;
      spikes_sent <= 1'b1;             // set flag upon writing packet of spikes to txFIFO
   end else if (spike_inc) begin
      spike_ctr   <= spike_ctr + 1'b1;
      // MODIFIED: Use spike_packet which includes CORE_ID
      spike_sr    <= {spike_packet, spike_sr[447:32]};
      spikes_sent <= 1'b0;             // any new received spike clears the flag
   end 
end


///////////////////////////////////
// TX (card->host) state machine //
///////////////////////////////////

reg [2:0] tx_curr_state, tx_next_state;

localparam [2:0] TX_STATE_RESET           = 3'd0;
localparam [2:0] TX_STATE_IDLE            = 3'd1;
localparam [2:0] TX_STATE_WAIT_FOR_SPIKES = 3'd2;
localparam [2:0] TX_STATE_SEND_SPIKES     = 3'd3;
localparam [2:0] TX_STATE_SEND_LATENCY_CNT = 3'd4;
localparam [2:0] TX_STATE_SEND_HBM_ACCESS_CNT = 3'd5;

always @(posedge aclk)
   if (!aresetn) tx_curr_state <= TX_STATE_RESET;
   else          tx_curr_state <= tx_next_state;


// State machine
always @(*) begin
   
   txFIFO_din  = 512'dX;
   txFIFO_wren = 1'b0;
   tx_next_state = tx_curr_state;
   
   // Output spike events
   spike_rst = 1'b0;
   spike_inc = 1'b0;
   
   // HBM (synapse) processor
   hbm2ci_rden = 1'b0;
   
   // Internal events (neuron) processor
   iep2ci_rden = 1'b0;
   
   case (tx_curr_state)
   
      TX_STATE_RESET: begin
         tx_next_state = TX_STATE_IDLE;
      end
      
      // Verify execution state and outgoing FIFOs
      //  if executing network -> wait for spikes 
      //  else -> verify if FIFOs are not empty
      TX_STATE_IDLE: begin
         if (execRun_running) begin
            spike_rst = 1'b1;
            tx_next_state = TX_STATE_WAIT_FOR_SPIKES;
         
         end else if (!txFIFO_full) begin
            // HBM data
            if (!hbm2ci_empty) begin
               txFIFO_din  = {16'hBBBB, 240'd0, hbm2ci_dout};
               txFIFO_wren = 1'b1;
               hbm2ci_rden = 1'b1;
            // neuron membrane potential
            end else if (!iep2ci_empty) begin
               //txFIFO_din  = {16'hCCCC, 463'd0, iep2ci_dout};
               txFIFO_din  = {16'hCCCC, 443'd0, iep2ci_dout};
               txFIFO_wren = 1'b1;
               iep2ci_rden = 1'b1;
            end
         end
      end

      // Verify if network is still running and if sufficient spikes have been received to send to PCIe
      //  if execution done ->
      //   -if spikes have already been sent (with no new spikes received since then) -> done
      //   -else -> send last packet of spikes
      //  else, if number of spikes reached packet limit (=14) -> send packet of spikes
      //  else, if spike FIFO not empty -> read FIFO data into 'spike_sr'
      TX_STATE_WAIT_FOR_SPIKES: begin
         if (execRun_done && spk2ciFIFO_empty) begin  //Don't finish sending spikes until entire spikeFIFO is empty.
            //if (spikes_sent) tx_next_state = TX_STATE_IDLE;
            //else             tx_next_state = TX_STATE_SEND_SPIKES;
            tx_next_state = TX_STATE_SEND_SPIKES;
            
         end else if (spike_ctr==spike_limit)
            tx_next_state = TX_STATE_SEND_SPIKES;
            
         else if (!spk2ciFIFO_empty) begin
            spike_inc       = 1'b1;
            spk2ciFIFO_rden = 1'b1;
         end
      end
      
      // Send opcode + 14 spikes + timestamp in 512-bit PCIe packet 
      TX_STATE_SEND_SPIKES: begin
         if (!txFIFO_full) begin
            if (execRun_done && spk2ciFIFO_empty) begin
                txFIFO_din  = {32'hABCD_ABCD, spike_sr, execRun_ctr}; //Send ExecDone Flag and return to IDLE state
                txFIFO_wren = 1'b1;
                spike_rst   = 1'b1;
                tx_next_state = TX_STATE_SEND_LATENCY_CNT;
            end else begin
                txFIFO_din  = {32'hEEEE_EEEE, spike_sr, execRun_ctr};
                txFIFO_wren = 1'b1;
                spike_rst   = 1'b1;
                tx_next_state = TX_STATE_WAIT_FOR_SPIKES;
             end
         end
      end
      TX_STATE_SEND_LATENCY_CNT: begin
            txFIFO_din  = {32'hBABA_BABA, 448'b0, latency_ctr}; //Send ExecDone Flag and return to IDLE state
            txFIFO_wren = 1'b1;
            spike_rst   = 1'b1;
            tx_next_state = TX_STATE_SEND_HBM_ACCESS_CNT;
      end
      TX_STATE_SEND_HBM_ACCESS_CNT: begin
            txFIFO_din  = {32'hCABA_CABA, 448'b0, hbm_access_ctr}; //Send ExecDone Flag and return to IDLE state
            txFIFO_wren = 1'b1;
            spike_rst   = 1'b1;
            tx_next_state = TX_STATE_IDLE;
      end
      default: begin
         tx_next_state = tx_curr_state;
      end
   endcase
end


// Debugging
assign vio_rx_curr_state = rx_curr_state;
assign vio_tx_curr_state = tx_next_state;



endmodule