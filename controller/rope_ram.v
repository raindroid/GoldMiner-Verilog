/**
 *  module for rope and it's movement
 **/

module Rope(
    input clock, resetn, enable,
    input draw_stone_flag, //on when the previous drawing is in process
    input [3:0] draw_index,

    input go_KEY, //physical key for the go input
    //bomb_KEY,
    // input bomb_quantity,

    output reg[9:0] rotation_speed, line_speed, endX, endY, degree, //not all the output is useful
    output reg[9:0]rope_len,

    output [31:0] data
    // output bomb_use

 );
    PARAMETER mode = 1'b0;
    PARAMETER player = 1'b0;
    PARAMETER originX = ((!mode) ? 10'd160 : (player ? 10'd237 : 10'd77));
    PARAMETER originY = 10'd45;

    /**
     * STATE
     * 00 - rotate ccw
     * 01 - rotate cw
     * 10 - down
     * 11 - up
     **/
    reg [1:0] state; 
    reg rCW; //Is or was in cw rotation
    reg [17: 0] length; //more precise length
    assign rope_len = length[17:8];  //magnify by << 8, to get drawable length
    
    reg [4:0] current_state, next_state;

    parameter FRAME_CLOCK = 833_334; //used for frame counter

    reg [3:0] rope_index; //the index for rope to control
    reg [31:0] data_write; //used to write to the ram
    reg writeEn;
    
    wire [31:0]read_data; //data output
    assign data = read_data;
	wire [3:0]read_address;
    assign read_address = draw_stone_flag ? draw_index : rope_index;

	initialize_1 initial_1(
	.address(read_address),
	.clock(clk),
	.data(data_write),
	.wren(writeEn),
	.q(read_data));

    reg [31:0] frame_counter;
    reg found_stone;     //a flag to tell should we move a stone or not
    reg [3:0] move_index;   //possibly store the stone we need to move

    wire [8:0] deg_sin, deg_cos;
    wire deg_signSin, deg_signCos;
    trig degree_trig(
        .degree(degree),
        .cos(deg_cos),
        .sin(deg_sin),
        .signCos(deg_signCos),
        .signSin(deg_signSin)
    );

    wire go, fire; //go is the moving signal
    key_detector go_DET(
        .clock(clock), 
        .resetn(resetn),
        .key(go_KEY),
        .pulse(go)
    );
    defparam PULSE_LENGTH = FRAME_CLOCK;

    localparam  S_STOP      = 5'd0,
                S_PRE_RCCW  = 5'd1,
                S_IN_RCCW   = 5'd2,
                S_PRE_RCW   = 5'd3,
                S_IN_RCW    = 5'd4,
                S_PRE_UP    = 5'd5,
                S_IN_UP     = 5'd6,
                S_PRE_DOWN  = 5'd7,
                S_IN_DOWN   = 5'd8,
                S_MOVE      = 5'd9,
                S_UP_DELAY  = 5'd10,
                S_PRE_CHECK = 5'd11,
                S_IN_CHECK  = 5'd12,
                S_SAVE      = 5'd13;

    always @(posedge clock) begin
        //update x,y based on length and degree
        endX = originX + length * deg_cos / 64'd100 * (deg_signCos ? 64'd1 : -64'd1);
        endY = originY + length * deg_sin / 64'd100;

        writeEn = 0;
        case (current_state)
            S_STOP: begin
                state = 2'b00;
                rCW = 0;
                length = 10 << 8;
                degree = 170;
                if (enable) next_state = S_PRE_RCCW;
                else next_state = S_STOP;
                frame_counter = 0;
            end
            S_PRE_RCCW: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK & (!draw_stone_flag)) begin
                    next_state = S_IN_RCCW;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_RCCW;
                end
            end
            S_IN_RCCW: begin
                degree = degree - 1;
                if (degree <= 15)
                    next_state = S_PRE_RCW;
                else if (go)
                    next_state = S_PRE_DOWN;
                else
                    next_state = S_PRE_RCCW;
                frame_counter = 0;
            end
            S_PRE_RCW: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK & (!draw_stone_flag)) begin
                    next_state = S_IN_RCW;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_RCW;
                end
            end
            S_IN_RCW: begin
                degree = degree + 1;
                if (degree >= 165)
                    next_state = S_PRE_RCCW;
                else if (go)
                    next_state = S_PRE_DOWN;
                else
                    next_state = S_PRE_RCW;
                frame_counter = 0;
            end
            S_PRE_UP: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK & (!draw_stone_flag)) begin
                    next_state = S_IN_UP;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_UP;
                end
            end
            S_IN_UP: begin
                length = length - 1;
                if (rope_len <= 10) begin
                  //reach the top
                    if (found_stone)
                        next_state = S_MOVE;
                    else if (rCW)
                        next_state = S_PRE_RCW;
                    else
                        next_state = S_PRE_RCCW;
                end
                else 
                    next_state = S_PRE_UP;
                frame_counter = 0;
            end
            S_PRE_DOWN
          default: 
        endcase
    end

    always @(posedge clock) begin
        if (!resetn) begin
            current_state <= S_STOP;
        end            
        else begin
            current_state <= next_state;
        end
    end

endmodule // Rope