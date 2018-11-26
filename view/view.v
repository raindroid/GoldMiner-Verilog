//view_data module
// This module is the for game view data 
// input:
// 		clk, 
// 		resetn,
// 		go,
// 		drop,
// 		bomb,
// output:
// 		X_out,
// 		Y_out,
// 		Color_out,
// 		writeEn,
//designed by Yifan Cui
module view(
		clk, 
		resetn,
		go,
		drop,
		drop2,
		mode,
		bomb,

		X_out,
		Y_out,
		Color_out,
		writeEn,
		LEDR,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5
		
		);
	input clk, resetn;
	input go, drop, drop2, mode, bomb;

	
	output reg[8:0]X_out;
	output reg[7:0]Y_out;
	output reg[11:0]Color_out;
	output reg writeEn;

	output [9:0] 	LEDR;
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	
	wire [7:0]random;
	
	
	wire [8:0]x_init;
	wire [7:0]y_init;

	wire visible;
	assign visible = read_data[1];
	
	always@(posedge clk)begin
		if(enable_draw_gold) begin
			X_out <= X_out_gold;
			Y_out <= Y_out_gold;
			Color_out <= Color_out_gold;
			if(Color_out == 12'b0 | !visible) 
				writeEn <= 1'b0;
			else
				writeEn <= writeEn_gold;
		end
		else if(enable_draw_stone)begin
			X_out <= X_out_stone;
			Y_out <= Y_out_stone;
			Color_out <= Color_out_stone;
			if(Color_out == 12'b0 | !visible) 
				writeEn <= 1'b0;
			else
				writeEn <= writeEn_stone;
		end
		else if(enable_draw_diamond )begin
			X_out <= X_out_diamond;
			Y_out <= Y_out_diamond;
			Color_out <= Color_out_diamond;
			if(Color_out == 12'b0 | !visible
			) 
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
		else if (enable_draw_hook1) begin
			X_out = X_out_hook1;
			Y_out = Y_out_hook1;
			Color_out = Color_out_hook1;
			writeEn = writeEn_hook1;
		end
		else if (enable_draw_hook2) begin
			X_out = X_out_hook2;
			Y_out = Y_out_hook2;
			Color_out = Color_out_hook2;
			writeEn = writeEn_hook2;
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
		else if(enable_draw_gameover)begin
			X_out <= X_out_gameover;
			Y_out <= Y_out_gameover;
			Color_out <= Color_out_gameover;
			writeEn <= writeEn_gameover;
		end

		else if(enable_draw_game_next_level)begin
			X_out <= X_out_game_next_level;
			Y_out <= Y_out_game_next_level;
			Color_out <= Color_out_game_next_level;
			writeEn <= writeEn_game_next_level;
		end

		else if(enable_draw_gamestart)begin
			X_out <= X_out_gamestart;
			Y_out <= Y_out_gamestart;
			Color_out <= Color_out_gamestart;
			writeEn <= writeEn_gamestart;
		end

	end
	
	//reg mode
	reg p2;
	always@(*)begin
		if(!resetn) p2 = 0;
		else if(mode) p2 =1'b1;
		else if(game_end) p2 = 0;
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

	
	
	assign x_init = read_data[31:23];
	assign y_init = read_data[18:11];

	localparam max_gold = 4'd5;
	localparam max_stone = 4'd7;
	localparam max_diamond = 4'd3;
	//instantiate view fsm
	
	game_view_FSM game_view(
		.clk(clk), 
		.resetn(resetn),
		.go(go),
		.mode(p2),
		.next_level(next_level),
	
		.draw_gold_done(draw_gold_done),
		.draw_stone_done(draw_stone_done),
		.draw_diamond_done(draw_diamond_done),
		.draw_background_done(draw_background_done),
		
		.draw_hook_done(draw_hook_done), 
		.draw_hook_done1(draw_hook_done1), 
		.draw_hook_done2(draw_hook_done2), 
		.draw_num_done(draw_num_done),
		.draw_gameover_done(draw_gameover_done),
		.draw_game_next_level_done(draw_game_next_level_done),
		.draw_gamestart_done(draw_gamestart_done),
		.draw_stone_flag(draw_stone_flag),
	
		.gold_count(gold_count),
		.stone_count(stone_count),
		.diamond_count(diamond_count),
		.max_stone(max_stone),
		.max_gold(max_gold),
		.max_diamond(max_diamond),
	
		.game_end(game_end),
	
		.enable_draw_gold(enable_draw_gold),
		.enable_draw_stone(enable_draw_stone),
		.enable_draw_diamond(enable_draw_diamond),
		.enable_draw_background(enable_draw_background),
		.enable_draw_hook(enable_draw_hook),
		.enable_draw_hook1(enable_draw_hook1),
		.enable_draw_hook2(enable_draw_hook2),
		.enable_random(enable_random),
		.enable_draw_num(enable_draw_num),
		.enable_draw_gameover(enable_draw_gameover),
		.enable_draw_game_next_level(enable_draw_game_next_level),
		.enable_draw_gamestart(enable_draw_gamestart),
		.resetn_gold_stone_diamond(resetn_gold_stone_diamond),
		.timer_enable(timer_enable),
		.time_resetn(time_resetn),
		.resetn_rope(resetn_rope),
		.level_up(level_up),
		.LEDR(LEDR)

	);
	
	wire resetn_rope;
	
	wire level_up;
	

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


	wire [7:0]gold_count;
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


	wire [7:0]stone_count;
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


	wire [13:0]diamond_count;
	
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
		.resetn_gold_stone_diamond(resetn_gold_stone_diamond),

		
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

	draw_hook hook0(
		.clock(clk), 
		.resetn(resetn),
		.enable(enable_draw_hook),
		.length(rope_len),
		.degree(degree),
		.outX(X_out_hook),
		.outY(Y_out_hook),
		.color(Color_out_hook),
		.writeEn(writeEn_hook),
		.done(draw_hook_done)

	);

	//for 2-player mode
	wire 	[8:0] X_out_hook1;
	wire	[7:0] Y_out_hook1;
	wire	[11:0] Color_out_hook1;
	wire	writeEn_hook1,
		draw_hook_done1,
		enable_draw_hook1;

	draw_hook hook1(
		.clock(clk), 
		.resetn(resetn),
		.enable(enable_draw_hook1),
		.length(rope_len1),
		.degree(degree1),
		.outX(X_out_hook1),
		.outY(Y_out_hook1),
		.color(Color_out_hook1),
		.writeEn(writeEn_hook1),
		.done(draw_hook_done1)

	);


	wire 	[8:0] X_out_hook2;
	wire	[7:0] Y_out_hook2;
	wire	[11:0] Color_out_hook2;
	wire	writeEn_hook2,
		draw_hook_done2,
		enable_draw_hook2;

	draw_hook hook2(
		.clock(clk), 
		.resetn(resetn),
		.enable(enable_draw_hook2),
		.length(rope_len2),
		.degree(degree2),
		.outX(X_out_hook2),
		.outY(Y_out_hook2),
		.color(Color_out_hook2),
		.writeEn(writeEn_hook2),
		.done(draw_hook_done2)

	);




	wire 	[8:0] X_out_num;
	wire	[7:0] Y_out_num;
	wire	[11:0] Color_out_num;
	wire	writeEn_num,
		draw_num_done,
		enable_draw_num;
	wire [7:0] time_remained;

	wire [11:0]goal = 12'd50;
	score_and_time_display display_num(
    	.clk(clk),
    	.resetn(resetn),
    	.score_to_display(current_score),
    	.time_remained(time_remained),
		.goal(goal),
    	.enable_score_and_time_display(enable_draw_num),

    	.outX(X_out_num),
    	.outY(Y_out_num),
    	.color(Color_out_num),
    	.writeEn(writeEn_num),

    	.display_score_and_time_done(draw_num_done)
    );
	 
	reg next_level;
	always@(posedge clk)begin
		if(!resetn | !time_resetn) next_level = 1'b0;
		else if(current_score >= goal)
			next_level = 1'b1;
		else next_level = 1'b0;
	end
	

	wire timer_enable, time_resetn;
	wire time_up;
	

	timer t0(
		.clk(clk),
		.resetn(resetn),
		.timer_enable(timer_enable),
		.time_resetn(time_resetn),
		.time_remain(time_remained),
		.time_up(time_up)
	);

	wire [9:0] rotation_speed, line_speed, endX, endY, degree, draw_stone_flag;
	wire [9:0]rope_len;
	wire [9:0] current_score;
	wire [31:0]read_data;

	//rope ram module instanciation
	Rope rope0(
		.clock(clk),
		.resetn(resetn_rope), 
		.enable(1),
		
		.draw_stone_flag(draw_stone_flag), //on when the previous drawing is in process
		.draw_index(stone_count + gold_count + diamond_count),
		.quantity(max_gold+max_diamond+max_stone),

		.go_KEY(drop), //physical key for the go input
		//bomb_KEY,
		// input bomb_quantity,

		.rotation_speed(rotation_speed),
		.line_speed(line_speed),
		.endX(endX), 
		.endY(endY), 
		.degree(degree), //not all the output is useful
		.rope_len(rope_len),

		.data(read_data),
		.current_score(current_score),
		//.LEDR(LEDR),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5)
		// output bomb_use

 	);


	//for 2 players mode
	wire [9:0] endX1, endY1, degree1;
	wire [9:0]rope_len1;
	wire [9:0] current_score1;
	wire [31:0]read_data1;
	Rope1 rope1(
		.clock(clk),
		.resetn(resetn_rope), 
		.enable(1),
		
		.draw_stone_flag(draw_stone_flag), //on when the previous drawing is in process
		.draw_index(stone_count + gold_count + diamond_count),
		.quantity(max_gold+max_diamond+max_stone),

		.go_KEY(drop), //physical key for the go input
		//bomb_KEY,
		// input bomb_quantity,

		.endX(endX1), 
		.endY(endY1), 
		.degree(degree1), //not all the output is useful
		.rope_len(rope_len1),

		.data(read_data1),
		.current_score(current_score1)
		// output bomb_use

 	);

	wire [9:0] endX2, endY2, degree2;
	wire [9:0]rope_len2;
	wire [9:0] current_score2;
	wire [31:0]read_data2;
	Rope2 rope2(
		.clock(clk),
		.resetn(resetn_rope), 
		.enable(1),
		
		.draw_stone_flag(draw_stone_flag), //on when the previous drawing is in process
		.draw_index(stone_count + gold_count + diamond_count),
		.quantity(max_gold+max_diamond+max_stone),

		.go_KEY(drop2), //physical key for the go input
		//bomb_KEY,
		// input bomb_quantity,

		.endX(endX2), 
		.endY(endY2), 
		.degree(degree2), //not all the output is useful
		.rope_len(rope_len2),

		.data(read_data2),
		.current_score(current_score2)
		// output bomb_use

 	);



	// reg [7:0]max_degree,min_degree;
	// always@(posedge clk)begin
	// 	if(!resetn) begin
	// 		max_degree <= 0;
	// 		min_degree <= 0;
	// 	end
	// 	else if(degree > max_degree) max_degree <= degree[7:0];
	// 	else if(degree < min_degree) min_degree <= degree[7:0];
	// end

	wire enable_draw_gameover;
	wire [8:0]X_out_gameover;
	wire [7:0]Y_out_gameover;
	wire [11:0]Color_out_gameover;
	wire draw_gameover_done;
	wire writeEn_gamestart,writeEn_gameover;
	

	draw_gameover dgo0(
    .clk(clk), 
	.resetn(resetn),
	.enable_draw_gameover(enable_draw_gameover),
	.resetn_gold_stone_gameover(resetn_gold_stone_diamond),

	.X_out_gameover(X_out_gameover),
    .Y_out_gameover(Y_out_gameover),
    .Color_out_gameover(Color_out_gameover),
    .writeEn_gameover(writeEn_gameover),
    .draw_gameover_done(draw_gameover_done)
);

	wire enable_draw_game_next_level;
	wire [8:0]X_out_game_next_level;
	wire [7:0]Y_out_game_next_level;
	wire [11:0]Color_out_game_next_level;
	wire draw_game_next_level_done;
	wire writeEn_game_next_level;
	

	draw_game_next_level dgn0(
    .clk(clk), 
	.resetn(resetn),
	.enable_draw_game_next_level(enable_draw_game_next_level),
	.resetn_gold_stone_game_next_level(resetn_gold_stone_diamond),
	.level_up(level_up),

	.X_out_game_next_level(X_out_game_next_level),
    .Y_out_game_next_level(Y_out_game_next_level),
    .Color_out_game_next_level(Color_out_game_next_level),
    .writeEn_game_next_level(writeEn_game_next_level),
    .draw_game_next_level_done(draw_game_next_level_done)
);




	wire enable_draw_gamestart;
	wire [8:0]X_out_gamestart;
	wire [7:0]Y_out_gamestart;
	wire [11:0]Color_out_gamestart;
	wire draw_gamestart_done;
	
	draw_gamestart dgs0(
    .clk(clk), 
	.resetn(resetn),
	.enable_draw_gamestart(enable_draw_gamestart),
	.resetn_gold_stone_gamestart(resetn_gold_stone_diamond),

	.X_out_gamestart(X_out_gamestart),
    .Y_out_gamestart(Y_out_gamestart),
    .Color_out_gamestart(Color_out_gamestart),
    .writeEn_gamestart(writeEn_gamestart),
    .draw_gamestart_done(draw_gamestart_done)
);

	wire game_end;
	assign game_end = time_up;

	


endmodule







