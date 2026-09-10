//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
//Date        : Fri Feb  6 03:19:03 2026
//Host        : crisdsc2.ucsd.edu running 64-bit Rocky Linux release 8.10 (Green Obsidian)
//Command     : generate_target clock_and_buffer.bd
//Design      : clock_and_buffer
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "clock_and_buffer,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=clock_and_buffer,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "clock_and_buffer.hwdef" *) 
module clock_and_buffer
   (aclk,
    aclk450,
    apb_clk,
    pcie_clk_gt,
    pcie_clk_in_clk_n,
    pcie_clk_in_clk_p,
    pcie_clk_out,
    refclk450,
    refclk450_clk_n,
    refclk450_clk_p);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK, CLK_DOMAIN clock_and_buffer_clk_wiz_0_0_clk_out1, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK450 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK450, CLK_DOMAIN clock_and_buffer_clk_wiz_0_0_clk_out1, FREQ_HZ 250000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output aclk450;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.APB_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.APB_CLK, CLK_DOMAIN clock_and_buffer_clk_wiz_0_0_clk_out1, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output apb_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PCIE_CLK_GT CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PCIE_CLK_GT, CLK_DOMAIN clock_and_buffer_util_ds_buf_0_0_IBUF_OUT, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output [0:0]pcie_clk_gt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_clk_in CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pcie_clk_in, CAN_DEBUG false, FREQ_HZ 100000000" *) input [0:0]pcie_clk_in_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_clk_in CLK_P" *) input [0:0]pcie_clk_in_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PCIE_CLK_OUT CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PCIE_CLK_OUT, CLK_DOMAIN clock_and_buffer_util_ds_buf_0_0_IBUF_DS_ODIV2, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output [0:0]pcie_clk_out;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.REFCLK450 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.REFCLK450, CLK_DOMAIN clock_and_buffer_util_ds_buf_1_1_IBUF_OUT, FREQ_HZ 450000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output [0:0]refclk450;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 refclk450 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME refclk450, CAN_DEBUG false, FREQ_HZ 450000000" *) input [0:0]refclk450_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 refclk450 CLK_P" *) input [0:0]refclk450_clk_p;

  wire [0:0]CLK_IN_D_0_1_CLK_N;
  wire [0:0]CLK_IN_D_0_1_CLK_P;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_clk_out3;
  wire [0:0]pcie_clk_in_1_CLK_N;
  wire [0:0]pcie_clk_in_1_CLK_P;
  wire [0:0]util_ds_buf_0_IBUF_OUT;
  wire [0:0]util_ds_buf_1_IBUF_OUT;

  assign CLK_IN_D_0_1_CLK_N = refclk450_clk_n[0];
  assign CLK_IN_D_0_1_CLK_P = refclk450_clk_p[0];
  assign aclk = clk_wiz_0_clk_out1;
  assign aclk450 = clk_wiz_0_clk_out3;
  assign apb_clk = clk_wiz_0_clk_out2;
  assign pcie_clk_gt[0] = util_ds_buf_0_IBUF_OUT;
  assign pcie_clk_in_1_CLK_N = pcie_clk_in_clk_n[0];
  assign pcie_clk_in_1_CLK_P = pcie_clk_in_clk_p[0];
  assign refclk450[0] = util_ds_buf_1_IBUF_OUT;
  clock_and_buffer_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(util_ds_buf_1_IBUF_OUT),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .clk_out3(clk_wiz_0_clk_out3));
  clock_and_buffer_util_ds_buf_0_0 util_ds_buf_0
       (.IBUF_DS_N(pcie_clk_in_1_CLK_N),
        .IBUF_DS_P(pcie_clk_in_1_CLK_P),
        .IBUF_OUT(util_ds_buf_0_IBUF_OUT));
  clock_and_buffer_util_ds_buf_1_1 util_ds_buf_1
       (.IBUF_DS_N(CLK_IN_D_0_1_CLK_N),
        .IBUF_DS_P(CLK_IN_D_0_1_CLK_P),
        .IBUF_OUT(util_ds_buf_1_IBUF_OUT));
endmodule
