-- (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.
-- IP VLNV: xilinx.com:ip:aurora_64b66b:12.0
-- IP Revision: 15

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT aurora_64b66b_port7_logic
  PORT (
    rxp : IN STD_LOGIC_VECTOR(0 TO 3);
    rxn : IN STD_LOGIC_VECTOR(0 TO 3);
    reset_pb : IN STD_LOGIC;
    power_down : IN STD_LOGIC;
    pma_init : IN STD_LOGIC;
    loopback : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    txp : OUT STD_LOGIC_VECTOR(0 TO 3);
    txn : OUT STD_LOGIC_VECTOR(0 TO 3);
    hard_err : OUT STD_LOGIC;
    soft_err : OUT STD_LOGIC;
    channel_up : OUT STD_LOGIC;
    lane_up : OUT STD_LOGIC_VECTOR(0 TO 3);
    tx_out_clk : OUT STD_LOGIC;
    gt_pll_lock : OUT STD_LOGIC;
    s_axi_tx_tdata : IN STD_LOGIC_VECTOR(0 TO 255);
    s_axi_tx_tvalid : IN STD_LOGIC;
    s_axi_tx_tready : OUT STD_LOGIC;
    m_axi_rx_tdata : OUT STD_LOGIC_VECTOR(0 TO 255);
    m_axi_rx_tvalid : OUT STD_LOGIC;
    mmcm_not_locked_out : OUT STD_LOGIC;
    s_axi_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_awaddr_lane1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_awaddr_lane2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_awaddr_lane3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rresp_lane1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rresp_lane2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rresp_lane3 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bresp_lane1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bresp_lane2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bresp_lane3 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wstrb_lane1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wstrb_lane2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wstrb_lane3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wdata_lane1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wdata_lane2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wdata_lane3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_araddr_lane1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_araddr_lane2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_araddr_lane3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rdata_lane1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rdata_lane2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rdata_lane3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_bready : IN STD_LOGIC;
    s_axi_bready_lane1 : IN STD_LOGIC;
    s_axi_bready_lane2 : IN STD_LOGIC;
    s_axi_bready_lane3 : IN STD_LOGIC;
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awvalid_lane1 : IN STD_LOGIC;
    s_axi_awvalid_lane2 : IN STD_LOGIC;
    s_axi_awvalid_lane3 : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;
    s_axi_awready_lane1 : OUT STD_LOGIC;
    s_axi_awready_lane2 : OUT STD_LOGIC;
    s_axi_awready_lane3 : OUT STD_LOGIC;
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wvalid_lane1 : IN STD_LOGIC;
    s_axi_wvalid_lane2 : IN STD_LOGIC;
    s_axi_wvalid_lane3 : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;
    s_axi_wready_lane1 : OUT STD_LOGIC;
    s_axi_wready_lane2 : OUT STD_LOGIC;
    s_axi_wready_lane3 : OUT STD_LOGIC;
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bvalid_lane1 : OUT STD_LOGIC;
    s_axi_bvalid_lane2 : OUT STD_LOGIC;
    s_axi_bvalid_lane3 : OUT STD_LOGIC;
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arvalid_lane1 : IN STD_LOGIC;
    s_axi_arvalid_lane2 : IN STD_LOGIC;
    s_axi_arvalid_lane3 : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;
    s_axi_arready_lane1 : OUT STD_LOGIC;
    s_axi_arready_lane2 : OUT STD_LOGIC;
    s_axi_arready_lane3 : OUT STD_LOGIC;
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rvalid_lane1 : OUT STD_LOGIC;
    s_axi_rvalid_lane2 : OUT STD_LOGIC;
    s_axi_rvalid_lane3 : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC;
    s_axi_rready_lane1 : IN STD_LOGIC;
    s_axi_rready_lane2 : IN STD_LOGIC;
    s_axi_rready_lane3 : IN STD_LOGIC;
    init_clk : IN STD_LOGIC;
    link_reset_out : OUT STD_LOGIC;
    gt_refclk1_p : IN STD_LOGIC;
    gt_refclk1_n : IN STD_LOGIC;
    user_clk_out : OUT STD_LOGIC;
    sync_clk_out : OUT STD_LOGIC;
    gt_qpllclk_quad1_out : OUT STD_LOGIC;
    gt_qpllrefclk_quad1_out : OUT STD_LOGIC;
    gt_qpllrefclklost_quad1_out : OUT STD_LOGIC;
    gt_qplllock_quad1_out : OUT STD_LOGIC;
    gt_rxcdrovrden_in : IN STD_LOGIC;
    gt_rxusrclk_out : OUT STD_LOGIC;
    sys_reset_out : OUT STD_LOGIC;
    gt_reset_out : OUT STD_LOGIC;
    gt_refclk1_out : OUT STD_LOGIC;
    gt_qplllock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gt_eyescanreset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_eyescandataerror : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxlpmen : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_eyescantrigger : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxcdrhold : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxdfelpmreset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxpmareset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxpcsreset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxbufreset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxpmaresetdone : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxprbssel : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt_rxprbserr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxprbscntreset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxresetdone : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxbufstatus : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    gt_powergood : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_txpostcursor : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    gt_txdiffctrl : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    gt_txinhibit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_pcsrsvdin : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt_txprecursor : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    gt_txpolarity : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_txpmareset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_txpcsreset : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_txprbssel : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt_txprbsforceerr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_txbufstatus : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt_txresetdone : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_dmonitorout : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    gt_cplllock : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    gt_rxrate : IN STD_LOGIC_VECTOR(11 DOWNTO 0) 
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : aurora_64b66b_port7_logic
  PORT MAP (
    rxp => rxp,
    rxn => rxn,
    reset_pb => reset_pb,
    power_down => power_down,
    pma_init => pma_init,
    loopback => loopback,
    txp => txp,
    txn => txn,
    hard_err => hard_err,
    soft_err => soft_err,
    channel_up => channel_up,
    lane_up => lane_up,
    tx_out_clk => tx_out_clk,
    gt_pll_lock => gt_pll_lock,
    s_axi_tx_tdata => s_axi_tx_tdata,
    s_axi_tx_tvalid => s_axi_tx_tvalid,
    s_axi_tx_tready => s_axi_tx_tready,
    m_axi_rx_tdata => m_axi_rx_tdata,
    m_axi_rx_tvalid => m_axi_rx_tvalid,
    mmcm_not_locked_out => mmcm_not_locked_out,
    s_axi_awaddr => s_axi_awaddr,
    s_axi_awaddr_lane1 => s_axi_awaddr_lane1,
    s_axi_awaddr_lane2 => s_axi_awaddr_lane2,
    s_axi_awaddr_lane3 => s_axi_awaddr_lane3,
    s_axi_rresp => s_axi_rresp,
    s_axi_rresp_lane1 => s_axi_rresp_lane1,
    s_axi_rresp_lane2 => s_axi_rresp_lane2,
    s_axi_rresp_lane3 => s_axi_rresp_lane3,
    s_axi_bresp => s_axi_bresp,
    s_axi_bresp_lane1 => s_axi_bresp_lane1,
    s_axi_bresp_lane2 => s_axi_bresp_lane2,
    s_axi_bresp_lane3 => s_axi_bresp_lane3,
    s_axi_wstrb => s_axi_wstrb,
    s_axi_wstrb_lane1 => s_axi_wstrb_lane1,
    s_axi_wstrb_lane2 => s_axi_wstrb_lane2,
    s_axi_wstrb_lane3 => s_axi_wstrb_lane3,
    s_axi_wdata => s_axi_wdata,
    s_axi_wdata_lane1 => s_axi_wdata_lane1,
    s_axi_wdata_lane2 => s_axi_wdata_lane2,
    s_axi_wdata_lane3 => s_axi_wdata_lane3,
    s_axi_araddr => s_axi_araddr,
    s_axi_araddr_lane1 => s_axi_araddr_lane1,
    s_axi_araddr_lane2 => s_axi_araddr_lane2,
    s_axi_araddr_lane3 => s_axi_araddr_lane3,
    s_axi_rdata => s_axi_rdata,
    s_axi_rdata_lane1 => s_axi_rdata_lane1,
    s_axi_rdata_lane2 => s_axi_rdata_lane2,
    s_axi_rdata_lane3 => s_axi_rdata_lane3,
    s_axi_bready => s_axi_bready,
    s_axi_bready_lane1 => s_axi_bready_lane1,
    s_axi_bready_lane2 => s_axi_bready_lane2,
    s_axi_bready_lane3 => s_axi_bready_lane3,
    s_axi_awvalid => s_axi_awvalid,
    s_axi_awvalid_lane1 => s_axi_awvalid_lane1,
    s_axi_awvalid_lane2 => s_axi_awvalid_lane2,
    s_axi_awvalid_lane3 => s_axi_awvalid_lane3,
    s_axi_awready => s_axi_awready,
    s_axi_awready_lane1 => s_axi_awready_lane1,
    s_axi_awready_lane2 => s_axi_awready_lane2,
    s_axi_awready_lane3 => s_axi_awready_lane3,
    s_axi_wvalid => s_axi_wvalid,
    s_axi_wvalid_lane1 => s_axi_wvalid_lane1,
    s_axi_wvalid_lane2 => s_axi_wvalid_lane2,
    s_axi_wvalid_lane3 => s_axi_wvalid_lane3,
    s_axi_wready => s_axi_wready,
    s_axi_wready_lane1 => s_axi_wready_lane1,
    s_axi_wready_lane2 => s_axi_wready_lane2,
    s_axi_wready_lane3 => s_axi_wready_lane3,
    s_axi_bvalid => s_axi_bvalid,
    s_axi_bvalid_lane1 => s_axi_bvalid_lane1,
    s_axi_bvalid_lane2 => s_axi_bvalid_lane2,
    s_axi_bvalid_lane3 => s_axi_bvalid_lane3,
    s_axi_arvalid => s_axi_arvalid,
    s_axi_arvalid_lane1 => s_axi_arvalid_lane1,
    s_axi_arvalid_lane2 => s_axi_arvalid_lane2,
    s_axi_arvalid_lane3 => s_axi_arvalid_lane3,
    s_axi_arready => s_axi_arready,
    s_axi_arready_lane1 => s_axi_arready_lane1,
    s_axi_arready_lane2 => s_axi_arready_lane2,
    s_axi_arready_lane3 => s_axi_arready_lane3,
    s_axi_rvalid => s_axi_rvalid,
    s_axi_rvalid_lane1 => s_axi_rvalid_lane1,
    s_axi_rvalid_lane2 => s_axi_rvalid_lane2,
    s_axi_rvalid_lane3 => s_axi_rvalid_lane3,
    s_axi_rready => s_axi_rready,
    s_axi_rready_lane1 => s_axi_rready_lane1,
    s_axi_rready_lane2 => s_axi_rready_lane2,
    s_axi_rready_lane3 => s_axi_rready_lane3,
    init_clk => init_clk,
    link_reset_out => link_reset_out,
    gt_refclk1_p => gt_refclk1_p,
    gt_refclk1_n => gt_refclk1_n,
    user_clk_out => user_clk_out,
    sync_clk_out => sync_clk_out,
    gt_qpllclk_quad1_out => gt_qpllclk_quad1_out,
    gt_qpllrefclk_quad1_out => gt_qpllrefclk_quad1_out,
    gt_qpllrefclklost_quad1_out => gt_qpllrefclklost_quad1_out,
    gt_qplllock_quad1_out => gt_qplllock_quad1_out,
    gt_rxcdrovrden_in => gt_rxcdrovrden_in,
    gt_rxusrclk_out => gt_rxusrclk_out,
    sys_reset_out => sys_reset_out,
    gt_reset_out => gt_reset_out,
    gt_refclk1_out => gt_refclk1_out,
    gt_qplllock => gt_qplllock,
    gt_eyescanreset => gt_eyescanreset,
    gt_eyescandataerror => gt_eyescandataerror,
    gt_rxlpmen => gt_rxlpmen,
    gt_eyescantrigger => gt_eyescantrigger,
    gt_rxcdrhold => gt_rxcdrhold,
    gt_rxdfelpmreset => gt_rxdfelpmreset,
    gt_rxpmareset => gt_rxpmareset,
    gt_rxpcsreset => gt_rxpcsreset,
    gt_rxbufreset => gt_rxbufreset,
    gt_rxpmaresetdone => gt_rxpmaresetdone,
    gt_rxprbssel => gt_rxprbssel,
    gt_rxprbserr => gt_rxprbserr,
    gt_rxprbscntreset => gt_rxprbscntreset,
    gt_rxresetdone => gt_rxresetdone,
    gt_rxbufstatus => gt_rxbufstatus,
    gt_powergood => gt_powergood,
    gt_txpostcursor => gt_txpostcursor,
    gt_txdiffctrl => gt_txdiffctrl,
    gt_txinhibit => gt_txinhibit,
    gt_pcsrsvdin => gt_pcsrsvdin,
    gt_txprecursor => gt_txprecursor,
    gt_txpolarity => gt_txpolarity,
    gt_txpmareset => gt_txpmareset,
    gt_txpcsreset => gt_txpcsreset,
    gt_txprbssel => gt_txprbssel,
    gt_txprbsforceerr => gt_txprbsforceerr,
    gt_txbufstatus => gt_txbufstatus,
    gt_txresetdone => gt_txresetdone,
    gt_dmonitorout => gt_dmonitorout,
    gt_cplllock => gt_cplllock,
    gt_rxrate => gt_rxrate
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file aurora_64b66b_port7_logic.vhd when simulating
-- the core, aurora_64b66b_port7_logic. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.



