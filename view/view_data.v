//view_data module
// This module is the for game view data 
//designed by Yifan Cui
module view(
		clk, 
		resetn,
		go,

		X_out,
		Y_out,
		Color_out,
		writeEn
		
		);
	input clk, resetn;
	input go;
	
	output reg[8:0]X_out;
	output reg[7:0]Y_out;
	output reg[11:0]Color_out;
	output reg writeEn;
	
	wire [7:0]random;
	
	
	reg [8:0]x_init;
	reg [7:0]y_init;
	
	always@(posedge clk)begin
		if(enable_draw_gold) begin
			X_out <= X_out_gold;
			Y_out <= Y_out_gold;
			Color_out <= Color_out_gold;
			if(Color_out == 12'b0) 
				writeEn <= 1'b0;
			else
				writeEn <= writeEn_gold;
		end
		else if(enable_draw_stone)begin
			X_out <= X_out_stone;
			Y_out <= Y_out_stone;
			Color_out <= Color_out_stone;
			if(Color_out == 12'b0) 
				writeEn <= 1'b0;
			else
				writeEn <= writeEn_stone;
		end
		else if(enable_draw_background)begin
			X_out <= X_out_background;
			Y_out <= Y_out_background;
			Color_out <= Color_out_background;
			writeEn <= writeEn_background;
		end
		else if (enable_draw_hook) begin
			X_out <= X_out_hook;
			Y_out <= Y_out_hook;
			Color_out <= Color_out_hook;
			writeEn <= writeEn_hook;
		end
	end
	
	
	
	//instanciate lfsr to generate random x and y;
	lfsr l(
	.out(random),
	.clk(clk),
	.rst(resetn)
	);
	
	
	wire enable_random;
	
	
	always@(posedge clk)begin
	 if(enable_random)begin
		if(random[4:0] * 5'd20 <= 9'd300) begin
			x_init[8:0] <= random[4:0] * 5'd20;
		end
		else begin
			x_init[7:0] <= random[4:1] * 5'd20;
			x_init[8] <= 1'b0;
			end
		end

	end
	
	always@(posedge clk)begin
	 if(enable_random)begin
		if(random[7:4] * 5'd20 <= 8'd140) begin
			y_init[7:0] <= random[5:3] * 5'd20 + 7'd80;
		end
		else begin
			y_init[6:0] <= random[6:5] * 5'd20 + 7'd80;
			y_init[7] <= 1'b0;
			end
		end
	end
	

	//instantiate view fsm
	
	game_view_FSM game_view(
		.clk(clk), 
		.resetn(resetn),
		.go(go),
	
		.draw_gold_done(draw_gold_done),
		.draw_stone_done(draw_stone_done),
		.draw_background_done(draw_background_done),
		
		.draw_hook_done(draw_hook_done), 
	
		.gold_count(gold_count),
		.stone_count(stone_count),
	
		.frame(frame),
		.clockwise(1),
		.drop_end(0),
		.drag_end(0),
	
		.game_end(1),
		.drop(0),
	
		.enable_draw_gold(enable_draw_gold),
		.enable_draw_stone(enable_draw_stone),
		.enable_draw_background(enable_draw_background),
		.enable_draw_hook(enable_draw_hook),
		.enable_random(enable_random),
		.resetn_gold_stone(resetn_gold_stone)

	);
	
	
	
	//instantiate all the drawing datapath and FSMs
	
	wire resetn_c_gold, 
		  enable_c_gold, 
		  load_x_gold,
		  load_y_gold,
		  enable_x_adder_gold, 
		  enable_y_adder_gold,
		  enable_gold_count,
		  resetn_gold_stone;
		  
	wire [8:0]X_out_gold; 
	wire [7:0]Y_out_gold; 
	wire [11:0]Color_out_gold;


	wire [2:0]gold_count;
	wire [8:0]gold_pixel_cout;
	
	wire enable_draw_gold;
	wire writeEn_gold;
	wire draw_gold_done;


	
	
	draw_gold dg0(
		.clk(clk), 
		.resetn(resetn),
		.x_init(x_init),
		.y_init(y_init),

		.resetn_c_gold(resetn_c_gold), 
		.enable_c_gold(enable_c_gold), 
		.load_x_gold(load_x_gold),
		.load_y_gold(load_y_gold),

		.enable_x_adder_gold(enable_x_adder_gold), 
		.enable_y_adder_gold(enable_y_adder_gold),
		.enable_gold_count(enable_gold_count),
		.resetn_gold_stone(resetn_gold_stone),

		
		.X_out_gold(X_out_gold), 
		.Y_out_gold(Y_out_gold), 
		.Color_out_gold(Color_out_gold),


		.gold_count(gold_count),
		.gold_pixel_cout(gold_pixel_cout)

	);
	
	draw_gold_FSM dgf0(
		.clk(clk), 
		.resetn(resetn),
		.enable_draw_gold(enable_draw_gold),

		.gold_pixel_cout(gold_pixel_cout),
		.enable_c_gold(enable_c_gold),
		.load_x_gold(load_x_gold),
		.load_y_gold(load_y_gold),
		.enable_x_adder_gold(enable_x_adder_gold), 
		.enable_y_adder_gold(enable_y_adder_gold),
		.enable_gold_count(enable_gold_count),
		.resetn_c_gold(resetn_c_gold),
		.writeEn_gold(writeEn_gold),
		.draw_gold_done(draw_gold_done)
	);
	
	
	wire resetn_c_stone, 
		  enable_c_stone, 
		  load_x_stone,
		  load_y_stone,
		  enable_x_adder_stone, 
		  enable_y_adder_stone,
		  enable_stone_count,
		  resetn_stone_stone;
		  
	wire [8:0]X_out_stone; 
	wire [7:0]Y_out_stone; 
	wire [11:0]Color_out_stone;


	wire [2:0]stone_count;
	wire [8:0]stone_pixel_cout;
	
	wire enable_draw_stone;
	wire writeEn_stone;
	wire draw_stone_done;
	
	
	draw_stone ds0(
		.clk(clk), 
		.resetn(resetn),
		.x_init(x_init),
		.y_init(y_init),

		.resetn_c_stone(resetn_c_stone), 
		.enable_c_stone(enable_c_stone), 
		.load_x_stone(load_x_stone),
		.load_y_stone(load_y_stone),

		.enable_x_adder_stone(enable_x_adder_stone), 
		.enable_y_adder_stone(enable_y_adder_stone),
		.enable_stone_count(enable_stone_count),
		.resetn_gold_stone(resetn_gold_stone),

		
		.X_out_stone(X_out_stone), 
		.Y_out_stone(Y_out_stone), 
		.Color_out_stone(Color_out_stone),


		.stone_count(stone_count),
		.stone_pixel_cout(stone_pixel_cout)

	);
	
	draw_stone_FSM dsf0(
		.clk(clk), 
		.resetn(resetn),
		.enable_draw_stone(enable_draw_stone),

		.stone_pixel_cout(stone_pixel_cout),
		.enable_c_stone(enable_c_stone),
		.load_x_stone(load_x_stone),
		.load_y_stone(load_y_stone),
		.enable_x_adder_stone(enable_x_adder_stone), 
		.enable_y_adder_stone(enable_y_adder_stone),
		.enable_stone_count(enable_stone_count),
		.resetn_c_stone(resetn_c_stone),
		.writeEn_stone(writeEn_stone),
		.draw_stone_done(draw_stone_done)
	);
	
	wire enable_x_adder_background, 
			enable_y_adder_background;

		
	wire [8:0]X_out_background;
	wire [7:0]Y_out_background; 
	wire [11:0]Color_out_background;
	wire [16:0]background_cout;
	
	wire enable_draw_background;
	wire writeEn_background;
	wire draw_background_done;
	wire enable_c_stone_background;
	
	draw_background db0(
		.clk(clk), 
		.resetn(resetn), 
		
		.enable_x_adder_background(enable_x_adder_background), 
		.enable_y_adder_background(enable_y_adder_background),
		.enable_c_stone_background(enable_c_stone_background),

		
		.X_out_background(X_out_background), 
		.Y_out_background(Y_out_background), 
		.Color_out_background(Color_out_background),
		.background_cout(background_cout)
		);
		
	draw_background_FSM dbf0(
	.clk(clk), 
	.resetn(resetn),
	.enable_draw_background(enable_draw_background),
	.background_cout(background_cout),
	
	.enable_c_stone_background(enable_c_stone_background),
	.enable_x_adder_background(enable_x_adder_background), 
	.enable_y_adder_background(enable_y_adder_background),
	.writeEn_background(writeEn_background),
	.draw_background_done(draw_background_done)
	);
	
	wire frame;
	
	rate_divider r0(
	.resetn(resetn), 
	.clock(clk),
	.Enable(frame));

	wire [1799: 0] trigAbsX, trigAbsY;
	wire [179: 0] trigSignX, trigSignY;
	trigonometry trig(
		.clock(clk), 
		.enable(!KEY[0]),
 		.absX(trigAbsX), 
		.absY(trigAbsY),
 		.signX(trigSignX), 
		.signY(trigSignY)
	);

	wire 	[8:0] X_out_hook;
	wire	[7:0] Y_out_hook;
	wire	[11:0] Color_out_hook;
	wire	writeEn_hook,
		draw_hook_done,
		enable_draw_hook;

	draw_hook hook1(
		.clock(clk), 
		.resetn(resetn),
		.enable(enable_draw_hook),
		.centerX(9'd180),
		.centerY(8'd120),
		.degree(9'd90),
		.trigAbsX(trigAbsX), 
		.trigAbsY(trigAbsY),
		.trigSignX(trigSignX), 
		.trigSignY(trigSignY),
		.outX(X_out_hook),
		.outY(Y_out_hook),
		.color(Color_out_hook),
		.writeEn(writeEn_hook),
		.done(draw_hook_done));

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





