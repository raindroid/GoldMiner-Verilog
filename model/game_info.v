//this module include score and time remain data
// Input: clk, resetn, timer_enable, score_score_adder, score_to_add
// Output: score_to_add, time_remain, score, move_enable, time_up
//designed by Yifan Cui

module timer(
	clk,
	resetn,
	timer_enable,
	time_resetn,
	time_remain,
	time_up
	);
	
	input clk,resetn,time_resetn;
	
	input timer_enable;
	
	output reg [7:0]time_remain;

	output reg time_up;
	
	wire time_counter_enable;

	localparam time_remaining = 7'd60;
	

	rate_divider_second r0(
	.resetn(time_resetn), 
	.clock(clk), 
	.Enable(time_counter_enable),
	.timer_enable(timer_enable)
	);
	
	
	
	//timer
	always@(posedge clk)begin
		if(!resetn | !time_resetn)begin
			time_remain <= time_remaining;
			time_up = 0;
		end
		else if(timer_enable & time_counter_enable)begin
			time_remain <= time_remain - 1'b1;
			end
		if(time_remain == 0)
			time_up = 1'b1;
	end
	
endmodule


//rate divider per frame
module rate_divider_second(resetn,timer_enable, clock, Enable);
	input clock;
	input resetn;
	input timer_enable;
	output Enable;
	parameter D = 26'd49999999;//23'd833333
	reg [25:0]RateDivider;
	always@(negedge resetn ,posedge clock)begin
		if(resetn == 0)
			RateDivider <= D;
		else if(RateDivider == 0)
			RateDivider <= D;
		else if(timer_enable)
			RateDivider <= RateDivider - 1'b1;
		end
	assign Enable = (RateDivider == 1'b0)?1:0;
endmodule

module rate_divider(resetn, clock, Enable);
	input clock;
	input resetn;
	output Enable;
	parameter D = 25'd3333333;//d833333
	reg [24:0]RateDivider;
	always@(negedge resetn ,posedge clock)begin
		if(resetn == 0)
			RateDivider <= D;
		else if(RateDivider == 0)
			RateDivider <= D;
		else
			RateDivider <= RateDivider - 1'b1;
	end
	assign Enable = (RateDivider == 1'b0)?1:0;
endmodule