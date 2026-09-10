 ///////////////////////////////////////////////////////////////////////////////
 //
 // Project:  Aurora 64B/66B
 // Company:  AMD
 //
 //
 //
 // (c) Copyright 2008 - 2023 Advanced Micro Devices, Inc. All rights reserved.
 //
 // This file contains confidential and proprietary information
 // of Advanced Micro Devices, Inc. and is protected under U.S. and
 // international copyright and other intellectual property
 // laws.
 //
 // DISCLAIMER
 // This disclaimer is not a license and does not grant any
 // rights to the materials distributed herewith. Except as
 // otherwise provided in a valid license issued to you by
 // AMD, and to the maximum extent permitted by applicable
 // law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
 // WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
 // AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
 // BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
 // INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
 // (2) AMD shall not be liable (whether in contract or tort,
 // including negligence, or under any other theory of
 // liability) for any loss or damage of any kind or nature
 // related to, arising under or in connection with these
 // materials, including for any direct, or any indirect,
 // special, incidental, or consequential loss or damage
 // (including loss of data, profits, goodwill, or any type of
 // loss or damage suffered as a result of any action brought
 // by a third party) even if such damage or loss was
 // reasonably foreseeable or AMD had been advised of the
 // possibility of the same.
 //
 // CRITICAL APPLICATIONS
 // AMD products are not designed or intended to be fail-
 // safe, or for use in any application requiring fail-safe
 // performance, such as life-support or safety devices or
 // systems, Class III medical devices, nuclear facilities,
 // applications related to the deployment of airbags, or any
 // other applications that could lead to death, personal
 // injury, or severe property or environmental damage
 // (individually and collectively, "Critical
 // Applications"). Customer assumes the sole risk and
 // liability of any use of AMD products in Critical
 // Applications, subject only to applicable laws and
 // regulations governing limitations on product liability.
 //
 // THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
 // PART OF THIS FILE AT ALL TIMES.

 //
 ///////////////////////////////////////////////////////////////////////////////
 //
 //
 //  Description: This is 8 series support file for Aurora.
 //
 //
 ///////////////////////////////////////////////////////////////////////////////

// ultrascale aurora_support file

`timescale 1 ps / 1 ps

   (* core_generation_info = "aurora_64b66b_port7_logic,aurora_64b66b_v12_0_15,{c_aurora_lanes=4,c_column_used=left,c_gt_clock_1=GTYQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=2,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=3,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=4,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=25.78125,c_gt_type=GTYE4,c_qpll=true,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=161.1328125,c_simplex=false,c_simplex_mode=TX,c_stream=true,c_ufc=false,c_user_k=false,flow_mode=None,interface_mode=Streaming,dataflow_config=Duplex}" *)
(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_64b66b_port7_logic_support
  (
       //-----------------------------------------------------------------------
       // TX AXI Interface
       input  [0:255]    s_axi_tx_tdata,
       input             s_axi_tx_tvalid,
       output            s_axi_tx_tready,
       //-----------------------------------------------------------------------
       // RX AXI Interface
       output [0:255]    m_axi_rx_tdata,
       output            m_axi_rx_tvalid,
       //-----------------------------------------------------------------------
       //-----------------------------------------------------------------------
       //-----------------------------------------------------------------------
       //-----------------------------------------------------------------------
       // GTX Serial I/O
       input   [0:3]      rxp,
       input   [0:3]      rxn,
       output  [0:3]      txp,
       output  [0:3]      txn,
       // Error Detection Interface
       output             hard_err,
       output             soft_err,
       // Status
       output             channel_up,
       output  [0:3]      lane_up,
       //-----------------------------------------------------------------------
       //-----------------------------------------------------------------------
       // System Interface
       output              user_clk_out,
       output              sync_clk_out,
       //-----------------------------------------------------------------------
       input              reset_pb, 
       input              gt_rxcdrovrden_in,
       input              power_down,
       input   [2:0]      loopback,
       input              pma_init,

       //-------------------- AXI4-Lite Interface -------------------------------
       //-------------------- Write Address Channel --------------------------
       input  [31:0]   s_axi_awaddr,
       input  [31:0]   s_axi_araddr,
       input  [31:0]   s_axi_wdata,
       input  [3:0]   s_axi_wstrb,
       input           s_axi_awvalid,
       input           s_axi_rready,
       input  [31:0]   s_axi_awaddr_lane1,
       input  [31:0]   s_axi_araddr_lane1,
       input  [31:0]   s_axi_wdata_lane1,
       input  [3:0]   s_axi_wstrb_lane1,
       input           s_axi_awvalid_lane1,
       input           s_axi_rready_lane1,
       input  [31:0]   s_axi_awaddr_lane2,
       input  [31:0]   s_axi_araddr_lane2,
       input  [31:0]   s_axi_wdata_lane2,
       input  [3:0]   s_axi_wstrb_lane2,
       input           s_axi_awvalid_lane2,
       input           s_axi_rready_lane2,
       input  [31:0]   s_axi_awaddr_lane3,
       input  [31:0]   s_axi_araddr_lane3,
       input  [31:0]   s_axi_wdata_lane3,
       input  [3:0]   s_axi_wstrb_lane3,
       input           s_axi_awvalid_lane3,
       input           s_axi_rready_lane3,
       output  [31:0]  s_axi_rdata,
       output          s_axi_awready,
       output          s_axi_wready,
       output          s_axi_bvalid,
       output  [1:0]   s_axi_bresp,
       output  [1:0]   s_axi_rresp,
       input           s_axi_bready,
       output          s_axi_arready,
       output          s_axi_rvalid,
       input           s_axi_arvalid,
       input           s_axi_wvalid,
       output  [31:0]  s_axi_rdata_lane1,
       output          s_axi_awready_lane1,
       output          s_axi_wready_lane1,
       output          s_axi_bvalid_lane1,
       output  [1:0]   s_axi_bresp_lane1,
       output  [1:0]   s_axi_rresp_lane1,
       input           s_axi_bready_lane1,
       output          s_axi_arready_lane1,
       output          s_axi_rvalid_lane1,
       input           s_axi_arvalid_lane1,
       input           s_axi_wvalid_lane1,
       output  [31:0]  s_axi_rdata_lane2,
       output          s_axi_awready_lane2,
       output          s_axi_wready_lane2,
       output          s_axi_bvalid_lane2,
       output  [1:0]   s_axi_bresp_lane2,
       output  [1:0]   s_axi_rresp_lane2,
       input           s_axi_bready_lane2,
       output          s_axi_arready_lane2,
       output          s_axi_rvalid_lane2,
       input           s_axi_arvalid_lane2,
       input           s_axi_wvalid_lane2,
       output  [31:0]  s_axi_rdata_lane3,
       output          s_axi_awready_lane3,
       output          s_axi_wready_lane3,
       output          s_axi_bvalid_lane3,
       output  [1:0]   s_axi_bresp_lane3,
       output  [1:0]   s_axi_rresp_lane3,
       input           s_axi_bready_lane3,
       output          s_axi_arready_lane3,
       output          s_axi_rvalid_lane3,
       input           s_axi_arvalid_lane3,
       input           s_axi_wvalid_lane3,

       //-----------------------------------------------------------------------
       input              init_clk,
       output              link_reset_out,
       output              gt_pll_lock,
       output              sys_reset_out,

       output   gt_reset_out,

       // GTX Reference Clock Interface
 
       input              gt_refclk1_p,
       input              gt_refclk1_n,
 
 
       output             gt_refclk1_out,
 

       //-----------------------------------------------------------------------
       output gt_rxusrclk_out,

       //-----------------------------------------------------------------------
       //------------------------ RX Margin Analysis Ports ------------------------
       output [3:0]         gt_eyescandataerror    ,
       input  [3:0]         gt_eyescanreset   ,
       input  [3:0]         gt_eyescantrigger   ,
       //------------------- Receive Ports - RX Equalizer Ports -------------------
       input  [3:0]         gt_rxcdrhold   ,
       input  [3:0]         gt_rxdfelpmreset   ,
       input  [3:0]         gt_rxlpmen   ,
       input  [3:0]         gt_rxpmareset   ,
       input  [3:0]         gt_rxpcsreset   ,
       input  [11:0]       gt_rxrate   ,
       input  [3:0]         gt_rxbufreset   ,
       output [3:0]         gt_rxpmaresetdone    ,
       input  [15:0]       gt_rxprbssel   ,
       input  [3:0]         gt_rxprbscntreset   ,
       output [3:0]         gt_rxprbserr    ,
       output [3:0]         gt_rxresetdone    ,
       output [11:0]       gt_rxbufstatus    ,

       //---------------------- TX Configurable Driver Ports ----------------------
       input  [19:0]       gt_txpostcursor   ,
 
       input  [19:0]       gt_txdiffctrl   ,
       input  [19:0]       gt_txprecursor   ,
       //--------------- Transmit Ports - TX Polarity Control Ports ---------------
       input  [3:0]         gt_txpolarity   ,
       input  [3:0]         gt_txinhibit   ,
       input  [3:0]         gt_txpmareset   ,
       input  [3:0]         gt_txpcsreset   ,
       input  [15:0]       gt_txprbssel   ,
       input  [3:0]         gt_txprbsforceerr   ,
       output [7:0]       gt_txbufstatus    ,
       output [3:0]         gt_txresetdone    ,
       input  [63:0]  gt_pcsrsvdin   ,
 
       output  [63:0]     gt_dmonitorout    ,
       output  [3:0]        gt_cplllock    ,
       output             gt_qplllock                   ,
       output [3:0]       gt_powergood    ,
//------------------------------------------------------------------------------
   //--- assigning output values for 8 series{
       output gt_qpllclk_quad1_out,
       output gt_qpllrefclk_quad1_out,
       output gt_qplllock_quad1_out     ,
       output gt_qpllrefclklost_quad1_out,





    //output                    gt_qpllrefclklost_out ,
    //output                    gt_qplllock_out ,
//--- assigning output values }
//------------------------------------------------------------------------------
       output                 mmcm_not_locked_out,
       output                 mmcm_not_locked_out2,
       output              tx_out_clk

 );
//********************************Wire Declarations**********************************

     //System Interface
       //wire                 mmcm_not_locked_out ;
       wire                 powerdown_i ;

       wire                  pma_init_i;
       wire                  pma_init_sync;

     // clock
       //(* KEEP = "TRUE" *) wire               user_clk_out;
       //(* KEEP = "TRUE" *) wire               sync_clk_out;


       wire               drp_clk_i;
       wire    [9:0] drpaddr_in_i;
       wire    [15:0]     drpdi_in_i;
       wire    [15:0]     drpdo_out_i;
       wire               drprdy_out_i;
       wire               drpen_in_i;
       wire               drpwe_in_i;
       wire    [9:0] drpaddr_in_lane1_i;
       wire    [15:0]     drpdi_in_lane1_i;
       wire    [15:0]     drpdo_out_lane1_i;
       wire               drprdy_out_lane1_i;
       wire               drpen_in_lane1_i;
       wire               drpwe_in_lane1_i;
       wire    [9:0] drpaddr_in_lane2_i;
       wire    [15:0]     drpdi_in_lane2_i;
       wire    [15:0]     drpdo_out_lane2_i;
       wire               drprdy_out_lane2_i;
       wire               drpen_in_lane2_i;
       wire               drpwe_in_lane2_i;
       wire    [9:0] drpaddr_in_lane3_i;
       wire    [15:0]     drpdi_in_lane3_i;
       wire    [15:0]     drpdo_out_lane3_i;
       wire               drprdy_out_lane3_i;
       wire               drpen_in_lane3_i;
       wire               drpwe_in_lane3_i;


       wire    [31:0]     s_axi_awaddr_i;
       wire    [31:0]     s_axi_araddr_i;
       wire    [31:0]     s_axi_wdata_i;
       wire    [31:0]     s_axi_rdata_i;
       wire    [3:0]     s_axi_wstrb_i;
       wire               s_axi_awvalid_i;
       wire               s_axi_arvalid_i;
       wire               s_axi_wvalid_i;
       wire               s_axi_rvalid_i;
       wire               s_axi_bvalid_i;
       wire    [1:0]      s_axi_bresp_i;
       wire    [1:0]      s_axi_rresp_i;
       wire               s_axi_bready_i;
       wire               s_axi_awready_i;
       wire               s_axi_arready_i;
       wire               s_axi_wready_i;
       wire               s_axi_rready_i;
       wire    [3:0]     s_axi_wstrb_lane1_i;
       wire               s_axi_awvalid_lane1_i;
       wire               s_axi_arvalid_lane1_i;
       wire               s_axi_wvalid_lane1_i;
       wire               s_axi_rvalid_lane1_i;
       wire               s_axi_bvalid_lane1_i;
       wire    [1:0]      s_axi_bresp_lane1_i;
       wire    [1:0]      s_axi_rresp_lane1_i;
       wire               s_axi_bready_lane1_i;
       wire               s_axi_awready_lane1_i;
       wire               s_axi_arready_lane1_i;
       wire               s_axi_wready_lane1_i;
       wire               s_axi_rready_lane1_i;
       wire    [3:0]     s_axi_wstrb_lane2_i;
       wire               s_axi_awvalid_lane2_i;
       wire               s_axi_arvalid_lane2_i;
       wire               s_axi_wvalid_lane2_i;
       wire               s_axi_rvalid_lane2_i;
       wire               s_axi_bvalid_lane2_i;
       wire    [1:0]      s_axi_bresp_lane2_i;
       wire    [1:0]      s_axi_rresp_lane2_i;
       wire               s_axi_bready_lane2_i;
       wire               s_axi_awready_lane2_i;
       wire               s_axi_arready_lane2_i;
       wire               s_axi_wready_lane2_i;
       wire               s_axi_rready_lane2_i;
       wire    [3:0]     s_axi_wstrb_lane3_i;
       wire               s_axi_awvalid_lane3_i;
       wire               s_axi_arvalid_lane3_i;
       wire               s_axi_wvalid_lane3_i;
       wire               s_axi_rvalid_lane3_i;
       wire               s_axi_bvalid_lane3_i;
       wire    [1:0]      s_axi_bresp_lane3_i;
       wire    [1:0]      s_axi_rresp_lane3_i;
       wire               s_axi_bready_lane3_i;
       wire               s_axi_awready_lane3_i;
       wire               s_axi_arready_lane3_i;
       wire               s_axi_wready_lane3_i;
       wire               s_axi_rready_lane3_i;
       wire               link_reset_i;
       wire               sysreset_from_vio_i;
       wire               gtreset_from_vio_i;
       wire               rx_cdrovrden_i;
       wire               gt_reset_i;
       wire               gt_reset_i_tmp;

       wire bufg_gt_clr_out;
   localparam DLY_FACTOR = 16;
   reg                          bufg_gt_clr_delayed = 1'b1;
   reg [DLY_FACTOR-1:0]         bufg_gt_clr_dly_cnt = 'h0;



//---{

//---}
    wire                     refclk1_in;
 
    wire                     sysreset_from_support;
     wire                    tied_to_ground_i;
     wire    [280:0]          tied_to_ground_vec_i;
     wire                      tied_to_vcc_i;
     assign tied_to_ground_i             = 1'b0;
     assign tied_to_ground_vec_i         = 281'h0;
     assign tied_to_vcc_i                = 1'b1;
//------------------------------------------------------------------------------


 //*********************************Main Body of Code**********************************
     // System Interface
     assign  power_down_i      =   1'b0;
    // AXI4 Lite Interface
     assign  s_axi_awaddr_i    =  32'h0;
     assign  s_axi_wdata_i     =  16'h0;
     assign  s_axi_awvalid_i   =  1'b0;
     assign  s_axi_wvalid_i    =  1'b0;
     assign  s_axi_wstrb_i    =  'd0;
     assign  s_axi_arvalid_i   =  1'b0;
     assign  s_axi_rvalid_i    =  1'b0;
     assign  s_axi_awvalid_lane1_i   =  1'b0;
     assign  s_axi_wvalid_lane1_i    =  1'b0;
     assign  s_axi_wstrb_lane1_i    =  'd0;
     assign  s_axi_arvalid_lane1_i   =  1'b0;
     assign  s_axi_rvalid_lane1_i    =  1'b0;
     assign  s_axi_awvalid_lane2_i   =  1'b0;
     assign  s_axi_wvalid_lane2_i    =  1'b0;
     assign  s_axi_wstrb_lane2_i    =  'd0;
     assign  s_axi_arvalid_lane2_i   =  1'b0;
     assign  s_axi_rvalid_lane2_i    =  1'b0;
     assign  s_axi_awvalid_lane3_i   =  1'b0;
     assign  s_axi_wvalid_lane3_i    =  1'b0;
     assign  s_axi_wstrb_lane3_i    =  'd0;
     assign  s_axi_arvalid_lane3_i   =  1'b0;
     assign  s_axi_rvalid_lane3_i    =  1'b0;


//___________________________Module Instantiations______________________________

//------------------------------------------------------------------------------
// GT common is present only when QPLL is used (i.e. speed is more than 6.5g)
//------------------------------------------------------------------------------
//                      ____________
//    qpll0/1_refclk   |            | gt_qpllclk_quad1_i    (upto 4 based upon no. of Quads)
//  ------------------>|            |------------------>
//                     |            | gt_qpllrefclk_quad1_i (upto 4 based upon no. of Quads)
//      qpll0/1_reset  |  GT Common |------------------>
//  ------------------>|            | gt_qplllock_quad1_i        --"--
//                     |            |------------------>
//  qpll0/1_lock_detclk|            | gt_qpllrefclklost_quad1_i  --"--
//  ------------------>|            |------------------>
//                     |            |
//                     |____________|
//
//
//
//------------------------------------------------------------------------------
  // add physical instance of GT ultrascale common module here
    //--------------------------------------------------------------------------
    // no. of channels are max. 4, single instance of GT Common
    //----------------------------------------------------------------------
        wire qpll0_lock_quad1_out;
        wire qpll0_refclklost1_out;
        wire gt_qpllclk_quad1_i;
        wire gt_qpllrefclk_quad1_i;
        wire gt_qpllrefclklost_quad1_i;
        wire gt_qplllock_quad1_i;

        aurora_64b66b_port7_logic_gt_common_wrapper ultrascale_gt_common_1
        (
         .qpll0_refclk                (refclk1_in),                   // input
         .qpll0_reset                 (gt_to_common_qpllreset_i),     // input
       //.qpll0_lock_detclk           (init_clk_out),                 // input
	 .qpll0_lock_detclk           (init_clk),                     // input

         .qpll0_lock                  (qpll0_lock_quad1_out),         // output
         .qpll0_outclk                (gt_qpllclk_quad1_i),           // output
         .qpll0_outrefclk             (gt_qpllrefclk_quad1_i),        // output
         .qpll0_refclklost            (qpll0_refclklost1_out)
        );

       assign gt_qplllock_quad1_i       = qpll0_lock_quad1_out;
       assign gt_qpllrefclklost_quad1_i = qpll0_refclklost1_out;

    //----------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------

//------------------------------------------------------------------------------
//--- assigning output values for 8 series quad pll starts
//assumption: quad will be based upon no. of lanes chosen by user
    assign gt_qpllclk_quad1_out     =  gt_qpllclk_quad1_i   ;
    assign gt_qpllrefclk_quad1_out  =  gt_qpllrefclk_quad1_i;
    assign gt_qplllock_quad1_out    =  gt_qplllock_quad1_i  ;
    assign gt_qpllrefclklost_quad1_out = gt_qpllrefclklost_quad1_i;





    //wire gt_qpllrefclklost_i;

    //assign gt_qpllrefclklost_out =  gt_qpllrefclklost_i ;
    //assign gt_qplllock_out       =  gt_qplllock_i;
//--- assigning output values for 8 series quad pll ends

 //--- Instance of GT Ultrascale differential buffer ---------//
 
 
  IBUFDS_GTE4 IBUFDS_GTE4_refclk1 
  (
    .I     (gt_refclk1_p),
    .IB    (gt_refclk1_n),
    .CEB   (1'b0),
    .O     (refclk1_in),
    .ODIV2 ()
  );
//For versal devices and line rate > 16.375, the number of IBUFDS should be always 1(Needs to be changed)


     //(
     //    .CLK_LOCKED    (gt_pll_lock),
     // );

//------------------------------------------------------------------------------
//                      ____________
//                     |            | 
//                     |            |
//                     |            | USER_CLK
//                     |  clocking  |------------------>
//     CLK             |   module   | SYNC_CLK
//  ------------------>|            |------------------>
//    CLK_LOCKED       |            | QPLL_NOT_LOCKED
//  ------------------>|            |------------------>
//                     |            |
//                     |____________|
//
//
//
//------------------------------------------------------------------------------


   always @(posedge init_clk or posedge bufg_gt_clr_out) begin
      if (bufg_gt_clr_out) begin
         bufg_gt_clr_delayed <= 1'b1;
         bufg_gt_clr_dly_cnt <= 'h0;
      end else begin
         bufg_gt_clr_dly_cnt <= bufg_gt_clr_dly_cnt + 1;
         if (&bufg_gt_clr_dly_cnt)
           bufg_gt_clr_delayed <= 1'b0;
      end
   end

     // Instantiate a clock module for clock division.
     aurora_64b66b_port7_logic_CLOCK_MODULE clock_module_i
     (
        // .INIT_CLK_P                    (init_clk_p),
        // .INIT_CLK_N                    (init_clk_n),
       //.INIT_CLK_IN                   (INIT_CLK_IN)   ,   // i/p 
         .CLK                           (tx_out_clk)    ,   // i/p // this is output from GT module txoutclk_out lane 0
         .CLK_LOCKED                    (bufg_gt_clr_delayed)   ,   // i/p // connect to bufg_gt_clr_out in GT module

         //.INIT_CLK_O                    (init_clk_out)    ,   // o/p
         .USER_CLK                      (user_clk_out)    ,   // o/p // this is sync_clk/2 (use as userclk2_clk)
         .SYNC_CLK                      (sync_clk_out)    ,   // o/p // this is sync clk   (use as userclk_clk)
         .MMCM_NOT_LOCKED    (mmcm_not_locked_out) // o/p // connect to gtwiz_userclk_tx_active_out
     );

  //  outputs
  assign gt_reset_out          =  pma_init_i;
  assign gt_refclk1_out        =  refclk1_in;

  //assign init_clk_out          =  init_clk_out;
  //assign user_clk_out          =  user_clk_out;
  //assign sync_clk_out          =  sync_clk_out;
  //assign mmcm_not_locked_out   =  mmcm_not_locked_out;
  assign tx_lock               =  gt_pll_lock;

//------------------------------------------------------------------------------
//                      ____________
//    RESET            |            | SYSTEM_RESET
//  ------------------>|            |------------------>
//    USER_CLK         |            | GT_RESET_OUT
//  ------------------>|   Reset    |------------------>
//     INIT_CLK        |   module   |
//  ------------------>|            |
//    GT_RESET_IN      |            |
//  ------------------>|            |
//                     |____________|
//
//------------------------------------------------------------------------------
      wire sysreset_to_core_sync;

    aurora_64b66b_port7_logic_rst_sync #
    (
        .c_mtbf_stages (5)
    )reset_pb_sync
    (
        .prmry_in     (reset_pb),
        .scndry_aclk  (user_clk_out),
        .scndry_out   (sysreset_to_core_sync)
    );

    aurora_64b66b_port7_logic_rst_sync #
    (
        .c_mtbf_stages (5)
    )gt_reset_sync
    (
        .prmry_in     (pma_init),
        .scndry_aclk  (init_clk),
        .scndry_out   (pma_init_sync)
    );

     // Instantiate reset module to generate system reset
     aurora_64b66b_port7_logic_SUPPORT_RESET_LOGIC support_reset_logic_i
     (
         .RESET(sysreset_to_core_sync),
         .USER_CLK              (user_clk_out),               // input
         .INIT_CLK              (init_clk),               // input
         .GT_RESET_IN           (pma_init_sync),                 // input

         .SYSTEM_RESET          (sysreset_from_support),
         .GT_RESET_OUT          (pma_init_i)                // output
     );

//----- Instance of core in shared mode -----
aurora_64b66b_port7_logic_core   aurora_64b66b_port7_logic_core_i
     (
       // TX AXI4-S Interface
       .s_axi_tx_tdata                (s_axi_tx_tdata),


       .s_axi_tx_tvalid               (s_axi_tx_tvalid),
       .s_axi_tx_tready               (s_axi_tx_tready),

       // RX AXI4-S Interface
       .m_axi_rx_tdata                (m_axi_rx_tdata),
       .m_axi_rx_tvalid               (m_axi_rx_tvalid),


       //-----------------------
       //-----------------------

       // GTX Serial I/O
       .rxp                           (rxp),
       .rxn                           (rxn),
       .txp                           (txp),
       .txn                           (txn),

       //GTX Reference Clock Interface
       .gt_refclk1                    (refclk1_in),
       .hard_err                      (hard_err),
       .soft_err                      (soft_err),

       // Status
       .channel_up                    (channel_up),
       .lane_up                       (lane_up),


       // System Interface
       .mmcm_not_locked               (mmcm_not_locked_out),//connect to gtwiz_userclk_tx_active_out of multi GT
       .user_clk                      (user_clk_out),
       .sync_clk                      (sync_clk_out),

         .sysreset_to_core(sysreset_from_support),
       .gt_rxcdrovrden_in               (gt_rxcdrovrden_in),
       .power_down                      (power_down),
       .loopback                        (loopback),
       .pma_init                        (pma_init_i),
       .rst_drp_strt                    (pma_init_i),
       .gt_pll_lock                     (gt_pll_lock),
       /// Assumption: GT common is always out of Ultrascale GT in qpll0 base cases
       .gt_qpllclk_quad1_in                     (gt_qpllclk_quad1_i    ),//(gtrefclk00_in_0),
       .gt_qpllrefclk_quad1_in                  (gt_qpllrefclk_quad1_i ),
       .gt_qplllock_quad1_in                    (gt_qplllock_quad1_i   ),
       .gt_qpllrefclklost_quad1                 (gt_qpllrefclklost_quad1_i),





       .gt_to_common_qpllreset_out              (gt_to_common_qpllreset_i    ),
       //.gt_qplllock_in       (gt_qplllock_i        ),
       //.gt_qpllrefclklost_in (gt_qpllrefclklost_i  ),


     // ---------- AXI4-Lite input signals ---------------
       .s_axi_awaddr        (s_axi_awaddr),
       .s_axi_awvalid       (s_axi_awvalid),
       .s_axi_awready       (s_axi_awready),
       .s_axi_awaddr_lane1        (s_axi_awaddr_lane1),
       .s_axi_awvalid_lane1       (s_axi_awvalid_lane1),
       .s_axi_awready_lane1       (s_axi_awready_lane1),
       .s_axi_awaddr_lane2        (s_axi_awaddr_lane2),
       .s_axi_awvalid_lane2       (s_axi_awvalid_lane2),
       .s_axi_awready_lane2       (s_axi_awready_lane2),
       .s_axi_awaddr_lane3        (s_axi_awaddr_lane3),
       .s_axi_awvalid_lane3       (s_axi_awvalid_lane3),
       .s_axi_awready_lane3       (s_axi_awready_lane3),
       .s_axi_wdata         (s_axi_wdata),
       .s_axi_wstrb         (s_axi_wstrb),
       .s_axi_wvalid        (s_axi_wvalid),
       .s_axi_wready        (s_axi_wready),
       .s_axi_bvalid        (s_axi_bvalid),
       .s_axi_bresp        (s_axi_bresp),
       .s_axi_bready        (s_axi_bready),
       .s_axi_wdata_lane1         (s_axi_wdata_lane1),
       .s_axi_wstrb_lane1         (s_axi_wstrb_lane1),
       .s_axi_wvalid_lane1        (s_axi_wvalid_lane1),
       .s_axi_wready_lane1        (s_axi_wready_lane1),
       .s_axi_bvalid_lane1        (s_axi_bvalid_lane1),
       .s_axi_bresp_lane1        (s_axi_bresp_lane1),
       .s_axi_bready_lane1        (s_axi_bready_lane1),
       .s_axi_wdata_lane2         (s_axi_wdata_lane2),
       .s_axi_wstrb_lane2         (s_axi_wstrb_lane2),
       .s_axi_wvalid_lane2        (s_axi_wvalid_lane2),
       .s_axi_wready_lane2        (s_axi_wready_lane2),
       .s_axi_bvalid_lane2        (s_axi_bvalid_lane2),
       .s_axi_bresp_lane2        (s_axi_bresp_lane2),
       .s_axi_bready_lane2        (s_axi_bready_lane2),
       .s_axi_wdata_lane3         (s_axi_wdata_lane3),
       .s_axi_wstrb_lane3         (s_axi_wstrb_lane3),
       .s_axi_wvalid_lane3        (s_axi_wvalid_lane3),
       .s_axi_wready_lane3        (s_axi_wready_lane3),
       .s_axi_bvalid_lane3        (s_axi_bvalid_lane3),
       .s_axi_bresp_lane3        (s_axi_bresp_lane3),
       .s_axi_bready_lane3        (s_axi_bready_lane3),
       .s_axi_araddr        (s_axi_araddr),
       .s_axi_arvalid       (s_axi_arvalid),
       .s_axi_arready       (s_axi_arready),
       .s_axi_araddr_lane1        (s_axi_araddr_lane1),
       .s_axi_arvalid_lane1       (s_axi_arvalid_lane1),
       .s_axi_arready_lane1       (s_axi_arready_lane1),
       .s_axi_araddr_lane2        (s_axi_araddr_lane2),
       .s_axi_arvalid_lane2       (s_axi_arvalid_lane2),
       .s_axi_arready_lane2       (s_axi_arready_lane2),
       .s_axi_araddr_lane3        (s_axi_araddr_lane3),
       .s_axi_arvalid_lane3       (s_axi_arvalid_lane3),
       .s_axi_arready_lane3       (s_axi_arready_lane3),
       .s_axi_rdata         (s_axi_rdata),
       .s_axi_rvalid        (s_axi_rvalid),
       .s_axi_rready        (s_axi_rready),
       .s_axi_rresp        (s_axi_rresp),
       .s_axi_rdata_lane1         (s_axi_rdata_lane1),
       .s_axi_rvalid_lane1        (s_axi_rvalid_lane1),
       .s_axi_rready_lane1        (s_axi_rready_lane1),
       .s_axi_rresp_lane1        (s_axi_rresp_lane1),
       .s_axi_rdata_lane2         (s_axi_rdata_lane2),
       .s_axi_rvalid_lane2        (s_axi_rvalid_lane2),
       .s_axi_rready_lane2        (s_axi_rready_lane2),
       .s_axi_rresp_lane2        (s_axi_rresp_lane2),
       .s_axi_rdata_lane3         (s_axi_rdata_lane3),
       .s_axi_rvalid_lane3        (s_axi_rvalid_lane3),
       .s_axi_rready_lane3        (s_axi_rready_lane3),
       .s_axi_rresp_lane3        (s_axi_rresp_lane3),


       //.init_clk                              (init_clk_out),
       .init_clk                              (init_clk),
       .link_reset_out                        (link_reset_out),

       .gt_rxusrclk_out (gt_rxusrclk_out),
       //------------------------ RX Margin Analysis Ports ------------------------
       .gt_eyescandataerror          (gt_eyescandataerror    ),
       .gt_eyescanreset              (gt_eyescanreset   ),
       .gt_eyescantrigger            (gt_eyescantrigger   ),
       //------------------- Receive Ports - RX Equalizer Ports -------------------
       .gt_rxcdrhold                 (gt_rxcdrhold   ),
       .gt_rxdfelpmreset             (gt_rxdfelpmreset   ),
       .gt_rxlpmen                   (gt_rxlpmen   ),
       .gt_rxpmareset                (gt_rxpmareset   ),
       .gt_rxpcsreset                (gt_rxpcsreset    ),
       .gt_rxrate                    (gt_rxrate        ),
       .gt_rxbufreset                (gt_rxbufreset    ),
       .gt_rxpmaresetdone            (gt_rxpmaresetdone     ),
       .gt_rxprbssel                 (gt_rxprbssel        ),
       .gt_rxprbserr                 (gt_rxprbserr        ),
       .gt_rxprbscntreset            (gt_rxprbscntreset   ),
       .gt_rxresetdone               (gt_rxresetdone    ),
       .gt_rxbufstatus               (gt_rxbufstatus    ),

       //---------------------- TX Configurable Driver Ports ----------------------
       .gt_txpostcursor              (gt_txpostcursor   ),
       .gt_txdiffctrl                (gt_txdiffctrl   ),
       .gt_txprecursor               (gt_txprecursor   ),
       //--------------- Transmit Ports - TX Polarity Control Ports ---------------
       .gt_txpolarity                (gt_txpolarity   ),
       .gt_txinhibit                 (gt_txinhibit   ),
       .gt_txpmareset                (gt_txpmareset    ),
       .gt_txpcsreset                (gt_txpcsreset    ),
       .gt_txprbssel                 (gt_txprbssel     ),
       .gt_txprbsforceerr            (gt_txprbsforceerr   ),
       .gt_txbufstatus               (gt_txbufstatus      ),
       .gt_txresetdone              (gt_txresetdone    ),
       .gt_pcsrsvdin                 (gt_pcsrsvdin   ),
       .gt_dmonitorout               (gt_dmonitorout        ),
       .gt_cplllock                  (gt_cplllock    ),
        .sys_reset_out(sys_reset_out),
    //----------- GT POWERGOOD STATUS Port -----------
          .gt_powergood                   (gt_powergood),


        .bufg_gt_clr_out              (bufg_gt_clr_out),// connect to clk locked port of clock module

       .tx_out_clk                            (tx_out_clk)
     );

    assign  gt_qplllock = gt_qplllock_quad1_i ; 
  assign mmcm_not_locked_out2   =  !mmcm_not_locked_out;




 endmodule
