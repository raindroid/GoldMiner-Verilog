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
		writeEn,
		LEDR
		
		);
	input clk, resetn;
	input go;
	
	output reg[8:0]X_out;
	output reg[7:0]Y_out;
	output reg[11:0]Color_out;
	output reg writeEn;

	output [9:0] 	LEDR;
	
	wire [7:0]random;
	
	
	wire [8:0]x_init;
	wire [7:0]y_init;
	
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
		else if(enable_draw_diamond)begin
			X_out <= X_out_diamond;
			Y_out <= Y_out_diamond;
			Color_out <= Color_out_diamond;
			if(Color_out == 12'b0) 
				writeEn <= 1'b0;
			else
				writeEn <= writeEn_diamond;
		end
		else if(enable_draw_background)begin
			X_out <= X_out_background;
			Y_out <= Y_out_background;
			Color_out <= Color_out_background;
			writeEn <= writeEn_background;
		end
		else if (enable_draw_hook) begin
			X_out = X_out_hook;
			Y_out = Y_out_hook;
			Color_out = Color_out_hook;
			writeEn = writeEn_hook;
		end
		else if (enable_draw_num) begin
		  	X_out = X_out_num;
			Y_out = Y_out_num;
			Color_out = Color_out_num;
			if(Color_out == 12'b0)
				writeEn <= 1'b0;
			else
				writeEn <= writeEn_num;
		end
	end
	
	
	
	//instanciate lfsr to generate random x and y;
	wire enable_random;
	
	/*
	
	lfsr l(
	.out(random),
	.clk(clk),
	.rst(resetn)
	);
	
	always@(posedge clk)begin
	 if(enable_random)begin
		if(random[3:0] * 5'd20 <= 9'd300) begin
			x_init[8:0] <= random[3:0] * 5'd20;
		end
		else begin
			x_init[7:0] <= random[6:4] * 5'd20;
			x_init[8] <= 1'b0;
			end
		end

	end
	
	always@(posedge clk)begin
	 if(enable_random)begin
		if(random[5:3] * 5'd20 <= 8'd140) begin
			y_init[7:0] <= random[5:3] * 5'd20 + 7'd80;
		end
		else begin
			y_init[6:0] <= random[6:5] * 5'd20 + 7'd80;
			y_init[7] <= 1'b0;
			end
		end
	end
	*/
	localparam MAX_SIZE = 32 << 5; //1024
	wire [MAX_SIZE - 1: 0] data;
	wire [4:0]counter;
	wire [63:0]moveIndex;
	assign moveIndex = 0;
	 ItemMap item_map(
    .clock(clk),
    .resetn(resetn), 
    .generateEn(enable_random), 
    .size(16),
    .data(data),
    .counter(counter),
    .quantity(0),

    .moveEn(0),
    .moveIndex(moveIndex),
    .moveX(0),      //please multiple by << 4
    .moveY(0),   

    .moveEn2(0),
    .moveIndex2(moveIndex),
    .moveX2(0),      //please multiple by << 4
    .moveY2(0),   

    .moveState2(0),
    .visible2(0),
    .moveState(0),
    .visible(0),
 );
	assign x_init = (data[moveIndex * 32 + 31] << 4) + 
                    (data[moveIndex * 32 + 30] << 3) + 
                    (data[moveIndex * 32 + 29] << 2) + 
                     (data[moveIndex * 32 + 28] << 1) + 
                     (data[moveIndex * 32 + 27] << 0);
     assign y_init = (data[moveIndex * 32 + 18] << 3) + 
                     (data[moveIndex * 32 + 17] << 2) + 
                    (data[moveIndex * 32 + 16] << 1) + 
                    (data[moveIndex * 32 + 15] << 0);


	//instantiate view fsm
	
	game_view_FSM game_view(
		.clk(clk), 
		.resetn(resetn),
		.go(go),
	
		.draw_gold_done(draw_gold_done),
		.draw_stone_done(draw_stone_done),
		.draw_diamond_done(draw_diamond_done),
		.draw_background_done(draw_background_done),
		
		.draw_hook_done(draw_hook_done), 
		.draw_num_done(draw_num_done),
	
		.gold_count(gold_count),
		.stone_count(stone_count),
		.diamond_count(diamond_count),
	
		.game_end(1),
	
		.enable_draw_gold(enable_draw_gold),
		.enable_draw_stone(enable_draw_stone),
		.enable_draw_diamond(enable_draw_diamond),
		.enable_draw_background(enable_draw_background),
		.enable_draw_hook(enable_draw_hook),
		.enable_random(enable_random),
		.enable_draw_num(enable_draw_num),
		.resetn_gold_stone_diamond(resetn_gold_stone_diamond)

	);
	
	
	
	//instantiate all the drawing datapath and FSMs
	
	wire resetn_c_gold, 
		  enable_c_gold, 
		  load_x_gold,
		  load_y_gold,
		  enable_x_adder_gold, 
		  enable_y_adder_gold,
		  enable_gold_count,
		  resetn_gold_stone_diamond;
		  
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
		.resetn_gold_stone(resetn_gold_stone_diamond),

		
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
		.resetn_gold_stone(resetn_gold_stone_diamond),

		
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
	

	wire [8:0]X_out_diamond; 
	wire [7:0]Y_out_diamond; 
	wire [11:0]Color_out_diamond;


	wire [2:0]diamond_count;
	
	wire enable_draw_diamond;
	wire writeEn_diamond;
	wire draw_diamond_done;

	draw_diamond dd0(
    	.clk(clk), 
		.resetn(resetn),
		.enable_draw_diamond(enable_draw_diamond),
		.resetn_gold_stone_diamond(resetn_gold_stone_diamond),

    	.x_init(x_init),
    	.y_init(y_init),

		.X_out_diamond(X_out_diamond),
    	.Y_out_diamond(Y_out_diamond),
    	.Color_out_diamond(Color_out_diamond),
    	.writeEn_diamond(writeEn_diamond),
    	.draw_diamond_done(draw_diamond_done),
    	.diamond_count(diamond_count)
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
		.length(50),
		.degree(15),
		.outX(X_out_hook),
		.outY(Y_out_hook),
		.color(Color_out_hook),
		.writeEn(writeEn_hook),
		.done(draw_hook_done),
		.LEDR(LEDR)
	);

	wire 	[8:0] X_out_num;
	wire	[7:0] Y_out_num;
	wire	[11:0] Color_out_num;
	wire	writeEn_num,
		draw_num_done,
		enable_draw_num;

	score_and_time_display display_num(
    	.clk(clk),
    	.resetn(resetn),
    	.score_to_display(1035),
    	.time_remained(25),
		.goal(500),
    	.enable_score_and_time_display(enable_draw_num),

    	.outX(X_out_num),
    	.outY(Y_out_num),
    	.color(Color_out_num),
    	.writeEn(writeEn_num),

    	.display_score_and_time_done(draw_num_done)
    );


endmodule







