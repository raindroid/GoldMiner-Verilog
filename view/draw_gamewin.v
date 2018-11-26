//this module dispaly the next level icon when the goal is reached
// input:
//     clk, 
// 	resetn,
// 	enable_draw_game_win,
// 	resetn_gold_stone_game_win,
//  level_up
// output:
// 	X_out_game_win,
//     Y_out_game_win,
//     Color_out_game_win,
//     writeEn_game_win,
//     draw_game_win_done
// Designed by Yifan Cui

module draw_game_win(
    clk, 
	resetn,
	enable_draw_game_win,
	resetn_gold_stone_game_win,
	

	X_out_game_win,
    Y_out_game_win,
    Color_out_game_win,
    writeEn_game_win,
    draw_game_win_done
);
    input clk,resetn, enable_draw_game_win, resetn_gold_stone_game_win;
    localparam x_init = 160-32;
    localparam y_init = 120-32;

    output reg [8:0]X_out_game_win;
    output reg [7:0]Y_out_game_win;
    output reg [11:0]Color_out_game_win;
    output reg writeEn_game_win;
    output reg draw_game_win_done;

   

    reg [12:0]game_win_pixel_cout;
    wire [11:0] game_win_mem_address = ({game_win_pixel_cout[11:6], 6'd0} + {game_win_pixel_cout[5:0]+1'b1});
	reg  enable_c_game_win,
		  load_x_game_win,
		  load_y_game_win,
		  enable_x_adder_game_win,
		  enable_y_adder_game_win,
		  resetn_c_game_win;

	reg [8:0] x;
	reg [7:0] y;
	
	wire [11:0] game_win_color;
	
	//get game_win color
	game_win d0(
	.address(game_win_mem_address),
	.clock(clk),
	.q(game_win_color));
	
	//color register
	always@(posedge clk)begin
		if(!resetn)	Color_out_game_win = 12'b0;
		else Color_out_game_win <= game_win_color;
	end
	
	
	

	//x_out adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_game_win <= 9'b0;
		else
			if(enable_x_adder_game_win) begin
				X_out_game_win <= x_init + game_win_pixel_cout[5:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_game_win <= 8'b0;
		else
			if(enable_y_adder_game_win)begin
				Y_out_game_win <= y_init + game_win_pixel_cout[11:6];
				end
	end
	

	
	//13-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c_game_win == 0)) game_win_pixel_cout <= 13'b0;
		else
			if(enable_c_game_win)
			game_win_pixel_cout <= game_win_pixel_cout + 1'b1;
	end
	

    reg [2:0] current_state, next_state; 

    localparam  LOAD_X_AND_Y        = 3'd0,
                LOAD_X_AND_Y_WAIT   = 3'd1,
				DRAW                = 3'd2,
				DRAW_WAIT			= 3'd3,
				DRAW_DONE           = 3'd4;

                
					 
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                LOAD_X_AND_Y:begin
						next_state = enable_draw_game_win ? LOAD_X_AND_Y_WAIT : LOAD_X_AND_Y;
						end // Loop in current state until value is input
                LOAD_X_AND_Y_WAIT:begin
						next_state = DRAW; // Loop in current state until go signal goes low
						end
					 DRAW: begin
						next_state =  (game_win_pixel_cout == 13'd4096) ?  DRAW_DONE : DRAW_WAIT;
						end
					 DRAW_WAIT: begin
						next_state = DRAW;
						end
					 DRAW_DONE: begin
						next_state =  LOAD_X_AND_Y;
					 end
 
            default:     next_state = LOAD_X_AND_Y;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        
		  enable_c_game_win = 1'b0;
		  load_x_game_win = 1'b0;
		  load_y_game_win = 1'b0;
		  enable_x_adder_game_win = 1'b0; 
		  enable_y_adder_game_win = 1'b0;
		  resetn_c_game_win = 1'b1;
		  writeEn_game_win = 1'b0;
		  draw_game_win_done = 1'b0;
		  


        case (current_state)
            LOAD_X_AND_Y: begin
					load_x_game_win = 1'b1; //load x
					load_y_game_win = 1'b1;
					end
            DRAW: begin
					enable_c_game_win = 1'b1;
					enable_x_adder_game_win = 1'b1;
					enable_y_adder_game_win = 1'b1;
					end
			DRAW_WAIT:begin
					writeEn_game_win = 1'b1;
					end
			DRAW_DONE: begin
					draw_game_win_done = 1'b1;
					resetn_c_game_win = 1'b0;
					end
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals

    //state changes
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= LOAD_X_AND_Y;
			end
        else
            current_state <= next_state;
    end
endmodule // draw_hook