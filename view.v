//view module
//designed by Yifan Cui
module view(
		clk, 
		resetn, 
		
		x_init,
		y_init,
		
		
		load_color, 
		resetn_c, 
		enable_c, 
		load_x,
		load_y,
		enable_x_adder, 
		enable_y_adder,
		draw_black,
		
		X_out, 
		Y_out, 
		Color_out,
		cout,
		black_cout
		);
	input clk;
	input resetn;
	
	input [8:0]x_init;
	input [7:0]y_init;
	
	
	input load_color, resetn_c, enable_c, load_x, load_y, enable_x_adder, enable_y_adder, draw_black;
	
	output reg [8:0]X_out;
	output reg [8:0]Y_out;
	output reg [23:0]Color_out;
	output reg [8:0]cout;
	output reg [15:0]black_cout;
	
	reg [8:0]x;
	reg [8:0]y;
	
	wire [23:0]colour;
	wire [23:0]gold_color;
	wire [23:0]stone_color;
	wire [23:0]background_color;
	wire [23:0]number_color;
	reg [8:0]x_size;
	reg [7:0]y_size;
	reg [8:0]x_cout;
	reg [7:0]y_cout;
	
	
	wire [7:0] gold_mem_address = ({y_cout[3:0], 4'd0} + {x_cout[3:0]}+1'b1);
	
	
	gold g0(
	.address(gold_mem_address),
	.clock(clk),
	.q(colour));
	
	
	
	
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
				if(!draw_black) X_out <= x + cout[3:0];
				else X_out <= black_cout[7:0];
				end
	end
	
	//y adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out <= 9'b0;
		else
			if(enable_y_adder)begin
				if(!draw_black) Y_out <= y + cout[7:4];
				else Y_out <= black_cout[14:8];
				end
	end
	
	//color register
	always@(posedge clk)begin
		if(resetn == 0 | draw_black) Color_out <= 24'b0;
		else
		  Color_out <= colour;
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



