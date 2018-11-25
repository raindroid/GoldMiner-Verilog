//this module draw a diamond at a given positon
//designed by Yifan Cui


module draw_diamond(
    clk, 
	resetn,
	enable_draw_diamond,
	resetn_gold_stone_diamond,

    x_init,
    y_init,

	X_out_diamond,
    Y_out_diamond,
    Color_out_diamond,
    writeEn_diamond,
    draw_diamond_done,
    diamond_count
);
    input clk,resetn, enable_draw_diamond, resetn_gold_stone_diamond;
    input [8:0]x_init;
    input [7:0]y_init;

    output reg [8:0]X_out_diamond;
    output reg [7:0]Y_out_diamond;
    output reg [11:0]Color_out_diamond;
    output reg writeEn_diamond;
    output reg draw_diamond_done;
    output reg [7:0]diamond_count;
   

    reg [6:0]diamond_pixel_cout;
    wire [5:0] diamond_mem_address = ({diamond_pixel_cout[5:3], 3'd0} + {diamond_pixel_cout[2:0]+1'b1});
	reg  enable_c_diamond,
		  load_x_diamond,
		  load_y_diamond,
		  enable_x_adder_diamond,
		  enable_y_adder_diamond,
		  enable_diamond_count,
		  resetn_c_diamond;

	reg [8:0] x;
	reg [7:0] y;
	
	wire [11:0] diamond_color;
	
	//get diamond color
	diamond d0(
	.address(diamond_mem_address),
	.clock(clk),
	.q(diamond_color));
	
	//color register
	always@(posedge clk)begin
		if(!resetn)	Color_out_diamond = 12'b0;
		else Color_out_diamond <= diamond_color;
	end
	
	
	//x register
	always@(posedge clk)begin
		if(resetn == 0) x <= 9'b0;
		else
			if(load_x_diamond) begin
			x[8:0] <= x_init;
			end
	end
	
	//y register
	always@(posedge clk)begin
		if(resetn == 0) y <= 8'b0;
		else
			if(load_y_diamond) begin
			y[7:0] <= y_init;
			
			end
	end
	

	//x_out adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_diamond <= 9'b0;
		else
			if(enable_x_adder_diamond) begin
				X_out_diamond <= x + diamond_pixel_cout[2:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_diamond <= 8'b0;
		else
			if(enable_y_adder_diamond)begin
				Y_out_diamond <= y + diamond_pixel_cout[5:3];
				end
	end
	

	
	//7-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_c_diamond == 0)) diamond_pixel_cout <= 7'b0;
		else
			if(enable_c_diamond)
			diamond_pixel_cout <= diamond_pixel_cout + 1'b1;
	end
	
		//diamond counter
	always@(posedge clk)begin
		if(!resetn | (!resetn_gold_stone_diamond)) diamond_count <= 3'b0;
		else if(enable_diamond_count)
			diamond_count <= diamond_count + 1'b1;
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
						next_state = enable_draw_diamond ? LOAD_X_AND_Y_WAIT : LOAD_X_AND_Y;
						end // Loop in current state until value is input
                LOAD_X_AND_Y_WAIT:begin
						next_state = DRAW; // Loop in current state until go signal goes low
						end
					 DRAW: begin
						next_state =  (diamond_pixel_cout == 7'd64) ?  DRAW_DONE : DRAW_WAIT;
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
        
		  enable_c_diamond = 1'b0;
		  load_x_diamond = 1'b0;
		  load_y_diamond = 1'b0;
		  enable_x_adder_diamond = 1'b0; 
		  enable_y_adder_diamond = 1'b0;
		  enable_diamond_count = 1'b0;
		  resetn_c_diamond = 1'b1;
		  writeEn_diamond = 1'b0;
		  draw_diamond_done = 1'b0;
		  


        case (current_state)
            LOAD_X_AND_Y: begin
					load_x_diamond = 1'b1; //load x
					load_y_diamond = 1'b1;
					end
            DRAW: begin
					enable_c_diamond = 1'b1;
					enable_x_adder_diamond = 1'b1;
					enable_y_adder_diamond = 1'b1;
					end
				DRAW_WAIT:begin
					writeEn_diamond = 1'b1;
					end
				DRAW_DONE: begin
					enable_diamond_count = 1'b1;
					draw_diamond_done = 1'b1;
					resetn_c_diamond = 1'b0;
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