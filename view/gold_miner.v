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
		VGA_B,
		LEDR
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
		output [9:0] 	LEDR;
		
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
		.VGA_B(VGA_B),   						//	VGA Blue[9:0]
		.LEDR(LEDR)

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
	VGA_B,   						//	VGA Blue[9:0]
	LEDR
);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;		
	input [9:0] SW;
   
	
	// Declare your inputs and outputs here
	input plot, resetn, background,go;

	
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	output [9:0] 	LEDR;
	
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [11:0] colour;
	wire [8:0] x;
	wire [8:0] y;
	wire writeEn;
	wire game_end = ~KEY[1];
	wire drop = ~KEY[2];
	
	

	
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
	
	view view(
		.clk(CLOCK_50), 
		.resetn(resetn),
		.go(go),
		.drop(drop),

		.X_out(x),
		.Y_out(y),
		.Color_out(colour),
		.writeEn(writeEn),
		.LEDR(LEDR)
		);
	

endmodule



