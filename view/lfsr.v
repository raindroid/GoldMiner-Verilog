//-----------------------------------------------------
// Design Name : lfsr
// File Name   : lfsr.v
// Function    : Linear feedback shift register
// modified by Yifan Cui
//-----------------------------------------------------
module lfsr (out, clk, rst);
	output reg [7:0] out;
	input clk, rst;
	wire feedback;
	assign feedback = ~(out[7] ^ out[6]);
	always @(posedge clk, negedge rst)begin
		if (!rst)
			out = 7'hFF;
		else
			out = {out[6:0],feedback};
		end
endmodule
