module FSM(
	clk, 
	plot, 
	resetn,
	black,
	go,
	
	cout,
	black_cout,
	
	enable_c,
	resetn_c,
	load_x,
	load_y,
	load_color,
	enable_x_adder,
	enable_y_adder,
	writeEn,
	draw_black
	);
	
	input clk;
	input plot;
	input resetn;
	input black;
	input go;

	input [8:0]cout;
	input [14:0]black_cout;
	
	output reg enable_c, resetn_c, load_x, load_y, load_color, enable_x_adder, enable_y_adder, writeEn, draw_black;
	
	reg [2:0] current_state, next_state; 
    
   localparam   LOAD_X          = 3'd0,
                LOAD_X_WAIT     = 3'd1,
                LOAD_Y_AND_COLOR= 3'd2,
                WAIT            = 3'd3,
					 DRAW            = 3'd4,
					 WAIT2			  = 3'd5,
					 OUT             = 3'd6,
					 BLACK           = 3'd7;
                
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                LOAD_X:begin
						if(black) next_state = BLACK;
						else
						next_state = go ? LOAD_X_WAIT : LOAD_X;
						end // Loop in current state until value is input
                LOAD_X_WAIT:begin
						if(black) next_state = BLACK;
						else
						next_state = go ? LOAD_X_WAIT : LOAD_Y_AND_COLOR; // Loop in current state until go signal goes low
						end
					 LOAD_Y_AND_COLOR: begin
					   if(black) next_state = BLACK;
						else
						next_state = plot ? WAIT : LOAD_Y_AND_COLOR;
						end
					 WAIT: begin
						if(black) next_state = BLACK;
						else
						next_state = plot ? WAIT : DRAW;
						end
					 DRAW: begin
					 if(black) next_state = BLACK;
						else
							next_state = (cout == 9'd256) ? OUT : WAIT2;
						end
					 WAIT2: begin
					 if(black) next_state = BLACK;
						else
						next_state = DRAW;
					 end
					 OUT: begin
					 if(black) next_state = BLACK;
						else
						next_state = LOAD_X;
					 end
					 BLACK: next_state = (black_cout == 15'b11111111111111) ? OUT : BLACK;
					 
					 
            default:     next_state = LOAD_X;
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
		  load_color = 1'b0;
		  enable_x_adder = 1'b0;
		  enable_y_adder = 1'b0;
		  writeEn = 1'b0;
		  draw_black =1'b0;


        case (current_state)
            LOAD_X: begin
					load_x = 1'b1; //load x
					end
            LOAD_Y_AND_COLOR: begin
					load_y = 1'b1; //load y
					load_color = 1'b1; //load color
					end
            DRAW: begin
					enable_c = 1'b1;
					enable_x_adder = 1'b1;
					enable_y_adder = 1'b1;
					end
				WAIT2:begin
					writeEn = 1'b1;
					end
				OUT: begin
					resetn_c = 1'b0;
					end
				BLACK: begin
					draw_black = 1'b1;
					enable_x_adder = 1'b1;
					enable_y_adder = 1'b1;
					writeEn = 1'b1;
				end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn == 0)
            current_state <= LOAD_X;
        else
            current_state <= next_state;
    end // state_FFS
	
	
	
endmodule