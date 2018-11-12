//view_fsm
//designed by Yifan Cui
module game_view_FSM(
	clk, 
	plot, 
	resetn,
	background,
	go,
	
	
	cout,
	background_cout,
	gold_cout,
	stone_cout,
	frame,
	clockwise,
	drop_end,
	drag_end,
	degree_to_fsm,
	
	
	game_end,
	drop,
	
	
	enable_c,
	resetn_c,
	load_x,
	load_y,
	load_color,
	enable_x_adder,
	enable_y_adder,
	writeEn,
	draw_background,
	enable_gold,
	enable_stone,
	resetn_gold_stone
	load_stone,
	degree
	);
	
	input resetn;
	input background;
	input go;

	input [8:0]cout;
	input [16:0]background_cout;
	input [2:0]gold_cout;
	input [2:0]stone_cout;
	input frame;
	input clockwise;
	input drop_end;
	input drag_end;
	input [7:0]degree_to_fsm;
	
	input game_end, drop;
	
	parameter max_stone = 3'd5;
	parameter max_gold  = 3'd5;
	
	
	output reg enable_c, resetn_c, load_x, load_y, load_color, enable_x_adder, enable_y_adder, writeEn, draw_background;
	output reg enable_gold, enable_stone, resetn_gold_stone,load_stone;
	output reg [7:0]degree;
	
	
	reg [6:0] current_state, next_state; 
    
   localparam   
	
					 DRAW_BACKGROUND      = 6'd0,
					 DRAW_BACKGROUND_WAIT = 6'd1,
					 GENERATE_X        	 = 6'd2,
					 GENERATE_Y           = 6'd3,
					 RANDOM_WAIT			 = 6'd4,
					 DRAW_GOLD            = 6'd5,
					 DRAW_GOLD_WAIT		 = 6'd6,
					 DRAW_GOLD_DONE		 = 6'd7,
					 DRAW_STONE 			 = 6'd8,
					 DRAW_STONE_WAIT		 = 6'd9,
					 DRAW_STONE_DONE		 = 6'd10,
					 GAME						 = 6'd11,
					 
					 DEGREE_30				 = 6'd12,
					 DEGREE_30_WAIT		 = 6'd13,
					 DEGREE_40				 = 6'd14,
					 DEGREE_40_WAIT		 = 6'd15,
					 DEGREE_50				 = 6'd16,
					 DEGREE_50_WAIT		 = 6'd17,
					 DEGREE_60				 = 6'd18,
					 DEGREE_60_WAIT		 = 6'd19,
					 DEGREE_80				 = 6'd20,
					 DEGREE_80_WAIT		 = 6'd21,
					 DEGREE_90				 = 6'd22,
					 DEGREE_90_WAIT		 = 6'd23,
					 DEGREE_100				 = 6'd24,
					 DEGREE_100_WAIT		 = 6'd25,
					 DEGREE_120				 = 6'd26,
					 DEGREE_120_WAIT		 = 6'd27,
					 DEGREE_130				 = 6'd28,
					 DEGREE_130_WAIT		 = 6'd29,
					 DEGREE_140				 = 6'd30,
					 DEGREE_140_WAIT		 = 6'd31,
					 DEGREE_150				 = 6'd32,
					 DEGREE_150_WAIT		 = 6'd33,
					 DROP						 = 6'd34,
					 DROP_WAIT				 = 6'd35,
					 DROP_DONE				 = 6'd36,
					 DRAG						 = 6'd37,
					 DRAG_WAIT				 = 6'd38,
					 DRAG_DONE				 = 6'd39,
					 
					 GAME_DONE				 = 6'd40;
					 

                
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                DRAW_BACKGROUND: begin
						next_state = (background_cout == 17'b11111111111111111) ? DRAW_BACKGROUND_WAIT : DRAW_BACKGROUND;
						end // Loop in current state until value is input
                DRAW_BACKGROUND_WAIT:begin
						next_state = ((stone_cout > max_stone) & (gold_cout > max_gold)) ? GAME : GENERATE_X; 
						end
					 GENERATE_X: begin
						next_state = GENERATE_Y;
						end
					 GENERATE_Y: begin
						next_state = (gold_cout > max_gold) ? DRAW_STONE : DRAW_GOLD;
						end
					 DRAW_GOLD: begin
						next_state = (cout == 9'd256) ? DRAW_GOLD_DONE : DRAW_GOLD_WAIT;
					   end
					 DRAW_GOLD_WAIT: begin
						next_state = DRAW_GOLD;
					 end
					 DRAW_GOLD_DONE: begin
						next_state = DRAW_BACKGROUND_WAIT;
					 end
					 
					 DRAW_STONE: begin
						next_state = (cout == 9'd256) ? DRAW_STONE_DONE : DRAW_STONE_WAIT;
					   end
						
					 DRAW_STONE_WAIT: begin
						next_state = DRAW_STONE;
					 end
					 
					 DRAW_STONE_DONE: begin
						next_state = DRAW_BACKGROUND_WAIT;
					 end
					 
					 GAME: begin
						next_state = (game_end) ? GAME_DONE : DRAW_BACKGROUND;
					 end
					 
					 DEGREE_30: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_30_WAIT;
					 end
					 
					 DEGREE_30_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = (frame) ? DEGREE_40 : DEGREE_30_WAIT;
					 end
					 
					 DEGREE_40: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_40_WAIT;
					 end
					 
					 DEGREE_40_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_50 : DEGREE_40_WAIT;
						else next_state = (frame) ? DEGREE_30 : DEGREE_40_WAIT;
					 end
					 
					 DEGREE_50: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_50_WAIT;
					 end
					 
					 DEGREE_50_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_60 : DEGREE_50_WAIT;
						else next_state = (frame) ? DEGREE_40 : DEGREE_50_WAIT;
					 end
					 
					 DEGREE_60: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_60_WAIT;
					 end
					 
					 DEGREE_60_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_80 : DEGREE_60_WAIT;
						else next_state = (frame) ? DEGREE_50 : DEGREE_60_WAIT;
					 end
					 
					 DEGREE_80: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_80_WAIT;
					 end
					 
					 DEGREE_80_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_90 : DEGREE_80_WAIT;
						else next_state = (frame) ? DEGREE_60 : DEGREE_80_WAIT;
					 end
					 
					 DEGREE_90: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_90_WAIT;
					 end
					 
					 DEGREE_90_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_100 : DEGREE_90_WAIT;
						else next_state = (frame) ? DEGREE_80 : DEGREE_90_WAIT;
					 end
					 
					 DEGREE_100: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_100_WAIT;
					 end
					 
					 DEGREE_100_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_110 : DEGREE_100_WAIT;
						else next_state = (frame) ? DEGREE_90 : DEGREE_100_WAIT;
					 end
					 
					 DEGREE_120: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_120_WAIT;
					 end
					 
					 DEGREE_120_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_130 : DEGREE_120_WAIT;
						else next_state = (frame) ? DEGREE_100 : DEGREE_120_WAIT;
					 end
					 
					 DEGREE_130: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_130_WAIT;
					 end
					 
					 DEGREE_130_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_140 : DEGREE_130_WAIT;
						else next_state = (frame) ? DEGREE_120 : DEGREE_130_WAIT;
					 end
					 
					 DEGREE_140: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_140_WAIT;
					 end
					 
					 DEGREE_140_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else if(clockwise) next_state = (frame) ? DEGREE_150 : DEGREE_140_WAIT;
						else next_state = (frame) ? DEGREE_130 : DEGREE_140_WAIT;
					 end
					 
					 DEGREE_150: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = DEGREE_150_WAIT;
					 end
					 
					 DEGREE_150_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop) next_state = DROP;
						else next_state = (frame) ? DEGREE_140 : DEGREE_150_WAIT;
					 end
					 
					 DROP: begin
						if(game_end) next_state = GAME_DONE;
						else next_state = DROP_WAIT;
					 end
					 
					 DROP_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drop_end) next_state = DROP_DONE;
						else next_state = (frame) ? DROP : DROP_WAIT;
					 end
					 
					 DROP_DONE: begin
						if(game_end) next_state = GAME_DONE;
						else next_state = DRAG;
					 end
					 
					 DRAG: begin
						if(game_end) next_state = GAME_DONE;
						else next_state = DRAG_WAIT;
					 end
					 
					 DRAG_WAIT: begin
						if(game_end) next_state = GAME_DONE;
						else if(drag_end) next_state = DRAG_DONE;
						else next_state = (frame) ? DRAG : DRAG_WAIT;
					 end
					 
					 DRAG_DONE: begin
						if(game_end) next_state = GAME_DONE;
							case(degree_to_fsm) begin
								8'd30: next_state = DEGREE_30;
								8'd40: next_state = DEGREE_40;
								8'd50: next_state = DEGREE_50;
								8'd60: next_state = DEGREE_60;
								8'd80: next_state = DEGREE_80;
								8'd90: next_state = DEGREE_90;
								8'd100: next_state = DEGREE_100;
								8'd120: next_state = DEGREE_120;
								8'd130: next_state = DEGREE_130;
								8'd140: next_state = DEGREE_140;
								8'd150: next_state = DEGREE_150;
								default: next_state = DRAW_BACKGROUND;
								end
							endcase
							
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
        
        enable_c = 1'b0;
		  resetn_c = 1'b1;
		  load_x = 1'b0;
		  load_y = 1'b0;
		  load_color=1'b0;
		  
		  enable_x_adder = 1'b0;
		  enable_y_adder = 1'b0;
		  writeEn = 1'b0;
		  draw_background =1'b0;
		  enable_gold = 1'b0;
		  enable_stone = 1'b0;
		  resetn_gold_stone = 1'b1;
		  load_stone = 1'b0;


        case (current_state)
				DRAW_BACKGROUND: begin
					draw_background = 1'b1;
					enable_x_adder = 1'b1;
					enable_y_adder = 1'b1;
					writeEn = 1'b1;
				end
            GENERATE_X: begin
					load_x = 1'b1; //load x
					end
            GENERATE_Y: begin
					load_y = 1'b1; //load y
					end
            DRAW_GOLD: begin
					enable_c = 1'b1;
					enable_x_adder = 1'b1;
					enable_y_adder = 1'b1;
					load_color = 1'b1;
					end
				DRAW_GOLD_WAIT:begin
					writeEn = 1'b1;
					end
				DRAW_GOLD_DONE: begin
					enable_gold = 1'b1;
					resetn_c = 1'b0;
					end
				DRAW_STONE: begin
					enable_c = 1'b1;
					enable_x_adder = 1'b1;
					enable_y_adder = 1'b1;
					load_stone = 1'b1;
					load_color = 1'b1;
					end
				DRAW_STONE_WAIT:begin
					writeEn = 1'b1;
					end	
				DRAW_STONE_DONE: begin
					resetn_c = 1'b0;
					enable_stone = 1'b1;
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


