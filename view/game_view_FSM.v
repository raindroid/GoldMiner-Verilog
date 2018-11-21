//view_fsm
//designed by Yifan Cui
module game_view_FSM(
	clk, 
	resetn,
	go,
	
	draw_gold_done,
	draw_stone_done,
	draw_diamond_done,
	draw_background_done,
	draw_hook_done,
	draw_num_done,
	draw_gameover_done,
	draw_stone_flag,
	
	gold_count,
	stone_count,
	diamond_count,
	max_stone,
	max_gold,
	max_diamond,


	game_end,
	
	enable_draw_gold,
	enable_draw_stone,
	enable_draw_diamond,
	enable_draw_background,
	enable_draw_gameover,
	enable_random,
	enable_draw_hook,
	enable_draw_num,
	timer_enable,
	time_resetn,

	resetn_gold_stone_diamond

	);
	input clk;
	input resetn;
	input go;


	input draw_gold_done,
			draw_stone_done,
			draw_diamond_done,
			draw_background_done,
			draw_hook_done,
			draw_num_done,
			draw_gameover_done;
			
	
	input [7:0]gold_count;
	input [7:0]stone_count;
	input [7:0]diamond_count;
	
	
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
					enable_draw_num,
					enable_draw_gameover,
					resetn_gold_stone_diamond,
					timer_enable,
					time_resetn,
					draw_stone_flag;

	reg [6:0] current_state, next_state; 
    
   localparam   
					START  = 6'd20,
					 GENERATE_X_Y         = 6'd3,
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

					DRAW_NUM 			= 6'd14,
					GAME						 = 6'd15,
					DRAW_GAMEOVER                = 6'd21,
					DRAW_GAMEOVER_WAIT               = 6'd21,
					 
					GAME_DONE				 = 6'd16;
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
					START: begin
						next_state = (go)? GENERATE_X_Y : START;
					end
					GENERATE_X_Y: begin
						next_state = DRAW_BACKGROUND;
					end
                	DRAW_BACKGROUND: begin
						next_state = (draw_background_done) ? DRAW_BACKGROUND_WAIT : DRAW_BACKGROUND;
						end // Loop in current state until value is input
                	DRAW_BACKGROUND_WAIT:begin
						if ((stone_count == max_stone) & (gold_count == max_gold) & (diamond_count == max_diamond))
							next_state = DRAW_HOOK;
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

					DRAW_NUM : begin
					  	next_state = (draw_num_done) ? GAME : DRAW_NUM;
					end
					 GAME: begin
					 	if((game_end)) next_state = DRAW_GAMEOVER_WAIT;
						else
							next_state = (frame) ? DRAW_BACKGROUND : GAME;
					 end
					 DRAW_GAMEOVER: begin
						next_state = DRAW_GAMEOVER_WAIT;
					 end
					 DRAW_GAMEOVER_WAIT:begin
					   	next_state = (draw_gameover_done) ? GAME_DONE : DRAW_GAMEOVER_WAIT;
					 end
					 GAME_DONE: begin
						next_state = (go) ? DRAW_BACKGROUND : GAME_DONE;
					 
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
			enable_draw_num = 1'b0;
			enable_draw_gameover = 1'b0;
			resetn_gold_stone_diamond = 1'b1;
			timer_enable = 1'b0;
			time_resetn = 1'b1;
			draw_stone_flag =1'b1;


        case (current_state)
			GENERATE_X_Y: begin
			  	enable_random = 1'b1;
				time_resetn = 1'b0;
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
			  	enable_draw_hook = 1'b1;
				  timer_enable = 1'b1;
			end
			DRAW_HOOK_WAIT: begin
			  	enable_draw_hook = 1'b1;
				  timer_enable = 1'b1;
			end
			DRAW_NUM: begin
			  	enable_draw_num = 1'b1;
				  timer_enable = 1'b1;
			end
			DRAW_GAMEOVER: begin
			  	enable_draw_gameover = 1'b1;
				  timer_enable = 1'b1;
			end
			DRAW_GAMEOVER_WAIT: begin
			  	enable_draw_gameover = 1'b1;
				  timer_enable = 1'b1;
				  end
			GAME: begin
				draw_stone_flag = 1'b0;
				resetn_gold_stone_diamond = 1'b0;
				timer_enable = 1'b1;
				end
			
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn == 0)
            current_state <= GENERATE_X_Y;
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


