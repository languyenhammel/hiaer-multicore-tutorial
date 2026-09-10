`timescale 1ns / 1ps

module spike_fifo_controller(

    input resetn,
    input clk,

    // Spike FIFOs
    input         spk0_empty,
    input  [16:0] spk0_dout,
    output reg    spk0_rden,

    input         spk1_empty,
    input  [16:0] spk1_dout,
    output reg    spk1_rden,

    input         spk2_empty,
    input  [16:0] spk2_dout,
    output reg    spk2_rden,

    input         spk3_empty,
    input  [16:0] spk3_dout,
    output reg    spk3_rden,

    input         spk4_empty,
    input  [16:0] spk4_dout,
    output reg    spk4_rden,

    input         spk5_empty,
    input  [16:0] spk5_dout,
    output reg    spk5_rden,

    input         spk6_empty,
    input  [16:0] spk6_dout,
    output reg    spk6_rden,

    input         spk7_empty,
    input  [16:0] spk7_dout,
    output reg    spk7_rden,
    /*
    input         spk8_empty,
    input  [16:0] spk8_dout,
    output reg    spk8_rden,

    input         spk9_empty,
    input  [16:0] spk9_dout,
    output reg    spk9_rden,

    input         spk10_empty,
    input  [16:0] spk10_dout,
    output reg    spk10_rden,

    input         spk11_empty,
    input  [16:0] spk11_dout,
    output reg    spk11_rden,

    input         spk12_empty,
    input  [16:0] spk12_dout,
    output reg    spk12_rden,

    input         spk13_empty,
    input  [16:0] spk13_dout,
    output reg    spk13_rden,

    input         spk14_empty,
    input  [16:0] spk14_dout,
    output reg    spk14_rden,

    input         spk15_empty,
    input  [16:0] spk15_dout,
    output reg    spk15_rden,
    */
    // to HBM processor
    input             spk2ciFIFO_full,
    output reg [16:0] spk2ciFIFO_din,
    output reg        spk2ciFIFO_wren
);


// Round-Robin arbitration
reg [2:0] addr; //Previously [3:0] for 16 Spike FIFOs
always @(posedge clk) begin
    if (!resetn) addr <= 3'd0;
    else         addr <= addr + 1'b1;
end

//wire [7:0] spks_empty = {spk7_empty,spk6_empty,spk5_empty,spk4_empty,spk3_empty,spk2_empty,spk1_empty,spk0_empty};
//wire [16:0] spks_dout [7:0];

//wire [15:0] spks_empty = {spk15_empty,spk14_empty,spk13_empty,spk12_empty,spk11_empty,spk10_empty,spk9_empty,spk8_empty,spk7_empty,spk6_empty,spk5_empty,spk4_empty,spk3_empty,spk2_empty,spk1_empty,spk0_empty};
wire [7:0] spks_empty = {spk7_empty,spk6_empty,spk5_empty,spk4_empty,spk3_empty,spk2_empty,spk1_empty,spk0_empty};
//wire [16:0] spks_dout [15:0];
wire [16:0] spks_dout [7:0];

always @(*) begin
    spk0_rden    <= 1'b0;
    spk1_rden    <= 1'b0;
    spk2_rden    <= 1'b0;
    spk3_rden    <= 1'b0;
    spk4_rden    <= 1'b0;
    spk5_rden    <= 1'b0;
    spk6_rden    <= 1'b0;
    spk7_rden    <= 1'b0;
    /*spk8_rden    <= 1'b0;
    spk9_rden    <= 1'b0;
    spk10_rden    <= 1'b0;
    spk11_rden    <= 1'b0;
    spk12_rden    <= 1'b0;
    spk13_rden    <= 1'b0;
    spk14_rden    <= 1'b0;
    spk15_rden    <= 1'b0;*/
    spk2ciFIFO_din  <= 32'dX;
    spk2ciFIFO_wren <= 1'b0;

    case (addr)
        3'd0: begin
            if (!spk0_empty & !spk2ciFIFO_full) begin
                spk0_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk0_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        3'd1: begin
            if (!spk1_empty & !spk2ciFIFO_full) begin
                spk1_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk1_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        3'd2: begin
            if (!spk2_empty & !spk2ciFIFO_full) begin
                spk2_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk2_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        3'd3: begin
            if (!spk3_empty & !spk2ciFIFO_full) begin
                spk3_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk3_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        3'd4: begin
            if (!spk4_empty & !spk2ciFIFO_full) begin
                spk4_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk4_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        3'd5: begin
            if (!spk5_empty & !spk2ciFIFO_full) begin
                spk5_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk5_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        3'd6: begin
            if (!spk6_empty & !spk2ciFIFO_full) begin
                spk6_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk6_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        3'd7: begin
            if (!spk7_empty & !spk2ciFIFO_full) begin
                spk7_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk7_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        /*
        4'd8: begin
            if (!spk8_empty & !spk2ciFIFO_full) begin
                spk8_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk8_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        4'd9: begin
            if (!spk9_empty & !spk2ciFIFO_full) begin
                spk9_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk9_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        4'd10: begin
            if (!spk10_empty & !spk2ciFIFO_full) begin
                spk10_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk10_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        4'd11: begin
            if (!spk11_empty & !spk2ciFIFO_full) begin
                spk11_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk11_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        4'd12: begin
            if (!spk12_empty & !spk2ciFIFO_full) begin
                spk12_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk12_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        4'd13: begin
            if (!spk13_empty & !spk2ciFIFO_full) begin
                spk13_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk13_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        4'd14: begin
            if (!spk14_empty & !spk2ciFIFO_full) begin
                spk14_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk14_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        4'd15: begin
            if (!spk15_empty & !spk2ciFIFO_full) begin
                spk15_rden    <= 1'b1;
                spk2ciFIFO_din  <= spk15_dout;
                spk2ciFIFO_wren <= 1'b1;
            end
        end
        */
        default: begin
            spk0_rden    <= 1'b0;
            spk1_rden    <= 1'b0;
            spk2_rden    <= 1'b0;
            spk3_rden    <= 1'b0;
            spk4_rden    <= 1'b0;
            spk5_rden    <= 1'b0;
            spk6_rden    <= 1'b0;
            spk7_rden    <= 1'b0;
            /*spk8_rden    <= 1'b0;
            spk9_rden    <= 1'b0;
            spk10_rden    <= 1'b0;
            spk11_rden    <= 1'b0;
            spk12_rden    <= 1'b0;
            spk13_rden    <= 1'b0;
            spk14_rden    <= 1'b0;
            spk15_rden    <= 1'b0; */
            spk2ciFIFO_din  <= 32'dX;
            spk2ciFIFO_wren <= 1'b0;
        end
    endcase
end

endmodule
