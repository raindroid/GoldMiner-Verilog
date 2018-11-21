module draw_gameover(
    clk, 
	resetn,
	enable_draw_gameover,
	resetn_gold_stone_gameover,

	X_out_gameover,
    Y_out_gameover,
    Color_out_gameover,
    writeEn_gameover,
    draw_gameover_done,
);
    input clk,resetn, enable_draw_gameover, resetn_gold_stone_gameover;
    localparam x_init = 160-32;
    localparam y_init = 120-32;

    output reg [8:0]X_out_gameover;
    output reg [7:0]Y_out_gameover;
    output reg [11:0]Color_out_gameover;
    output reg writeEn_gameover;
    output reg draw_gameover_done;

   

    reg [11:0]gameover_pixel_cout;
    wire [11:0] gameover_mem_address = ({gameover_pixel_cout[11:6], 6'd0} + {gameover_pixel_cout[5:0]+1'b1});
	reg  enable_c_gameover,
		  load_x_gameover,
		  load_y_gameover,
		  enable_x_adder_gameover,
		  enable_y_adder_gameover,
		  enable_gameover_count,
		  resetn_c_gameover;

	reg [8:0] x;
	reg [7:0] y;
	
	wire [11:0] gameover_color;
	
	//get gameover color
	gameover d0(
	.address(gameover_mem_address),
	.clock(clk),
	.q(gameover_color));
	
	//color register
	always@(posedge clk)begin
		if(!resetn)	Color_out_gameover = 12'b0;
		else Color_out_gameover <= gameover_color;
	end
	
	
	

	//x_out adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_gameover <= 9'b0;
		else
			if(enable_x_adder_gameover) begin
				X_out_gameover <= x_init + gameover_pixel_cout[5:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_gameover <= 8'b0;
		else
			if(enable_y_adder_gameover)begin
				Y_out_gameover <= y_init + gameover_pixel_cout[11:6];
				end
	end
	

	
	//13-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c_gameover == 0)) gameover_pixel_cout <= 13'b0;
		else
			if(enable_c_gameover)
			gameover_pixel_cout <= gameover_pixel_cout + 1'b1;
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
						next_state = enable_draw_gameover ? LOAD_X_AND_Y_WAIT : LOAD_X_AND_Y;
						end // Loop in current state until value is input
                LOAD_X_AND_Y_WAIT:begin
						next_state = DRAW; // Loop in current state until go signal goes low
						end
					 DRAW: begin
						next_state =  (gameover_pixel_cout == 13'd4096) ?  DRAW_DONE : DRAW_WAIT;
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
        
		  enable_c_gameover = 1'b0;
		  load_x_gameover = 1'b0;
		  load_y_gameover = 1'b0;
		  enable_x_adder_gameover = 1'b0; 
		  enable_y_adder_gameover = 1'b0;
		  enable_gameover_count = 1'b0;
		  resetn_c_gameover = 1'b1;
		  writeEn_gameover = 1'b0;
		  draw_gameover_done = 1'b0;
		  


        case (current_state)
            LOAD_X_AND_Y: begin
					load_x_gameover = 1'b1; //load x
					load_y_gameover = 1'b1;
					end
            DRAW: begin
					enable_c_gameover = 1'b1;
					enable_x_adder_gameover = 1'b1;
					enable_y_adder_gameover = 1'b1;
					end
				DRAW_WAIT:begin
					writeEn_gameover = 1'b1;
					end
				DRAW_DONE: begin
					enable_gameover_count = 1'b1;
					draw_gameover_done = 1'b1;
					resetn_c_gameover = 1'b0;
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