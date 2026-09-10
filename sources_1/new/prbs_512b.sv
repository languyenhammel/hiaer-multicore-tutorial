`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2023 08:57:26 AM
// Design Name: 
// Module Name: prbs_512b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module lfsr_top(
    input clk,
	input resetn,
	output out
);
	reg [21:0] lfsr;

	assign out = lfsr[21];

	always @(posedge clk) begin
		if (~resetn) begin
			lfsr <= 22'b01_1011_1111_1011_0101_1001;
		end else begin
			lfsr <= {lfsr[20:0], lfsr[20] ^ lfsr[21]};
		end
	end
endmodule

module lfsr_bot(
    input clk,
	input resetn,
	output out
);
	reg [20:0] lfsr;

	assign out = lfsr[20];

	always @(posedge clk) begin
		if (~resetn) begin
			lfsr <= 21'b1_0110_1010_1101_0101_1111;
		end else begin
			lfsr <= {lfsr[19:0], lfsr[19] ^ lfsr[20]};
		end
	end
endmodule

module sr_top_bot #(parameter SR_WIDTH=16)(
    input clk,
    input resetn,
    input sr_top_in,
    input sr_bot_in,
    output sr_top_out,
    output sr_bot_out,
    output [SR_WIDTH-1:0] prbs
    );
    reg [SR_WIDTH-1:0] sr_top, sr_bot;
    // Shift Registers and PRBS
	assign sr_top_out = sr_top[SR_WIDTH-1];
	assign sr_bot_out = sr_bot[SR_WIDTH-1];
	genvar j;
	generate
		for (j = 0; j < SR_WIDTH; j = j + 1) begin
			assign prbs[j] = sr_top[j] ^ sr_bot[SR_WIDTH -1 - j];
		end
	endgenerate
	
	//Shift Registers and PRBS
	always @(posedge clk) begin
		if (~resetn) begin
			sr_top <= {SR_WIDTH{1'b0}}; //Single core
			sr_bot <= {SR_WIDTH{1'b0}}; //Single core
		end else begin
			sr_top <= {sr_top[SR_WIDTH-2:0], sr_top_in};
			sr_bot <= {sr_bot[SR_WIDTH-2:0], sr_bot_in};
		end
	end
endmodule

module prbs_512b #(parameter NUM_CORES=1, parameter SR_WIDTH=16, parameter NEURON_GROUPS=16)
    (
    input clk,
    input resetn,
    output [(NUM_CORES*SR_WIDTH*NEURON_GROUPS)-1:0] prbs
    );
    wire [(NUM_CORES*NEURON_GROUPS):0] sr_top_in, sr_bot_in; //1 extra bit 
    //Logic for LFSR
	lfsr_top u_lfsr_top(
		.resetn(resetn),
		.clk(clk),
		.out(sr_top_in[0])
	);
	lfsr_bot u_lfsr_bot(
		.resetn(resetn),
		.clk(clk),
		.out(sr_bot_in[NUM_CORES*NEURON_GROUPS])
	);
    genvar i, j;
    generate
		for (i = 0; i < NUM_CORES; i = i + 1) begin
            for (j = 0; j < NEURON_GROUPS; j = j + 1) begin
		      sr_top_bot u_ng (
		            .clk (clk),
                    .resetn(resetn),
                    .sr_top_in(sr_top_in[(i*NEURON_GROUPS+j)]),
                    .sr_bot_in(sr_bot_in[(i*NEURON_GROUPS+j)+1]),
                    .sr_top_out(sr_top_in[i*NEURON_GROUPS+j+1]),
                    .sr_bot_out(sr_bot_in[i*NEURON_GROUPS+j]),
                    .prbs(prbs[(i*NEURON_GROUPS+j+1)*SR_WIDTH-1:(i*NEURON_GROUPS+j)*SR_WIDTH])
		      );
		    end
		end
	endgenerate
endmodule
