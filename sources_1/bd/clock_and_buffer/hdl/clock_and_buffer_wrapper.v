//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
//Date        : Fri Feb  6 03:19:03 2026
//Host        : crisdsc2.ucsd.edu running 64-bit Rocky Linux release 8.10 (Green Obsidian)
//Command     : generate_target clock_and_buffer_wrapper.bd
//Design      : clock_and_buffer_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_and_buffer_wrapper
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
  output aclk;
  output aclk450;
  output apb_clk;
  output [0:0]pcie_clk_gt;
  input [0:0]pcie_clk_in_clk_n;
  input [0:0]pcie_clk_in_clk_p;
  output [0:0]pcie_clk_out;
  output [0:0]refclk450;
  input [0:0]refclk450_clk_n;
  input [0:0]refclk450_clk_p;

  wire aclk;
  wire aclk450;
  wire apb_clk;
  wire [0:0]pcie_clk_gt;
  wire [0:0]pcie_clk_in_clk_n;
  wire [0:0]pcie_clk_in_clk_p;
  wire [0:0]pcie_clk_out;
  wire [0:0]refclk450;
  wire [0:0]refclk450_clk_n;
  wire [0:0]refclk450_clk_p;

  clock_and_buffer clock_and_buffer_i
       (.aclk(aclk),
        .aclk450(aclk450),
        .apb_clk(apb_clk),
        .pcie_clk_gt(pcie_clk_gt),
        .pcie_clk_in_clk_n(pcie_clk_in_clk_n),
        .pcie_clk_in_clk_p(pcie_clk_in_clk_p),
        .pcie_clk_out(pcie_clk_out),
        .refclk450(refclk450),
        .refclk450_clk_n(refclk450_clk_n),
        .refclk450_clk_p(refclk450_clk_p));
endmodule
