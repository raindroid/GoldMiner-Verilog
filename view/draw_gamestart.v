module draw_gamestart(
    clk, 
	resetn,
	enable_draw_gamestart,
	resetn_gold_stone_gamestart,

	X_out_gamestart,
    Y_out_gamestart,
    Color_out_gamestart,
    writeEn_gamestart,
    draw_gamestart_done,
);
    input clk,resetn, enable_draw_gamestart, resetn_gold_stone_gamestart;
    localparam x_init = 160-64;
    localparam y_init = 120-64;

    output reg [8:0]X_out_gamestart;
    output reg [7:0]Y_out_gamestart;
    output reg [11:0]Color_out_gamestart;
    output reg writeEn_gamestart;
    output reg draw_gamestart_done;

   

    reg [14:0]gamestart_pixel_cout;
    wire [13:0] gamestart_mem_address = ({gamestart_pixel_cout[13:7], 7'd0} + {gamestart_pixel_cout[6:0]+1'b1});
	reg  enable_c_gamestart,
		  load_x_gamestart,
		  load_y_gamestart,
		  enable_x_adder_gamestart,
		  enable_y_adder_gamestart,
		  enable_gamestart_count,
		  resetn_c_gamestart;

	reg [8:0] x;
	reg [7:0] y;
	
	wire [11:0] gamestart_color;
	
	//get gamestart color
	gamestart d0(
	.address(gamestart_mem_address),
	.clock(clk),
	.q(gamestart_color));
	
	//color register
	always@(posedge clk)begin
		if(!resetn)	Color_out_gamestart = 12'b0;
		else Color_out_gamestart <= gamestart_color;
	end
	
	
	

	//x_out adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_gamestart <= 9'b0;
		else
			if(enable_x_adder_gamestart) begin
				X_out_gamestart <= x_init + gamestart_pixel_cout[6:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_gamestart <= 8'b0;
		else
			if(enable_y_adder_gamestart)begin
				Y_out_gamestart <= y_init + gamestart_pixel_cout[13:7];
				end
	end
	

	
	//14-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c_gamestart == 0)) gamestart_pixel_cout <= 15'b0;
		else
			if(enable_c_gamestart)
			gamestart_pixel_cout <= gamestart_pixel_cout + 1'b1;
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
						next_state = enable_draw_gamestart ? LOAD_X_AND_Y_WAIT : LOAD_X_AND_Y;
						end // Loop in current state until value is input
                LOAD_X_AND_Y_WAIT:begin
						next_state = DRAW; // Loop in current state until go signal goes low
						end
					 DRAW: begin
						next_state =  (gamestart_pixel_cout == 15'd16384) ?  DRAW_DONE : DRAW_WAIT;
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
        
		  enable_c_gamestart = 1'b0;
		  load_x_gamestart = 1'b0;
		  load_y_gamestart = 1'b0;
		  enable_x_adder_gamestart = 1'b0; 
		  enable_y_adder_gamestart = 1'b0;
		  enable_gamestart_count = 1'b0;
		  resetn_c_gamestart = 1'b1;
		  writeEn_gamestart = 1'b0;
		  draw_gamestart_done = 1'b0;
		  


        case (current_state)
            LOAD_X_AND_Y: begin
					load_x_gamestart = 1'b1; //load x
					load_y_gamestart = 1'b1;
					end
            DRAW: begin
					enable_c_gamestart = 1'b1;
					enable_x_adder_gamestart = 1'b1;
					enable_y_adder_gamestart = 1'b1;
					end
				DRAW_WAIT:begin
					writeEn_gamestart = 1'b1;
					end
				DRAW_DONE: begin
					enable_gamestart_count = 1'b1;
					draw_gamestart_done = 1'b1;
					resetn_c_gamestart = 1'b0;
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