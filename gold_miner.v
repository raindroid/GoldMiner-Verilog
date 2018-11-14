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
		wire plot;
		assign plot = ~KEY[1];
		wire black;
		assign black = ~KEY[2];
		
		fill f0
	(
		.CLOCK_50(CLOCK_50),						//	On Board 50 MHz
		// Your inputs and outputs here
		.plot(plot), 
		.resetn(resetn),
		.black(black),
		.go(~KEY[3]),
		.position_in(SW[8:0]),
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
		black,
		go,
		position_in,
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
   
	
	// Declare your inputs and outputs here
	input plot, resetn, black,go;
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

	wire [23:0] colour;
	wire [8:0] x;
	wire [8:0] y;
	wire writeEn;
	
	

	
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
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 8;
		defparam VGA.BACKGROUND_IMAGE = "numbers.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	INPUT_module i0(
		.clk(CLOCK_50),
		.resetn(resetn),
		.go(go),
		.black(black),
		.plot(plot),
	
		
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
	black,
	plot,
	
	position_in,
	
	X_out,
	Y_out,
	Color_out,
	writeEn
	);
	
	
	input clk, resetn, go, black, plot;
	
	input [8:0] position_in;
	
	output [8:0] X_out;
	output [8:0] Y_out;
	output [23:0] Color_out;
	output writeEn;
	
	wire  load_color, 
			resetn_c, 
			enable_c, 
			load_x,
			load_y,
			enable_x_adder, 
			enable_y_adder,
			draw_black;
	wire [8:0]cout;
	wire [14:0]black_cout;
	
	view d0(
		.clk(clk), 
		.resetn(resetn), 
		
		.x_init(position_in),  
		.y_init(position_in),
		
		.load_color(load_color), 
		.resetn_c(resetn_c), 
		.enable_c(enable_c), 
		.load_x(load_x),
		.load_y(load_y),
		.enable_x_adder(enable_x_adder), 
		.enable_y_adder(enable_y_adder),
		.draw_black(draw_black),
		
		.X_out(X_out), 
		.Y_out(Y_out), 
		.Color_out(Color_out),
		.cout(cout),
		.black_cout(black_cout)
		);
		
	FSM f0(
		.clk(clk), 
		.plot(plot), 
		.resetn(resetn),
		.black(black),
		.go(go),
		
		.cout(cout),
		.black_cout(black_cout),
		
		.enable_c(enable_c),
		.resetn_c(resetn_c),

		.load_x(load_x),
		.load_y(load_y),
		.load_color(load_color),
		.enable_x_adder(enable_x_adder),
		.enable_y_adder(enable_y_adder),
		.draw_black(draw_black),
		.writeEn(writeEn)
	);
endmodule
