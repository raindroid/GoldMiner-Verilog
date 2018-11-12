//view_data module
//designed by Yifan Cui
module view_data(
		clk, 
		resetn, 
		
		
		load_stone,
		resetn_c, 
		enable_c, 
		load_x,
		load_y,
		load_color,
		enable_x_adder, 
		enable_y_adder,
		draw_background,
		enable_gold,
		enable_stone,
		resetn_gold_stone,
		degree,
		
		X_out, 
		Y_out, 
		Color_out,
		background_cout,
		stone_cout,
		gold_cout,
		cout,
		frame,
		clockwise,
		drop_end,
		drag_end,
		degree_to_fsm
		
		);
	input clk;
	input resetn;
	input load_stone;//test
	
	
	
	
	input resetn_c, enable_c, load_x, load_y, load_color, enable_x_adder, enable_y_adder, draw_background;
	input enable_gold, enable_stone, resetn_gold_stone;
	input [7:0]degree;
	
	output reg [8:0]X_out;
	output reg [8:0]Y_out;
	output reg [11:0]Color_out;
	output reg [17:0]background_cout;
	output reg [2:0]gold_cout;
	output reg [2:0]stone_cout;
	output reg [8:0]cout;
	output reg frame;
	output reg clockwise;
	output reg drop_end, drag_end;
	output reg [7:0]degree_to_fsm;
	
	
	
	reg [8:0]x;
	reg [8:0]y;
	
	wire [11:0]colour;
	wire [11:0]gold_color;
	wire [11:0]stone_color;
	wire [11:0]background_color;

	reg [8:0]x_cout;
	reg [7:0]y_cout;
	
	
	wire [7:0] gold_mem_address = ({y_cout[3:0], 4'd0} + {x_cout[3:0]}+1'b1);
	wire [7:0] stone_mem_address = ({y_cout[3:0], 4'd0} + {x_cout[3:0]}+1'b1);
	
	wire [16:0] background_mem_address = ({ background_cout[16:9], 8'd0} + { background_cout[16:9], 6'd0} + { background_cout[8:0]});
	
	wire [7:0]random_x;
	wire [7:0]random_y;
	
	reg [8:0]x_init;
	reg [7:0]y_init;
	
	//instanciate lfsr to generate random x and y;
	lfsr l_x(
	.out(random_x),
	.clk(clk),
	.rst(resetn)
	);
	
	lfsr l_y(
	.out(random_y),
	.clk(clk),
	.rst(resetn)
	);
	
	always@(posedge clk)begin
		if(random_x[0] != 1) begin
			x_init[7:0] <= random_x;
			x_init[8] <= random_x[0];
		end
		else begin
			if({1'b1,random_x} <= 9'd304) begin
				x_init[7:0] <= random_x;
				x_init[8] <= random_x[0];
			end
			else begin
				x_init[7:0] <= random_x;
				x_init[8] <= 1'b0;
			end
		end
	end
	
	always@(posedge clk)begin
		if(random_y[7] != 1) begin
			y_init[7:0] <= random_y[7:0];
		end
		else begin
			if({random_y[6:0],1'b1} <= 9'd226) begin
				y_init[7:0] <= random_y;
			end
			else begin
				y_init[6:0] <= random_y[6:0];
				y_init[7] <= 1'b0;
			end
		end
	end
	
	
	
	
	gold g0(
	.address(gold_mem_address),
	.clock(clk),
	.q(gold_color));
	
	stone s0(
	.address(stone_mem_address),
	.clock(clk),
	.q(stone_color));
	
	background b0(
	.address(background_mem_address),
	.clock(clk),
	.q(background_color));
	
	
	//x register
	always@(posedge clk)begin
		if(resetn == 0) x <= 9'b0;
		else
			if(load_x) begin
			x[8:0] <= x_init;
			end
	end
	
	//y register
	always@(posedge clk)begin
		if(resetn == 0) y <= 9'b0;
		else
			if(load_y) begin
			y[8] =1'b0;
			y[7:0] <= y_init;
			
			end
	end
	

	//x adder
	always@(posedge clk)begin
		if(resetn == 0) X_out <= 9'b0;
		else
			if(enable_x_adder) begin
				if(!draw_background) X_out <= x + cout[3:0];
				else X_out <= background_cout[8:0];
				end
	end
	
	//y adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out <= 9'b0;
		else
			if(enable_y_adder)begin
				if(!draw_background) Y_out <= y + cout[7:4];
				else Y_out <= background_cout[16:9];
				end
	end
	
	//color register
	always@(posedge clk)begin
		if(resetn == 0) Color_out <= 12'b0;
		else if(draw_background) Color_out <= background_color;
		else if(load_color)begin
				if(load_stone) Color_out <= stone_color;
				else Color_out <= gold_color;
		end
	end
	
	//x counter
	always@(posedge clk)begin
		if(!resetn | (resetn_c == 0)) x_cout <= 9'b0;
		else if(enable_c)
			x_cout <= x_cout + 1'b1;
	end
	
	//y counter
	always@(posedge clk)begin
		if(!resetn | (resetn_c == 0)) y_cout <= 8'b0;
		else if(enable_c)
			y_cout <= y_cout + 1'b1;
	end
	
	//9-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c == 0)) cout <= 9'b0;
		else
			if(enable_c)
			cout <= cout + 1'b1;
	end
	
	
	// 17-bit black counter
	always@(posedge clk)begin
		if(resetn == 0) background_cout <= 17'b0;
		else
			if(draw_background)
				background_cout <= background_cout + 1'b1;
	end
	
	//gold counter
	always@(posedge clk)begin
		if(!resetn | (!resetn_gold_stone)) gold_cout <= 3'b0;
		else if(enable_gold)
			gold_cout <= gold_cout + 1'b1;
	end
	
	
	
	//stone counter
	always@(posedge clk)begin
		if(!resetn | (!resetn_gold_stone)) stone_cout <= 3'b0;
		else if(enable_stone)
			stone_cout <= stone_cout + 1'b1;
	end
	
	//rotation direction register
	always@(posedge clk)begin
		if(!resetn ) clockwise <= 1'b1;
		else if(degree == 8'd30)
			clockwise <= 1'b1;
		else if(degree == 8'd150)
			clockwise <= 1'b0;
	end
	
	
	
	rate_divider(
	.resetn(resetn), 
	.clock(clk),
	.Enable(frame));

endmodule


//rate divider
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
			RateDivider <= RateDivider - 1;
	end
	assign Enable = (RateDivider == 0)?1:0;
endmodule



