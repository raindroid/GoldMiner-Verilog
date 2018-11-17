//this module include score and time remain data
// Input: clk, resetn, timer_enable, score_score_adder, score_to_add
// Output: score_to_add, time_remain, score, move_enable, time_up
//designed by Yifan Cui

module game_info(
	clk,
	resetn,
	
	timer_enable,
	score_adder_enable,
	
	score_to_add,
	
	time_remain,
	score,
	
	move_enable,
	time_up
	
	);
	
	input clk,resetn;
	
	input timer_enable,score_adder_enable;
	
	input [2:0]score_to_add;
	
	output reg [7:0]time_remain;
	output reg [7:0]score;
	
	output reg time_up;
	output reg move_enable;
	
	
	wire time_counter_enable;
	reg move_counter;
	
	
	localparam time_remaining = 7'd60;
	localparam frame_count = 3'd5;
	
	
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
		if(!resetn)begin
			time_remain <= time_remaining;
			move_counter <= 1'b0;
		end
		else if(timer_enable & time_counter_enable)begin
			move_counter <= move_counter + 1'b1;
			time_remain <= time_remain - 1'b1;
			end
	end
	assign time_up = (time_remain == 0)?1:0;
	assign move_enable = (move_counter == frame_count) 1 : 0;
endmodule


//rate divider per frame
module rate_divider(resetn, clock, Enable);
	input clock;
	input resetn;
	output Enable;
	parameter D = 23'd8333333;
	reg [22:0]RateDivider;
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
