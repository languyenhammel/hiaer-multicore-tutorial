// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
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
// DO NOT MODIFY THIS FILE.

// IP VLNV: xilinx.com:ip:aurora_64b66b:12.0
// IP Revision: 15

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
aurora_64b66b_port7_logic your_instance_name (
  .rxp(rxp),                                                  // input wire [0 : 3] rxp
  .rxn(rxn),                                                  // input wire [0 : 3] rxn
  .reset_pb(reset_pb),                                        // input wire reset_pb
  .power_down(power_down),                                    // input wire power_down
  .pma_init(pma_init),                                        // input wire pma_init
  .loopback(loopback),                                        // input wire [2 : 0] loopback
  .txp(txp),                                                  // output wire [0 : 3] txp
  .txn(txn),                                                  // output wire [0 : 3] txn
  .hard_err(hard_err),                                        // output wire hard_err
  .soft_err(soft_err),                                        // output wire soft_err
  .channel_up(channel_up),                                    // output wire channel_up
  .lane_up(lane_up),                                          // output wire [0 : 3] lane_up
  .tx_out_clk(tx_out_clk),                                    // output wire tx_out_clk
  .gt_pll_lock(gt_pll_lock),                                  // output wire gt_pll_lock
  .s_axi_tx_tdata(s_axi_tx_tdata),                            // input wire [0 : 255] s_axi_tx_tdata
  .s_axi_tx_tvalid(s_axi_tx_tvalid),                          // input wire s_axi_tx_tvalid
  .s_axi_tx_tready(s_axi_tx_tready),                          // output wire s_axi_tx_tready
  .m_axi_rx_tdata(m_axi_rx_tdata),                            // output wire [0 : 255] m_axi_rx_tdata
  .m_axi_rx_tvalid(m_axi_rx_tvalid),                          // output wire m_axi_rx_tvalid
  .mmcm_not_locked_out(mmcm_not_locked_out),                  // output wire mmcm_not_locked_out
  .s_axi_awaddr(s_axi_awaddr),                                // input wire [31 : 0] s_axi_awaddr
  .s_axi_awaddr_lane1(s_axi_awaddr_lane1),                    // input wire [31 : 0] s_axi_awaddr_lane1
  .s_axi_awaddr_lane2(s_axi_awaddr_lane2),                    // input wire [31 : 0] s_axi_awaddr_lane2
  .s_axi_awaddr_lane3(s_axi_awaddr_lane3),                    // input wire [31 : 0] s_axi_awaddr_lane3
  .s_axi_rresp(s_axi_rresp),                                  // output wire [1 : 0] s_axi_rresp
  .s_axi_rresp_lane1(s_axi_rresp_lane1),                      // output wire [1 : 0] s_axi_rresp_lane1
  .s_axi_rresp_lane2(s_axi_rresp_lane2),                      // output wire [1 : 0] s_axi_rresp_lane2
  .s_axi_rresp_lane3(s_axi_rresp_lane3),                      // output wire [1 : 0] s_axi_rresp_lane3
  .s_axi_bresp(s_axi_bresp),                                  // output wire [1 : 0] s_axi_bresp
  .s_axi_bresp_lane1(s_axi_bresp_lane1),                      // output wire [1 : 0] s_axi_bresp_lane1
  .s_axi_bresp_lane2(s_axi_bresp_lane2),                      // output wire [1 : 0] s_axi_bresp_lane2
  .s_axi_bresp_lane3(s_axi_bresp_lane3),                      // output wire [1 : 0] s_axi_bresp_lane3
  .s_axi_wstrb(s_axi_wstrb),                                  // input wire [3 : 0] s_axi_wstrb
  .s_axi_wstrb_lane1(s_axi_wstrb_lane1),                      // input wire [3 : 0] s_axi_wstrb_lane1
  .s_axi_wstrb_lane2(s_axi_wstrb_lane2),                      // input wire [3 : 0] s_axi_wstrb_lane2
  .s_axi_wstrb_lane3(s_axi_wstrb_lane3),                      // input wire [3 : 0] s_axi_wstrb_lane3
  .s_axi_wdata(s_axi_wdata),                                  // input wire [31 : 0] s_axi_wdata
  .s_axi_wdata_lane1(s_axi_wdata_lane1),                      // input wire [31 : 0] s_axi_wdata_lane1
  .s_axi_wdata_lane2(s_axi_wdata_lane2),                      // input wire [31 : 0] s_axi_wdata_lane2
  .s_axi_wdata_lane3(s_axi_wdata_lane3),                      // input wire [31 : 0] s_axi_wdata_lane3
  .s_axi_araddr(s_axi_araddr),                                // input wire [31 : 0] s_axi_araddr
  .s_axi_araddr_lane1(s_axi_araddr_lane1),                    // input wire [31 : 0] s_axi_araddr_lane1
  .s_axi_araddr_lane2(s_axi_araddr_lane2),                    // input wire [31 : 0] s_axi_araddr_lane2
  .s_axi_araddr_lane3(s_axi_araddr_lane3),                    // input wire [31 : 0] s_axi_araddr_lane3
  .s_axi_rdata(s_axi_rdata),                                  // output wire [31 : 0] s_axi_rdata
  .s_axi_rdata_lane1(s_axi_rdata_lane1),                      // output wire [31 : 0] s_axi_rdata_lane1
  .s_axi_rdata_lane2(s_axi_rdata_lane2),                      // output wire [31 : 0] s_axi_rdata_lane2
  .s_axi_rdata_lane3(s_axi_rdata_lane3),                      // output wire [31 : 0] s_axi_rdata_lane3
  .s_axi_bready(s_axi_bready),                                // input wire s_axi_bready
  .s_axi_bready_lane1(s_axi_bready_lane1),                    // input wire s_axi_bready_lane1
  .s_axi_bready_lane2(s_axi_bready_lane2),                    // input wire s_axi_bready_lane2
  .s_axi_bready_lane3(s_axi_bready_lane3),                    // input wire s_axi_bready_lane3
  .s_axi_awvalid(s_axi_awvalid),                              // input wire s_axi_awvalid
  .s_axi_awvalid_lane1(s_axi_awvalid_lane1),                  // input wire s_axi_awvalid_lane1
  .s_axi_awvalid_lane2(s_axi_awvalid_lane2),                  // input wire s_axi_awvalid_lane2
  .s_axi_awvalid_lane3(s_axi_awvalid_lane3),                  // input wire s_axi_awvalid_lane3
  .s_axi_awready(s_axi_awready),                              // output wire s_axi_awready
  .s_axi_awready_lane1(s_axi_awready_lane1),                  // output wire s_axi_awready_lane1
  .s_axi_awready_lane2(s_axi_awready_lane2),                  // output wire s_axi_awready_lane2
  .s_axi_awready_lane3(s_axi_awready_lane3),                  // output wire s_axi_awready_lane3
  .s_axi_wvalid(s_axi_wvalid),                                // input wire s_axi_wvalid
  .s_axi_wvalid_lane1(s_axi_wvalid_lane1),                    // input wire s_axi_wvalid_lane1
  .s_axi_wvalid_lane2(s_axi_wvalid_lane2),                    // input wire s_axi_wvalid_lane2
  .s_axi_wvalid_lane3(s_axi_wvalid_lane3),                    // input wire s_axi_wvalid_lane3
  .s_axi_wready(s_axi_wready),                                // output wire s_axi_wready
  .s_axi_wready_lane1(s_axi_wready_lane1),                    // output wire s_axi_wready_lane1
  .s_axi_wready_lane2(s_axi_wready_lane2),                    // output wire s_axi_wready_lane2
  .s_axi_wready_lane3(s_axi_wready_lane3),                    // output wire s_axi_wready_lane3
  .s_axi_bvalid(s_axi_bvalid),                                // output wire s_axi_bvalid
  .s_axi_bvalid_lane1(s_axi_bvalid_lane1),                    // output wire s_axi_bvalid_lane1
  .s_axi_bvalid_lane2(s_axi_bvalid_lane2),                    // output wire s_axi_bvalid_lane2
  .s_axi_bvalid_lane3(s_axi_bvalid_lane3),                    // output wire s_axi_bvalid_lane3
  .s_axi_arvalid(s_axi_arvalid),                              // input wire s_axi_arvalid
  .s_axi_arvalid_lane1(s_axi_arvalid_lane1),                  // input wire s_axi_arvalid_lane1
  .s_axi_arvalid_lane2(s_axi_arvalid_lane2),                  // input wire s_axi_arvalid_lane2
  .s_axi_arvalid_lane3(s_axi_arvalid_lane3),                  // input wire s_axi_arvalid_lane3
  .s_axi_arready(s_axi_arready),                              // output wire s_axi_arready
  .s_axi_arready_lane1(s_axi_arready_lane1),                  // output wire s_axi_arready_lane1
  .s_axi_arready_lane2(s_axi_arready_lane2),                  // output wire s_axi_arready_lane2
  .s_axi_arready_lane3(s_axi_arready_lane3),                  // output wire s_axi_arready_lane3
  .s_axi_rvalid(s_axi_rvalid),                                // output wire s_axi_rvalid
  .s_axi_rvalid_lane1(s_axi_rvalid_lane1),                    // output wire s_axi_rvalid_lane1
  .s_axi_rvalid_lane2(s_axi_rvalid_lane2),                    // output wire s_axi_rvalid_lane2
  .s_axi_rvalid_lane3(s_axi_rvalid_lane3),                    // output wire s_axi_rvalid_lane3
  .s_axi_rready(s_axi_rready),                                // input wire s_axi_rready
  .s_axi_rready_lane1(s_axi_rready_lane1),                    // input wire s_axi_rready_lane1
  .s_axi_rready_lane2(s_axi_rready_lane2),                    // input wire s_axi_rready_lane2
  .s_axi_rready_lane3(s_axi_rready_lane3),                    // input wire s_axi_rready_lane3
  .init_clk(init_clk),                                        // input wire init_clk
  .link_reset_out(link_reset_out),                            // output wire link_reset_out
  .gt_refclk1_p(gt_refclk1_p),                                // input wire gt_refclk1_p
  .gt_refclk1_n(gt_refclk1_n),                                // input wire gt_refclk1_n
  .user_clk_out(user_clk_out),                                // output wire user_clk_out
  .sync_clk_out(sync_clk_out),                                // output wire sync_clk_out
  .gt_qpllclk_quad1_out(gt_qpllclk_quad1_out),                // output wire gt_qpllclk_quad1_out
  .gt_qpllrefclk_quad1_out(gt_qpllrefclk_quad1_out),          // output wire gt_qpllrefclk_quad1_out
  .gt_qpllrefclklost_quad1_out(gt_qpllrefclklost_quad1_out),  // output wire gt_qpllrefclklost_quad1_out
  .gt_qplllock_quad1_out(gt_qplllock_quad1_out),              // output wire gt_qplllock_quad1_out
  .gt_rxcdrovrden_in(gt_rxcdrovrden_in),                      // input wire gt_rxcdrovrden_in
  .gt_rxusrclk_out(gt_rxusrclk_out),                          // output wire gt_rxusrclk_out
  .sys_reset_out(sys_reset_out),                              // output wire sys_reset_out
  .gt_reset_out(gt_reset_out),                                // output wire gt_reset_out
  .gt_refclk1_out(gt_refclk1_out),                            // output wire gt_refclk1_out
  .gt_qplllock(gt_qplllock),                                  // output wire [0 : 0] gt_qplllock
  .gt_eyescanreset(gt_eyescanreset),                          // input wire [3 : 0] gt_eyescanreset
  .gt_eyescandataerror(gt_eyescandataerror),                  // output wire [3 : 0] gt_eyescandataerror
  .gt_rxlpmen(gt_rxlpmen),                                    // input wire [3 : 0] gt_rxlpmen
  .gt_eyescantrigger(gt_eyescantrigger),                      // input wire [3 : 0] gt_eyescantrigger
  .gt_rxcdrhold(gt_rxcdrhold),                                // input wire [3 : 0] gt_rxcdrhold
  .gt_rxdfelpmreset(gt_rxdfelpmreset),                        // input wire [3 : 0] gt_rxdfelpmreset
  .gt_rxpmareset(gt_rxpmareset),                              // input wire [3 : 0] gt_rxpmareset
  .gt_rxpcsreset(gt_rxpcsreset),                              // input wire [3 : 0] gt_rxpcsreset
  .gt_rxbufreset(gt_rxbufreset),                              // input wire [3 : 0] gt_rxbufreset
  .gt_rxpmaresetdone(gt_rxpmaresetdone),                      // output wire [3 : 0] gt_rxpmaresetdone
  .gt_rxprbssel(gt_rxprbssel),                                // input wire [15 : 0] gt_rxprbssel
  .gt_rxprbserr(gt_rxprbserr),                                // output wire [3 : 0] gt_rxprbserr
  .gt_rxprbscntreset(gt_rxprbscntreset),                      // input wire [3 : 0] gt_rxprbscntreset
  .gt_rxresetdone(gt_rxresetdone),                            // output wire [3 : 0] gt_rxresetdone
  .gt_rxbufstatus(gt_rxbufstatus),                            // output wire [11 : 0] gt_rxbufstatus
  .gt_powergood(gt_powergood),                                // output wire [3 : 0] gt_powergood
  .gt_txpostcursor(gt_txpostcursor),                          // input wire [19 : 0] gt_txpostcursor
  .gt_txdiffctrl(gt_txdiffctrl),                              // input wire [19 : 0] gt_txdiffctrl
  .gt_txinhibit(gt_txinhibit),                                // input wire [3 : 0] gt_txinhibit
  .gt_pcsrsvdin(gt_pcsrsvdin),                                // input wire [63 : 0] gt_pcsrsvdin
  .gt_txprecursor(gt_txprecursor),                            // input wire [19 : 0] gt_txprecursor
  .gt_txpolarity(gt_txpolarity),                              // input wire [3 : 0] gt_txpolarity
  .gt_txpmareset(gt_txpmareset),                              // input wire [3 : 0] gt_txpmareset
  .gt_txpcsreset(gt_txpcsreset),                              // input wire [3 : 0] gt_txpcsreset
  .gt_txprbssel(gt_txprbssel),                                // input wire [15 : 0] gt_txprbssel
  .gt_txprbsforceerr(gt_txprbsforceerr),                      // input wire [3 : 0] gt_txprbsforceerr
  .gt_txbufstatus(gt_txbufstatus),                            // output wire [7 : 0] gt_txbufstatus
  .gt_txresetdone(gt_txresetdone),                            // output wire [3 : 0] gt_txresetdone
  .gt_dmonitorout(gt_dmonitorout),                            // output wire [63 : 0] gt_dmonitorout
  .gt_cplllock(gt_cplllock),                                  // output wire [3 : 0] gt_cplllock
  .gt_rxrate(gt_rxrate)                                      // input wire [11 : 0] gt_rxrate
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file aurora_64b66b_port7_logic.v when simulating
// the core, aurora_64b66b_port7_logic. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

