//this document include fsm to draw a gold/stone, related datapath can be found in draw_gold_stone_background_datapath.v


//designed by Yifan Cui


module draw_gold_FSM(
	clk, 
	resetn,
	enable_draw_gold,

	gold_pixel_cout,
	enable_c_gold,
	load_x_gold,
	load_y_gold,
	enable_x_adder_gold, 
	enable_y_adder_gold,
	enable_gold_count,
	resetn_c_gold,
	writeEn_gold,
	draw_gold_done

	);
	
	input clk;
	input resetn;
	input enable_draw_gold;


	input [8:0]gold_pixel_cout;

	output reg enable_c_gold,
				  load_x_gold,
				  load_y_gold,
				  enable_x_adder_gold, 
				  enable_y_adder_gold,
				  resetn_c_gold,
				  enable_gold_count,
				  writeEn_gold,
				  draw_gold_done;
	
	reg [2:0] current_state, next_state; 
    
   localparam   LOAD_X_AND_Y        = 3'd0,
                LOAD_X_AND_Y_WAIT   = 3'd1,
					 DRAW                = 3'd2,
					 DRAW_WAIT			   = 3'd3,
					 DRAW_DONE           = 3'd4;

                
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                LOAD_X_AND_Y:begin
						next_state = enable_draw_gold ? LOAD_X_AND_Y_WAIT : LOAD_X_AND_Y;
						end // Loop in current state until value is input
                LOAD_X_AND_Y_WAIT:begin
						next_state = DRAW; // Loop in current state until go signal goes low
						end
					 DRAW: begin
						next_state =  (gold_pixel_cout == 9'd256) ?  DRAW_DONE : DRAW_WAIT;
						end
					 DRAW_WAIT: begin
						next_state = DRAW;
						end
					 DRAW_DONE: begin
						next_state = LOAD_X_AND_Y;
					 end
 
            default:     next_state = LOAD_X_AND_Y;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        
		  enable_c_gold = 1'b0;
		  load_x_gold = 1'b0;
		  load_y_gold = 1'b0;
		  enable_x_adder_gold = 1'b0; 
		  enable_y_adder_gold = 1'b0;
		  enable_gold_count = 1'b0;
		  resetn_c_gold = 1'b1;
		  writeEn_gold = 1'b0;
		  draw_gold_done = 1'b0;
		  


        case (current_state)
            LOAD_X_AND_Y: begin
					load_x_gold = 1'b1; //load x
					load_y_gold = 1'b1;
					end
            DRAW: begin
					enable_c_gold = 1'b1;
					enable_x_adder_gold = 1'b1;
					enable_y_adder_gold = 1'b1;
					end
				DRAW_WAIT:begin
					writeEn_gold = 1'b1;
					end
				DRAW_DONE: begin
					enable_gold_count = 1'b1;
					draw_gold_done = 1'b1;
					resetn_c_gold = 1'b0;
					end
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn == 0)
            current_state <= LOAD_X_AND_Y;
        else
            current_state <= next_state;
    end // state_FFS

endmodule


module draw_stone_FSM(
	clk, 
	resetn,
	enable_draw_stone,

	stone_pixel_cout,
	enable_c_stone,
	load_x_stone,
	load_y_stone,
	enable_x_adder_stone, 
	enable_y_adder_stone,
	enable_stone_count,
	resetn_c_stone,
	writeEn_stone,
	draw_stone_done

	);
	
	input clk;
	input resetn;
	input enable_draw_stone;


	input [8:0]stone_pixel_cout;

	output reg enable_c_stone,
				  load_x_stone,
				  load_y_stone,
				  enable_x_adder_stone, 
				  enable_y_adder_stone,
				  resetn_c_stone,
				  enable_stone_count,
				  writeEn_stone,
				  draw_stone_done;
	
	reg [2:0] current_state, next_state; 
    
   localparam   LOAD_X_AND_Y        = 3'd0,
                LOAD_X_AND_Y_WAIT   = 3'd1,
					 DRAW                = 3'd2,
					 DRAW_WAIT			   = 3'd3,
					 DRAW_DONE           = 3'd4;

                
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                LOAD_X_AND_Y:begin
						next_state = enable_draw_stone ? LOAD_X_AND_Y_WAIT : LOAD_X_AND_Y;
						end // Loop in current state until value is input
                LOAD_X_AND_Y_WAIT:begin
						next_state = DRAW; // Loop in current state until go signal goes low
						end
					 DRAW: begin
					   next_state = (stone_pixel_cout == 9'd256) ?  DRAW_DONE : DRAW_WAIT;
						end
					 DRAW_WAIT: begin
						next_state = DRAW;
						end
					 DRAW_DONE: begin
						next_state = LOAD_X_AND_Y;
					 end
 
            default:     next_state = LOAD_X_AND_Y;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        
		  enable_c_stone = 1'b0;
		  load_x_stone = 1'b0;
		  load_y_stone = 1'b0;
		  enable_x_adder_stone = 1'b0; 
		  enable_y_adder_stone = 1'b0;
		  enable_stone_count = 1'b0;
		  resetn_c_stone = 1'b1;
		  writeEn_stone = 1'b0;
		  draw_stone_done = 1'b0;
		  


        case (current_state)
            LOAD_X_AND_Y: begin
					load_x_stone = 1'b1; //load x
					load_y_stone = 1'b1;
					end
            DRAW: begin
					enable_c_stone = 1'b1;
					enable_x_adder_stone = 1'b1;
					enable_y_adder_stone = 1'b1;
					end
				DRAW_WAIT:begin
					writeEn_stone = 1'b1;
					end
				DRAW_DONE: begin
					enable_stone_count = 1'b1;
					draw_stone_done = 1'b1;
					resetn_c_stone = 1'b0;
					end
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn == 0)
            current_state <= LOAD_X_AND_Y;
        else
            current_state <= next_state;
    end // state_FFS
	
	
	
endmodule


module draw_background_FSM(
	clk, 
	resetn,
	enable_draw_background,
	
	background_cout,
	
	enable_x_adder_background, 
	enable_y_adder_background,
	enable_c_stone_background,
	writeEn_background,
	draw_background_done

	);
	
	input clk;
	input resetn;
	input enable_draw_background ;
	
	input [16:0]background_cout;


	output reg enable_x_adder_background,
				  enable_y_adder_background,
				  writeEn_background,
				  draw_background_done,
				  enable_c_stone_background;
	
	reg [1:0] current_state, next_state; 
    
   localparam   DRAW_BACKGROUND      = 2'd0,
					 DRAW_BACKGROUND_WAIT = 2'd1,
					 DRAW_BACKGROUND_DONE = 2'd2;

                
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                DRAW_BACKGROUND: begin
						next_state = (enable_draw_background) ? DRAW_BACKGROUND_WAIT : DRAW_BACKGROUND; 
						end // Loop in current state until value is input
                DRAW_BACKGROUND_WAIT:begin
						next_state = (background_cout == 17'b1_1110_0001_0100_0000) ? DRAW_BACKGROUND_DONE : DRAW_BACKGROUND;
						end
					 DRAW_BACKGROUND_DONE: begin
						next_state = DRAW_BACKGROUND;
					 end
 
            default:     next_state = DRAW_BACKGROUND;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        
		  enable_x_adder_background = 1'b0;
		  enable_y_adder_background = 1'b0;
		  writeEn_background = 1'b0;
		  draw_background_done = 1'b0;
		  enable_c_stone_background = 1'b0;


        case (current_state)
            DRAW_BACKGROUND: begin
					enable_x_adder_background = 1'b1;
					enable_y_adder_background = 1'b1;
					enable_c_stone_background = 1'b1;
					end
            DRAW_BACKGROUND_WAIT: begin
					writeEn_background = 1'b1;
					end
				DRAW_BACKGROUND_DONE: begin
					draw_background_done = 1'b1;
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

