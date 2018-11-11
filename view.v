//view module
//designed by Yifan Cui
module view(
		clk, 
		resetn, 
		
		x_init,
		y_init,
		
		
		load_stone,
		load_color, 
		resetn_c, 
		enable_c, 
		load_x,
		load_y,
		enable_x_adder, 
		enable_y_adder,
		draw_background,
		
		X_out, 
		Y_out, 
		Color_out,
		cout,
		background_cout
		);
	input clk;
	input resetn;
	input load_stone;//test
	
	input [8:0]x_init;
	input [7:0]y_init;
	
	
	input load_color, resetn_c, enable_c, load_x, load_y, enable_x_adder, enable_y_adder, draw_background;
	
	output reg [8:0]X_out;
	output reg [8:0]Y_out;
	output reg [11:0]Color_out;
	output reg [8:0]cout;
	output reg [17:0]background_cout;
	
	reg [8:0]x;
	reg [8:0]y;
	
	wire [11:0]colour;
	wire [11:0]gold_color;
	wire [11:0]stone_color;
	wire [11:0]background_color;
	wire number_color;
	reg [8:0]x_size;
	reg [7:0]y_size;
	reg [8:0]x_cout;
	reg [7:0]y_cout;
	
	
	wire [7:0] gold_mem_address = ({y_cout[3:0], 4'd0} + {x_cout[3:0]}+1'b1);
	wire [7:0] stone_mem_address = ({y_cout[3:0], 4'd0} + {x_cout[3:0]}+1'b1);
	
	wire [16:0] background_mem_address = ({ background_cout[16:9], 8'd0} + { background_cout[16:9], 6'd0} + { background_cout[8:0]});
	
	
	
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
		else
			if(load_stone) Color_out <= stone_color;
			else Color_out <= gold_color;
		  
	end
	
	//9-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c == 0)) cout <= 9'b0;
		else
			if(enable_c)
			cout <= cout + 1'b1;
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
	
	
	// 17-bit black counter
	always@(posedge clk)begin
		if(resetn == 0) background_cout <= 17'b0;
		else
			if(draw_background)
				background_cout <= background_cout + 1'b1;
	end
	
endmodule


//gold data
module gold_data(
	
	size_x,
	size_y,
	score
	
	);	
	output [3:0]size_x;
	output [3:0]size_y;
	output [2:0]score;
		
	assign size_x = 4'd15;
	assign size_y = 4'd15;
	assign score = 4'd5;
	

endmodule



