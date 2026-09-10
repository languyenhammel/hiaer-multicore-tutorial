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
 //  RX_STREAM_DATAPATH
 //
 //
 //  Description: the RX_STREAM_DATAPATH module takes regular data in Aurora format
 //               and transforms it to LocalLink formatted data
 //
 //              
 //
 
`timescale 1 ps / 1 ps
 
(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_64b66b_port7_logic_RX_STREAM_DATAPATH
 (
 
     //Aurora Lane Interface
     RX_PE_DATA,
     RX_PE_DATA_V,
     //Flow control signals
 
     // Global Logic
     CHANNEL_UP,
 
     //AXI4-Stream Interface
     m_axi_rx_tdata,
     m_axi_rx_tvalid,
     
     //System Interface
     USER_CLK,
     RESET
 );
 
 `define DLY #1
  parameter            STRB_WIDTH         = 32; // STROBE bus width
  parameter            REM_WIDTH          = 5; // REM bus width
 
 
 //***********************************Port Declarations*******************************
     
    
     //Aurora Lane Interface
       input     [0:255]    RX_PE_DATA;  
       input     [0:3]      RX_PE_DATA_V; 
        
     
     // Global Logic
       input                    CHANNEL_UP; 
 
     //AXI4-Stream Interface
       output [0:255]    m_axi_rx_tdata; 
       output            m_axi_rx_tvalid;
 
     
     //System Interface
       input              USER_CLK; 
       input              RESET; 
 
 
     
 //****************************External Register Declarations**************************
     //AXI4-Stream Interface
       reg       [0:255]    m_axi_rx_tdata; 
       reg                  m_axi_rx_tvalid;
 
 //*********************************Wire Declarations**********************************
       wire                 rx_tvalid_c; 
       wire                 rx_pe_data_v_c; 
    
 //*********************************Main Body of Code**********************************

     always @(posedge USER_CLK)
     begin
       m_axi_rx_tdata  <=  `DLY RX_PE_DATA;
     end
 
     assign  rx_tvalid_c = & RX_PE_DATA_V; 
     //Register the m_axi_rx_tvalid signal
     always @(posedge USER_CLK)
     begin
         if(!CHANNEL_UP)
            m_axi_rx_tvalid   <=  `DLY 1'b0;
         else 
            m_axi_rx_tvalid   <=  `DLY rx_tvalid_c ;
     end

     
 endmodule
 
 
