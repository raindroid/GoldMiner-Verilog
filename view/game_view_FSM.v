//this module controls the view module
// input:	
	// clk, 
	// resetn,
	// go,
	// next_level,
	
	// draw_gold_done,
	// draw_stone_done,
	// draw_diamond_done,
	// draw_background_done,
	// draw_hook_done,
	// draw_num_done,
	// draw_gameover_done,
	// draw_gamestart_done,
	// draw_game_next_level_done,
	// draw_stone_flag,
	// level_up,
	
	// gold_count,
	// stone_count,
	// diamond_count,
	// max_stone,
	// max_gold,
	// max_diamond,

//output:
	// game_end,
	
	// enable_draw_gold,
	// enable_draw_stone,
	// enable_draw_diamond,
	// enable_draw_background,
	// enable_draw_gameover,
	// enable_draw_game_next_level,
	// enable_draw_gamestart,
	// enable_random,
	// enable_draw_hook,
	// enable_draw_num,
	// timer_enable,
	// time_resetn,
	// resetn_rope,
	// 	resetn_gold_stone_diamond

//designed by Yifan Cui
module game_view_FSM(
	clk, 
	resetn,
	go,
	mode,
	next_level,
	reset_done,
	
	draw_gold_done,
	draw_stone_done,
	draw_diamond_done,
	draw_background_done,
	draw_hook_done,
	draw_hook_done1,
	draw_hook_done2,
	draw_num_done,
	draw_gameover_done,
	draw_gamestart_done,
	draw_game_next_level_done,
	draw_game_win_done,
	draw_stone_flag,
	level_up,
	resetn_level,
	
	gold_count,
	stone_count,
	diamond_count,
	max_stone,
	max_gold,
	max_diamond,
	level,


	game_end,
	
	enable_draw_gold,
	enable_draw_stone,
	enable_draw_diamond,
	enable_draw_background,
	enable_draw_gameover,
	enable_draw_game_next_level,
	enable_draw_game_win,
	enable_draw_gamestart,
	enable_random,
	enable_draw_hook,
	enable_draw_hook1,
	enable_draw_hook2,
	enable_draw_num,
	timer_enable,
	time_resetn,
	resetn_rope,

	resetn_gold_stone_diamond,
	LEDR

	);
	input clk;
	input resetn;
	input go;
	input mode;
	input next_level;
	input reset_done;


	input draw_gold_done,
			draw_stone_done,
			draw_diamond_done,
			draw_background_done,
			draw_hook_done,
			draw_hook_done1,
			draw_hook_done2,
			draw_num_done,
			draw_gameover_done,
			draw_game_next_level_done,
			draw_game_win_done,
			draw_gamestart_done;
			
	
	input [7:0]gold_count;
	input [7:0]stone_count;
	input [7:0]diamond_count;
	input [2:0]level;
	
	
	input game_end;
	
	input [4:0]max_stone;
	input [4:0]max_gold;
	input [4:0]max_diamond;
	
	output reg 	enable_draw_gold,
					enable_draw_stone,
					enable_draw_diamond,
					enable_draw_background,
					enable_random,
					enable_draw_hook,
					enable_draw_hook1,
					enable_draw_hook2,
					enable_draw_num,
					enable_draw_gameover,
					enable_draw_game_next_level,
					enable_draw_game_win,
					enable_draw_gamestart,
					resetn_gold_stone_diamond,
					timer_enable,
					time_resetn,
					draw_stone_flag,
					resetn_rope,
					level_up,
					resetn_level;
	output  reg [9:0] LEDR;
	

	reg [6:0] current_state, next_state; 
    
   localparam   
					START  = 6'd20,
					DRAW_GAMESTART                = 6'd22,
					DRAW_GAMESTART_WAIT               = 6'd23,
					 GENERATE_X_Y         = 6'd3,
					 //RESET_DONE           = 6'd36,
					 DRAW_BACKGROUND      = 6'd0,
					 

					 DRAW_BACKGROUND_WAIT = 6'd1,
					 
					 RANDOM_WAIT			 = 6'd4,
					 DRAW_GOLD            = 6'd5,
					 DRAW_GOLD_DONE		 = 6'd7,
					 DRAW_STONE 			 = 6'd8,
					 DRAW_STONE_DONE		 = 6'd9,
					 DRAW_DIAMOND			 = 6'd10,
					 DRAW_DIAMOND_DONE		 = 6'd11,

					DRAW_HOOK			= 6'd12,
					DRAW_HOOK_WAIT		= 6'd13,

					DRAW_HOOK1			= 6'd30,
					DRAW_HOOK_WAIT1		= 6'd31,

					DRAW_HOOK2			= 6'd32,
					DRAW_HOOK_WAIT2		= 6'd33,


					DRAW_NUM 			= 6'd14,
					GAME						 = 6'd15,
					DRAW_GAMEOVER                = 6'd21,

					DRAW_GAME_NEXT_LEVEL         =6'd25,

					GAME_DONE1				 = 6'd16,
					GAME_DONE1_WAIT        = 6'd17,
					GAME_DONE2              = 6'd28,
					LEVEL_UP                = 6'd29,
					DRAW_GAMEWIN                = 6'd34,
					DRAW_GAMEWIN_DONE                = 6'd35;
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
					START: begin
						next_state = DRAW_GAMESTART;
					end
					
					DRAW_GAMESTART: begin
						next_state = DRAW_GAMESTART_WAIT;
					 end
					 DRAW_GAMESTART_WAIT:begin
					   	next_state = (draw_gamestart_done) ? GENERATE_X_Y : DRAW_GAMESTART_WAIT;
					 end
					
					
					// RESET_DONE:begin
					// 	next_state = (reset_done) ? GENERATE_X_Y : RESET_DONE;
					// end
					
					GENERATE_X_Y: begin
						next_state = (go)? DRAW_BACKGROUND : GENERATE_X_Y;
					end

                	DRAW_BACKGROUND: begin
						next_state = (draw_background_done) ? DRAW_BACKGROUND_WAIT : DRAW_BACKGROUND;
						end // Loop in current state until value is input
                	DRAW_BACKGROUND_WAIT:begin
						if ((stone_count == max_stone) & (gold_count == max_gold) & (diamond_count == max_diamond))
							next_state = DRAW_HOOK1;
						else if((gold_count == max_gold) & (stone_count == max_stone))
							next_state = DRAW_DIAMOND;
						else
							next_state = ((gold_count == max_gold)) ? DRAW_STONE : DRAW_GOLD;
						end
					 
					 DRAW_GOLD: begin
						next_state = (draw_gold_done) ? DRAW_GOLD_DONE : DRAW_GOLD;
					   end

					 DRAW_GOLD_DONE: begin
						next_state = DRAW_BACKGROUND_WAIT;
					 end
					 
					 DRAW_STONE: begin
						next_state = (draw_stone_done) ? DRAW_STONE_DONE : DRAW_STONE;
					   end
					 
					 DRAW_STONE_DONE: begin
						next_state = DRAW_BACKGROUND_WAIT;
					 end

					DRAW_DIAMOND: begin
						next_state = (draw_diamond_done) ? DRAW_DIAMOND_DONE : DRAW_DIAMOND;
					   end
					 
					 DRAW_DIAMOND_DONE: begin
						next_state = DRAW_BACKGROUND_WAIT;
					 end

					DRAW_HOOK: begin
					 	next_state = DRAW_HOOK_WAIT;
					end
					
					DRAW_HOOK_WAIT: begin
					  	next_state = (draw_hook_done) ? DRAW_NUM : DRAW_HOOK_WAIT;
					end


					DRAW_HOOK1: begin
					 	next_state = DRAW_HOOK_WAIT1;
					end
					
					DRAW_HOOK_WAIT1: begin
					  	next_state = (draw_hook_done1) ? (mode? DRAW_HOOK2 : DRAW_NUM) : DRAW_HOOK_WAIT1;
					end


					DRAW_HOOK2: begin
					 	next_state = DRAW_HOOK_WAIT2;
					end
					
					DRAW_HOOK_WAIT2: begin
					  	next_state = (draw_hook_done2) ? DRAW_NUM : DRAW_HOOK_WAIT2;
					end


					DRAW_NUM : begin
					  	next_state = (draw_num_done) ? GAME : DRAW_NUM;
					end
					GAME: begin
					 	if(game_end & next_level == 1'b0) next_state = DRAW_GAMEOVER;
						else if (game_end & next_level == 1'b1) next_state = DRAW_GAME_NEXT_LEVEL;
						else
							next_state = (frame) ? DRAW_BACKGROUND : GAME;
					 end
					 DRAW_GAMEOVER: begin
						next_state = (draw_gameover_done) ? GAME_DONE1 : DRAW_GAMEOVER;
					 end
					 DRAW_GAME_NEXT_LEVEL: begin
						next_state = (draw_game_next_level_done) ? GAME_DONE2 : DRAW_GAME_NEXT_LEVEL;
					 end
					 GAME_DONE1: begin
						next_state = (go)? GAME_DONE1_WAIT : GAME_DONE1;
					 end
					 GAME_DONE1_WAIT:begin
					 	next_state = (~go)? DRAW_GAMESTART : GAME_DONE1;
					 end
					 GAME_DONE2:begin
					 	if(level == 2'd3) 
						 	next_state = DRAW_GAMEWIN;
						else
					   		next_state = (go) ? LEVEL_UP : GAME_DONE2;
					 end
					 DRAW_GAMEWIN:begin
						next_state = (draw_game_win_done)? DRAW_GAMEWIN_DONE : DRAW_GAMEWIN;
					 end
					 DRAW_GAMEWIN_DONE:begin
						next_state = (go)? DRAW_GAMESTART : DRAW_GAMEWIN_DONE;
					 end
					 LEVEL_UP: begin
						next_state = DRAW_BACKGROUND;
					 end


            default:     next_state = START;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
			
			enable_draw_gold = 1'b0;
			enable_draw_stone = 1'b0;
			enable_draw_diamond =1'b0;
			enable_draw_background = 1'b0;
			enable_random = 1'b0;
			enable_draw_hook = 1'b0;
			enable_draw_hook1 = 1'b0;
			enable_draw_hook2 = 1'b0;

			enable_draw_num = 1'b0;
			enable_draw_gameover = 1'b0;
			enable_draw_game_next_level = 1'b0;
			enable_draw_game_win = 1'b0;
			enable_draw_gamestart = 1'b0;
			resetn_gold_stone_diamond = 1'b1;
			timer_enable = 1'b0;
			time_resetn = 1'b1;
			draw_stone_flag =1'b1;
			resetn_rope = 1'b1;
			level_up = 1'b0;
			resetn_level = 1'b1;
			LEDR[9:0] = 0;
			


        case (current_state)
			DRAW_GAMESTART: begin
			  	enable_draw_gamestart = 1'b1;
				  resetn_rope = 1'b0;
				  draw_stone_flag = 1'b0;
			end
			DRAW_GAMESTART_WAIT: begin
			  	enable_draw_gamestart = 1'b1;
				  resetn_rope = 1'b0;
				  draw_stone_flag = 1'b0;
				  end

			GENERATE_X_Y: begin
			  	enable_random = 1'b1;
				time_resetn = 1'b0;
				resetn_rope = 1'b0;
			end
			DRAW_BACKGROUND: begin
				enable_draw_background = 1'b1;
				timer_enable = 1'b1;
			end
            DRAW_GOLD: begin
				enable_draw_gold = 1'b1;
				timer_enable = 1'b1;
			end
			DRAW_STONE: begin
				enable_draw_stone = 1'b1;
				timer_enable = 1'b1;
			end	
			DRAW_DIAMOND: begin
				enable_draw_diamond = 1'b1;
				timer_enable = 1'b1;
			end	
			DRAW_HOOK: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_hook = 1'b1;
				timer_enable = 1'b1;
			end
			DRAW_HOOK_WAIT: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_hook = 1'b1;
				timer_enable = 1'b1;
			end

			DRAW_HOOK1: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_hook1 = 1'b1;
				timer_enable = 1'b1;
			end
			DRAW_HOOK_WAIT1: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_hook1 = 1'b1;
				timer_enable = 1'b1;
				LEDR[0] = 1;
			end

			DRAW_HOOK2: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_hook2 = 1'b1;
				timer_enable = 1'b1;
			end
			DRAW_HOOK_WAIT2: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_hook2 = 1'b1;
				timer_enable = 1'b1;
				LEDR[1] = 1;
			end

			DRAW_NUM: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_num = 1'b1;
				timer_enable = 1'b1;
			end
			DRAW_GAMEOVER: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_gameover = 1'b1;
				
			end

			DRAW_GAME_NEXT_LEVEL: begin
				draw_stone_flag = 1'b0;
			  	enable_draw_game_next_level = 1'b1;

			end
			GAME: begin
				draw_stone_flag = 1'b0;
				resetn_gold_stone_diamond = 1'b0;
				timer_enable = 1'b1;
				end
			GAME_DONE1:begin
				time_resetn = 1'b0;
				resetn_gold_stone_diamond = 1'b0;
				resetn_rope = 1'b0;
				resetn_level = 1'b0;
				
			end
			GAME_DONE2:begin
				time_resetn = 1'b0;
				resetn_gold_stone_diamond = 1'b0;
				resetn_rope = 1'b0;

			end
			DRAW_GAMEWIN:begin
				draw_stone_flag = 1'b0;
			  	enable_draw_game_win = 1'b1;
			end
			DRAW_GAMEWIN_DONE:begin
				resetn_level = 1'b0;
			end
			LEVEL_UP: begin
			  level_up = 1'b1;
			end
			
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn == 0)
            current_state <= START;
        else
            current_state <= next_state;
    end // state_FFS
	 
	wire frame;
	rate_divider r1(
	.resetn(resetn), 
	.clock(clk), 
	.Enable(frame)
	);

endmodule


