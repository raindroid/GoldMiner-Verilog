//view_fsm
//designed by Yifan Cui
module game_view_FSM(
	clk, 
	resetn,
	go,
	
	draw_gold_done,
	draw_stone_done,
	draw_background_done,
	draw_hook_done,
	
	gold_count,
	stone_count,

	
	frame,
	clockwise,
	drop_end,
	drag_end,
	
	
	game_end,
	drop,
	
	enable_draw_gold,
	enable_draw_stone,
	enable_draw_background,
	enable_random,
	enable_draw_hook,
	resetn_gold_stone

	);
	input clk;
	input resetn;
	input go;


	input draw_gold_done,
			draw_stone_done,
			draw_background_done,
			draw_hook_done;
	
	input [2:0]gold_count;
	input [2:0]stone_count;
	
	input frame;
	input clockwise;
	input drop_end;
	input drag_end;

	
	input game_end, drop;
	
	parameter max_stone = 3'd5;
	parameter max_gold  = 3'd5;
	
	output reg 	enable_draw_gold,
					enable_draw_stone,
					enable_draw_background,
					enable_random,
					enable_draw_hook,
					resetn_gold_stone;

	reg [6:0] current_state, next_state; 
    
   localparam   
	
					 DRAW_BACKGROUND      = 6'd0,
					 DRAW_BACKGROUND_WAIT = 6'd1,
					 GENERATE_X        	 = 6'd2,
					 GENERATE_Y           = 6'd3,
					 RANDOM_WAIT			 = 6'd4,
					 DRAW_GOLD            = 6'd5,

					 DRAW_GOLD_DONE		 = 6'd7,
					 DRAW_STONE 			 = 6'd8,

					 DRAW_STONE_DONE		 = 6'd10,

					DRAW_HOOK			= 6'd12,
					DRAW_HOOK_WAIT		= 6'd13,

					 GAME						 = 6'd11,
					 
//					 DEGREE_30				 = 6'd12,
//					 DEGREE_30_WAIT		 = 6'd13,
//					 DEGREE_40				 = 6'd14,
//					 DEGREE_40_WAIT		 = 6'd15,
//					 DEGREE_50				 = 6'd16,
//					 DEGREE_50_WAIT		 = 6'd17,
//					 DEGREE_60				 = 6'd18,
//					 DEGREE_60_WAIT		 = 6'd19,
//					 DEGREE_80				 = 6'd20,
//					 DEGREE_80_WAIT		 = 6'd21,
//					 DEGREE_90				 = 6'd22,
//					 DEGREE_90_WAIT		 = 6'd23,
//					 DEGREE_100				 = 6'd24,
//					 DEGREE_100_WAIT		 = 6'd25,
//					 DEGREE_120				 = 6'd26,
//					 DEGREE_120_WAIT		 = 6'd27,
//					 DEGREE_130				 = 6'd28,
//					 DEGREE_130_WAIT		 = 6'd29,
//					 DEGREE_140				 = 6'd30,
//					 DEGREE_140_WAIT		 = 6'd31,
//					 DEGREE_150				 = 6'd32,
//					 DEGREE_150_WAIT		 = 6'd33,
//					 DROP						 = 6'd34,
//					 DROP_WAIT				 = 6'd35,
//					 DROP_DONE				 = 6'd36,
//					 DRAG						 = 6'd37,
//					 DRAG_WAIT				 = 6'd38,
//					 DRAG_DONE				 = 6'd39,
					 
					 GAME_DONE				 = 6'd40;
					 

                
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                DRAW_BACKGROUND: begin
						next_state = (draw_background_done) ? DRAW_BACKGROUND_WAIT : DRAW_BACKGROUND;
						end // Loop in current state until value is input
                DRAW_BACKGROUND_WAIT:begin
						next_state = ((stone_count > max_stone) & (gold_count > max_gold)) ? DRAW_HOOK : GENERATE_X; 
						end
					 GENERATE_X: begin
						next_state = GENERATE_Y;
						end
					 GENERATE_Y: begin
						next_state = (gold_count > max_gold) ? DRAW_STONE : DRAW_GOLD;
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

					 DRAW_HOOK: begin
					 	next_state = DRAW_HOOK_WAIT;
					end
					
					DRAW_HOOK_WAIT: begin
					  	next_state = (draw_hook_done) ? DRAW_HOOK_WAIT : GAME;
					end
					 
					 GAME: begin
						next_state = (game_end) ? GAME_DONE : DRAW_BACKGROUND;
					 end
					 GAME_DONE: begin
						next_state = (go) ? DRAW_BACKGROUND : GAME_DONE;
					 
					 end

            default:     next_state = DRAW_BACKGROUND;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        
			enable_draw_gold = 1'b0;
			enable_draw_stone = 1'b0;
			enable_draw_background = 1'b0;
			enable_random = 1'b0;
			enable_draw_hook = 1'b0;
			resetn_gold_stone = 1'b1;


        case (current_state)
				DRAW_BACKGROUND: begin
					enable_draw_background = 1'b1;
				end
            GENERATE_X: begin
					enable_random = 1'b1; //load x
					end
            GENERATE_Y: begin
					enable_random = 1'b1; //load y
					end
            DRAW_GOLD: begin
					enable_draw_gold = 1'b1;
					end
			DRAW_STONE: begin
				enable_draw_stone = 1'b1;
				end	
			DRAW_HOOK: begin
			  	enable_draw_hook = 1'b1;
			end
			DRAW_HOOK_WAIT: begin
			  	enable_draw_hook = 1'b1;
			end
			GAME: begin
				resetn_gold_stone = 1'b0;
				end
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn == 0)
            current_state <= DRAW_BACKGROUND;
        else
            current_state <= next_state;
    end // state_FFS
	 
endmodule


