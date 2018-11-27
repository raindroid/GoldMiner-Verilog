//This is the top module of the whole game
// input:
		// SW,
		// KEY,
		// CLOCK_50,
//output:
		// VGA_CLK,   					
		// VGA_HS,							
		// VGA_VS,						
		// VGA_BLANK_N,					
		// VGA_SYNC_N,					
		// VGA_R,   						
		// VGA_G,	 						
		// VGA_B,
		// PS2_CLK,
		// PS2_DAT
//Designed and modified by Yifan Cui

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
		PS2_CLK,
		PS2_DAT,
		FPGA_I2C_SCLK,
		FPGA_I2C_SDAT,
		AUD_ADCDAT,

		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		AUD_XCK,
		AUD_DACDAT,

		LEDR,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5
		);
		
		input [9:0]SW;
		input	[3:0]KEY;
		input	CLOCK_50;				//	50 MHz

		input				AUD_ADCDAT;

		inout PS2_CLK, PS2_DAT;
		// Bidirectionals
		inout				AUD_BCLK;
		inout				AUD_ADCLRCK;
		inout				AUD_DACLRCK;

		inout				FPGA_I2C_SDAT;

		// Outputs
		output				AUD_XCK;
		output				AUD_DACDAT;
		output				FPGA_I2C_SCLK;
		
		output			VGA_CLK;   				//	VGA Clock
		output			VGA_HS;					//	VGA H_SYNC
		output			VGA_VS;					//	VGA V_SYNC
		output			VGA_BLANK_N;				//	VGA BLANK
		output			VGA_SYNC_N;				//	VGA SYNC
		output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
		output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
		output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
		output [9:0] 	LEDR;

		output [6:0]HEX0;
		output [6:0]HEX1;
		output [6:0]HEX2;
		output [6:0]HEX3;
		output [6:0]HEX4;
		output [6:0]HEX5;
		
		wire resetn;
		assign resetn = KEY[0];

		
		fill f0
		(
			.CLOCK_50(CLOCK_50),						//	On Board 50 MHz
		// Your inputs and outputs here
			.plot(plot), 
			.resetn(resetn),
			.background(background),

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
			.PS2_CLK(PS2_CLK),
			.PS2_DAT(PS2_DAT),
			
			.AUD_ADCDAT(AUD_ADCDAT),

			// Bidirectionals
			.AUD_BCLK(AUD_BCLK),
			.AUD_ADCLRCK(AUD_ADCLRCK),
			.AUD_DACLRCK(AUD_DACLRCK),

			.FPGA_I2C_SDAT(FPGA_I2C_SDAT),

			// Outputs
			.AUD_XCK(AUD_XCK),
			.AUD_DACDAT(AUD_DACDAT),

			.FPGA_I2C_SCLK(FPGA_I2C_SCLK),

			.LEDR(LEDR),
			.HEX0(HEX0),
			.HEX1(HEX1),
			.HEX2(HEX2),
			.HEX3(HEX3),
			.HEX4(HEX4),
			.HEX5(HEX5)

		);

		

	endmodule
	
	
module fill
(
	CLOCK_50,						//	On Board 50 MHz
	// Your inputs and outputs here
	plot, 
	resetn,
	background,
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
	PS2_CLK,
	PS2_DAT,
	
	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	FPGA_I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	FPGA_I2C_SCLK,


	LEDR,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5
);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;		
	input [9:0] SW;
   
	
	// Declare your inputs and outputs here
	input plot, resetn, background;

	
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]

	inout PS2_CLK;
	inout PS2_DAT;

	input				AUD_ADCDAT;

	// Bidirectionals
	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				FPGA_I2C_SDAT;

	// Outputs
	output				AUD_XCK;
	output				AUD_DACDAT;

	output				FPGA_I2C_SCLK;

	output [9:0] 	LEDR;

	output [6:0]HEX0;
	output [6:0]HEX1;
	output [6:0]HEX2;
	output [6:0]HEX3;
	output [6:0]HEX4;
	output [6:0]HEX5;
	
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [11:0] colour;
	wire [8:0] x;
	wire [8:0] y;
	wire writeEn;
	wire game_end = ~KEY[1];
	reg drop;
	reg drop2;
	reg start;
	reg bomb;
	reg mode;
	

	
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
		.go(start | ~KEY[3]),
		.drop(drop | ~KEY[2]),
		.drop2(drop2 | ~KEY[1]),
		.bomb(bomb),
		.mode(mode | SW[9]),

		.X_out(x),
		.Y_out(y),
		.Color_out(colour),
		.writeEn(writeEn),
		.LEDR(LEDR),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5)
		);
	

	reg [7:0]the_command;
	wire send_command;
	wire command_was_sent;
	wire error_communication_timed_out;
	wire [7:0]received_data;
	reg [7:0] keyboard_data;
	wire received_data_en;

	always@(posedge CLOCK_50)begin
		if(command_was_sent) the_command = 8'hFF;
		else the_command = 8'hF4;
	end


	assign send_command = 1'b1;

	//input from key board
	PS2_Controller keyboard(
		.CLOCK_50(CLOCK_50),
		.reset(~resetn),

		.the_command(the_command),
		.send_command(send_command),


		.PS2_CLK(PS2_CLK),					// PS2 Clock
		.PS2_DAT(PS2_DAT),					// PS2 Data

		// Outputs
		.command_was_sent(command_was_sent),
		.error_communication_timed_out(error_communication_timed_out),

		.received_data(received_data),
		.received_data_en(received_data_en)			// If 1 - new data has been received
	);
	
	always@(posedge CLOCK_50)begin
	    start = 1'b0;
		bomb = 1'b0;
		mode =  1'b0;
		drop = 1'b0;
		drop2 = 1'b0;
		if(keyboard_data == 8'h72)begin // DOWN FOR DROP
		  	drop = 1'b1;
			keyboard_data = 8'h0;
		end	

		else if(keyboard_data == 8'h1B)begin // S FOR P2 DROP
		  	drop = 1'b0;
			drop2 = 1'b1;
			keyboard_data = 8'h0;
		end	
		else if(keyboard_data == 8'h29)begin // SPACE TO START
		  	drop = 1'b0;
			start = 1'b1;
			keyboard_data = 8'h0;
		end	
		else if(keyboard_data == 8'h1E)begin // 2 FOR 2-PLAYER
		  	drop = 1'b0;
			start = 1'b1;
			mode = 1'b1;
			keyboard_data = 8'h0;
		end	
		else if(keyboard_data == 8'h75)begin // UP TO USE BOMB
		  	drop = 1'b0;
			start = 1'b0;
			bomb = 1'b1;
			keyboard_data = 8'h0;
		end	
		
		else if(received_data_en == 0)begin
			drop = 1'b0;
			keyboard_data = 8'h0;
		end
		else begin
			drop = 1'b0;
			keyboard_data = received_data;
		end
		
	end

	//Audio
	wire enable_audio = 1;
	audio audio0(
		.SW(SW[9:0]),
		.resetn(resetn),
		.clk(CLOCK_50),
		.enable(enable_audio),
		.AUD_ADCDAT(AUD_ADCDAT),

	// Bidirectionals
		.AUD_BCLK(AUD_BCLK),
		.AUD_ADCLRCK(AUD_ADCLRCK),
		.AUD_DACLRCK(AUD_DACLRCK),

		.FPGA_I2C_SDAT(FPGA_I2C_SDAT),

		// Outputs
		.AUD_XCK(AUD_XCK),
		.AUD_DACDAT(AUD_DACDAT),

		.FPGA_I2C_SCLK(FPGA_I2C_SCLK)
);

endmodule



module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule