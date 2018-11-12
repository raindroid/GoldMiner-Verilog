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
	load_stone,
	
	game_end,
	
	
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
	);
	
	input clk;
	input plot;
	input resetn;
	input background;
	input go;

	input [8:0]cout;
	input [16:0]background_cout;
	input [2:0]gold_cout;
	input [2:0]stone_cout;
	
	input game_end;
	
	parameter max_stone = 3'd5;
	parameter max_gold  = 3'd5;
	
	
	output reg enable_c, resetn_c, load_x, load_y, load_color, enable_x_adder, enable_y_adder, writeEn, draw_background;
	output reg enable_gold, enable_stone, resetn_gold_stone,load_stone;
	
	
	reg [3:0] current_state, next_state; 
    
   localparam   
	
					 DRAW_BACKGROUND      = 4'd0,
					 DRAW_BACKGROUND_WAIT = 4'd1,
					 GENERATE_X        	 = 4'd2,
					 GENERATE_Y           = 4'd3,
					 RANDOM_WAIT			 = 4'd4,
					 DRAW_GOLD            = 4'd5,
					 DRAW_GOLD_WAIT		 = 4'd6,
					 DRAW_GOLD_DONE		 = 4'd7,
					 DRAW_STONE 			 = 4'd8,
					 DRAW_STONE_WAIT		 = 4'd9,
					 DRAW_STONE_DONE		 = 4'd10,
					 GAME						 = 4'd11,
					 
					 GAME_DONE				 = 4'd12;
					 

                
					 
    
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