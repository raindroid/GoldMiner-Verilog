module gold_miner(
		SW,
		KEY,
		CLOCK_50,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B
		);
		
		input [9:0]SW;
		input	[3:0]KEY;
		input	CLOCK_50;				//	50 MHz
		
		output			VGA_CLK;   				//	VGA Clock
		output			VGA_HS;					//	VGA H_SYNC
		output			VGA_VS;					//	VGA V_SYNC
		output			VGA_BLANK_N;				//	VGA BLANK
		output			VGA_SYNC_N;				//	VGA SYNC
		output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
		output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
		output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
		
		wire resetn;
		assign resetn = KEY[0];


		
		fill f0
	(
		.CLOCK_50(CLOCK_50),						//	On Board 50 MHz
		// Your inputs and outputs here
		.plot(plot), 
		.resetn(resetn),
		.background(background),
		.go(~KEY[3]),
		.position_in(SW[8:0]),
		.SW(SW),
		.KEY(KEY),							// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		.VGA_CLK(VGA_CLK),   						//	VGA Clock
		.VGA_HS(VGA_HS),							//	VGA H_SYNC
		.VGA_VS(VGA_VS),							//	VGA V_SYNC
		.VGA_BLANK_N(VGA_BLANK_N),						//	VGA BLANK
		.VGA_SYNC_N(VGA_SYNC_N),						//	VGA SYNC
		.VGA_R(VGA_R),   						//	VGA Red[9:0]
		.VGA_G(VGA_G),	 						//	VGA Green[9:0]
		.VGA_B(VGA_B)   						//	VGA Blue[9:0]
	);
	endmodule
	
	
	module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		plot, 
		resetn,
		background,
		go,
		position_in,
		SW,
		KEY,							// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;		
	input [9:0] SW;
   
	
	// Declare your inputs and outputs here
	input plot, resetn, background,go;
	input [8:0]position_in;
	
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [20:0] colour;
	wire [8:0] x;
	wire [8:0] y;
	wire writeEn;
	wire game_end = ~KEY[1];
	wire drop = ~KKEY[2];
	
	

	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 4;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	INPUT_module i0(
		.clk(CLOCK_50),
		.resetn(resetn),
		.go(go),
		.background(background),
		.game_end(game_end),
		.drop(drop),
	
		
		.position_in(position_in),
	
		.X_out(x),
		.Y_out(y),
		.Color_out(colour),
		.writeEn(writeEn)
	);
	
	
	
endmodule


module INPUT_module(
	clk,
	resetn,
	go,
	background,
	game_end,
	drop,
	
	position_in,
	
	X_out,
	Y_out,
	Color_out,
	writeEn
	);
	
	
	input clk, resetn, go, background, game_end,drop;
	wire load_stone;
	
	input [8:0] position_in;
	
	output [8:0] X_out;
	output [8:0] Y_out;
	output [11:0] Color_out;
	output writeEn;
	
	wire  load_color, 
			resetn_c, 
			enable_c, 
			load_x,
			load_y,
			enable_x_adder, 
			enable_y_adder,
			draw_background;
	wire [8:0]cout;
	wire [16:0]background_cout;
	
	wire  enable_gold;
	wire	enable_stone;
	wire	resetn_gold_stone;
	wire	[2:0]stone_cout;
	wire	[2:0]gold_cout;
			
	
	view_data d0(
		.clk(clk), 
		.resetn(resetn), 
		
		
		.load_stone(load_stone),
		.resetn_c(resetn_c), 
		.enable_c(enable_c), 
		.load_x(load_x),
		.load_y(load_y),
		.load_color(load_color),
		.enable_x_adder(enable_x_adder), 
		.enable_y_adder(enable_y_adder),
		.draw_background(draw_background),
		.enable_gold(enable_gold),
		.enable_stone(enable_stone),
		.resetn_gold_stone(resetn_gold_stone),
		
		.X_out(X_out), 
		.Y_out(Y_out), 
		.Color_out(Color_out),
		.background_cout(background_cout),
		.stone_cout(stone_cout),
		.gold_cout(gold_cout),
		.cout(cout)
		);
		
		

		
	game_view_FSM f0(
		.clk(clk), 
		.resetn(resetn),
		.background(background),
		.go(go),
		
		.cout(cout),
		.background_cout(background_cout),
		.gold_cout(gold_cout),
		.stone_cout(stone_cout),
		.load_stone(load_stone),
	
		.game_end(game_end),
		.drop(drop),
		
		.enable_c(enable_c),
		.resetn_c(resetn_c),

		.load_x(load_x),
		.load_y(load_y),
		.load_color(load_color),
		.enable_x_adder(enable_x_adder),
		.enable_y_adder(enable_y_adder),
		.draw_background(draw_background),
		.writeEn(writeEn),
		.enable_gold(enable_gold),
		.enable_stone(enable_stone),
		.resetn_gold_stone(resetn_gold_stone)
	);
	

endmodule
