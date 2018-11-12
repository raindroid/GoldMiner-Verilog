// this file contains the datapath for drawing gold, stone and background, related FSM can be found in the file draw_gold_stone_FSM.v

//designed by Yifan Cui

module draw_gold(
		clk, 
		resetn,
		x_init,
		y_init,
		

		resetn_c_gold, 
		enable_c_gold, 
		load_x_gold,
		load_y_gold,

		enable_x_adder_gold, 
		enable_y_adder_gold,
		enable_gold_count,

		resetn_gold_stone,

		
		X_out_gold, 
		Y_out_gold, 
		Color_out_gold,


		gold_count,
		gold_pixel_cout

	
	);
	
	input clk, resetn;
	input [8:0]x_init;
	input [7:0]y_init;
	
	
	input resetn_c_gold, 
			enable_c_gold, 
			load_x_gold,
			load_y_gold,

			enable_x_adder_gold, 
			enable_y_adder_gold;
	
	input enable_gold_count;
	input resetn_gold_stone;
			
	output reg [8:0]X_out_gold;
	output reg [7:0]Y_out_gold;
	output [11:0]Color_out_gold;
	
	
	output reg [2:0]gold_count;
	output reg [8:0]gold_pixel_cout;
	
	
	wire [7:0] gold_mem_address = ({y_gold_address_cout[3:0], 4'd0} + {x_gold_address_cout[3:0]}+1'b1);
	
	reg [8:0]x_gold_address_cout;
	reg [7:0]y_gold_address_cout;
	reg [8:0] x;
	reg [7:0] y;
	
	
	//get gold color
	gold g0(
	.address(gold_mem_address),
	.clock(clk),
	.q(Color_out_gold));
	
	//x register
	always@(posedge clk)begin
		if(resetn == 0) x <= 9'b0;
		else
			if(load_x_gold) begin
			x[8:0] <= x_init;
			end
	end
	
	//y register
	always@(posedge clk)begin
		if(resetn == 0) y <= 8'b0;
		else
			if(load_y_gold) begin
			y[7:0] <= y_init;
			
			end
	end
	

	//x_out adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_gold <= 9'b0;
		else
			if(enable_x_adder_gold) begin
				X_out_gold <= x + gold_pixel_cout[3:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_gold <= 8'b0;
		else
			if(enable_y_adder_gold)begin
				Y_out_gold <= y + gold_pixel_cout[7:4];
				end
	end
	
	//x address counter
	always@(posedge clk)begin
		if(!resetn | (resetn_c_gold == 0)) x_gold_address_cout <= 9'b0;
		else if(enable_c_gold)
			x_gold_address_cout <= x_gold_address_cout + 1'b1;
	end
	
	//y address counter
	always@(posedge clk)begin
		if(!resetn | (resetn_c_gold == 0)) y_gold_address_cout <= 8'b0;
		else if(enable_c_gold)
			y_gold_address_cout <= y_gold_address_cout + 1'b1;
	end
	
	//9-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c_gold == 0)) gold_pixel_cout <= 9'b0;
		else
			if(enable_c_gold)
			gold_pixel_cout <= gold_pixel_cout + 1'b1;
	end
	
		//gold counter
	always@(posedge clk)begin
		if(!resetn | (!resetn_gold_stone)) gold_count <= 3'b0;
		else if(enable_gold_count)
			gold_count <= gold_count + 1'b1;
	end
	
endmodule



module draw_stone(
		clk, 
		resetn,
		x_init,
		y_init,
		

		resetn_c_stone, 
		enable_c_stone, 
		load_x_stone,
		load_y_stone,

		enable_x_adder_stone, 
		enable_y_adder_stone,
		enable_stone_count,

		resetn_gold_stone,

		
		X_out_stone, 
		Y_out_stone, 
		Color_out_stone,


		stone_count,
		stone_pixel_cout

	
	);
	
	input clk, resetn;
	input [8:0]x_init;
	input [7:0]y_init;
	
	
	input resetn_c_stone, 
			enable_c_stone, 
			load_x_stone,
			load_y_stone,

			enable_x_adder_stone, 
			enable_y_adder_stone;
	
	input enable_stone_count;
	input resetn_gold_stone;
			
	output reg [2:0]stone_count;
	output reg [8:0]stone_pixel_cout;
	
	output reg [8:0]X_out_stone;
	output reg [7:0]Y_out_stone;
	output  [11:0]Color_out_stone;
	
	
	wire [7:0] stone_mem_address = ({y_stone_address_cout[3:0], 4'd0} + {x_stone_address_cout[3:0]}+1'b1);
	
	reg [8:0]x_stone_address_cout;
	reg [7:0]y_stone_address_cout;
	
	reg [8:0] x;
	reg [7:0] y;
	
	//get stone color
	stone s0(
	.address(stone_mem_address),
	.clock(clk),
	.q(Color_out_stone));
	
	//x register
	always@(posedge clk)begin
		if(resetn == 0) x <= 9'b0;
		else
			if(load_x_stone) begin
			x[8:0] <= x_init;
			end
	end
	
	//y register
	always@(posedge clk)begin
		if(resetn == 0) y <= 8'b0;
		else
			if(load_y_stone) begin
			y[7:0] <= y_init;
			
			end
	end
	

	//x_out adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_stone <= 9'b0;
		else
			if(enable_x_adder_stone) begin
				X_out_stone <= x + stone_pixel_cout[3:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_stone <= 8'b0;
		else
			if(enable_y_adder_stone)begin
				Y_out_stone <= y + stone_pixel_cout[7:4];
				end
	end
	
	//x address counter
	always@(posedge clk)begin
		if(!resetn | (resetn_c_stone == 0)) x_stone_address_cout <= 9'b0;
		else if(enable_c_stone)
			x_stone_address_cout <= x_stone_address_cout + 1'b1;
	end
	
	//y address counter
	always@(posedge clk)begin
		if(!resetn | (resetn_c_stone == 0)) y_stone_address_cout <= 8'b0;
		else if(enable_c_stone)
			y_stone_address_cout <= y_stone_address_cout + 1'b1;
	end
	
	//9-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c_stone == 0)) stone_pixel_cout <= 9'b0;
		else
			if(enable_c_stone)
			stone_pixel_cout <= stone_pixel_cout + 1'b1;
	end
	
		//stone counter
	always@(posedge clk)begin
		if(!resetn | (!resetn_gold_stone)) stone_count <= 3'b0;
		else if(enable_stone_count)
			stone_count <= stone_count + 1'b1;
	end
	
endmodule


module draw_background(
		clk, 
		resetn, 
		
		enable_x_adder_background, 
		enable_y_adder_background,

		
		X_out_background, 
		Y_out_background, 
		Color_out_background,
		background_cout
		
		);
	input clk;
	input resetn;
	
	input   enable_x_adder_background, enable_y_adder_background;
	
	output reg [8:0]X_out_background;
	output reg [8:0]Y_out_background;
	output reg [11:0]Color_out_background;
	output reg [17:0]background_cout;
	

	
	wire [11:0]background_color;
	
	wire [16:0] background_mem_address = ({ background_cout[16:9], 8'd0} + { background_cout[16:9], 6'd0} + { background_cout[8:0]});



	background b0(
	.address(background_mem_address),
	.clock(clk),
	.q(background_color));
	
	//color register
	always@(posedge clk)begin
		if(!resetn)	Color_out_background = 12'b0;
		else Color_out_background <= background_color;
	end
	
	

	//x adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_background <= 9'b0;
		else
			if(enable_x_adder_background) begin
				X_out_background <= background_cout[8:0];
				end
	end
	
	//y adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_background <= 9'b0;
		else
			if(enable_y_adder_background)begin
				Y_out_background <= background_cout[16:9];
				end
	end
	

	
	// 17-bit black counter
	always@(posedge clk)begin
		if(resetn == 0) background_cout <= 17'b0;
		else
				background_cout <= background_cout + 1'b1;
	end
	


endmodule