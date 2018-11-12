//this module include score and time remain data
//designed by Yifan Cui

module game_info(
	clk,
	resetn,
	
	timer_enable,
	score_adder_enable,
	
	score_to_add,
	
	time_remain,
	score,
	
	time_up
	
	);
	
	input clk,resetn;
	
	input timer_enable,score_adder_enable;
	
	input [2:0]score_to_add;
	
	output reg [5:0]time_remain;
	output reg [8:0]score;
	
	output reg time_up;
	
	
	wire time_counter_enable;
	
	
	parameter time_remaining = 6'd60;
	
	
	rate_divider(
	.resetn(resetn), 
	.clock(clk), 
	.Enable(time_counter_enable)
	);
	
	
	//score adder
	always@(posedge clk)begin
		if(!resetn) score <= 9'b0;
		else if(score_adder_enable)
			score <= score + score_to_add;
	end
	
	//timer
	always@(posedge clk)begin
		if(!resetn) time_remain <= time_remaining;
		else if(timer_enable & time_counter_enable)
			time_remain = time_remain - 1'b1;
	end
	
	assign time_up = (time_remain == 0)?1:0;
	
	
	
	
endmodule


//rate divider
module rate_divider(resetn, clock, Enable);
	input clock;
	input resetn;
	output Enable;
	parameter D = 26'd49999999;
	reg [25:0]RateDivider;
	always@(negedge resetn ,posedge clock)begin
		if(resetn == 0)
			RateDivider <= D;
		else if(RateDivider == 0)
			RateDivider <= D;
		else
			RateDivider <= RateDivider - 1;
	end
	assign Enable = (RateDivider == 0)?1:0;
endmodule
