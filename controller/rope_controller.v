/**
 * THis is the module for rope movement
 * Including functions:
 *      read input signals up_KEY, down_KEY
 *      interprate the rope's next action based on input and current state

 * INPUT:
 *      clock
 *      resetn: syn low active reset, reset location to original point
 *      enable: make sure the rope won't move before the real game started
 *      item_lists_DATA
 *
 * PARAMETER:
 *      MODE: mode
 *      PLAYER: 1 or 2
 *      mode0 - origin (160, 45)
 *      mode1 & player1(0) - origin (77, 45)
 *      mode1 & player2(1) - origin (237, 45)
 *
 * OUTPUT:
 *      rotation_speed:
 *      line_speed:
 *      endX, endY, rope_len, degree : DATA

 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 17, 2018
 * Last Updated: Nov 17, 2018, just started
 * Tested: init
 **/
 module TestTop(
     input clock, resetn,
     
 );
 
 endmodule // TestTop

 module RopeController(
    input clock, resetn, enable,
    input [1023: 0] item_map,
    input go_KEY, bomb_KEY,
    input bomb_quantity,

    output reg[9:0] rotation_speed, line_speed, endX, endY, degree,
    output [9:0]rope_len,
    output bomb_use

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
    reg rCW;
    reg [17: 0] length;
    assign rope_len = length[17:8];  //magnify by << 8
    reg [9:0] deg_p;
    assign degree = (der_p / 5) * 5;
    
    reg [3:0] current_state, next_state;

    parameter FRAME_CLOCK = 833_333;

    wire go, fire;
    key_detector go_DET(
        .clock(clock), 
        .resetn(resetn),
        .key(go_KEY),
        .pulse(go)
    );
    defparam PULSE_LENGTH = FRAME_CLOCK;
    key_detector bomb_DET(
        .clock(clock),
        .resetn(resetn),
        .key(bomb_KEY),
        .pulse(fire)
    );
    defparam PULSE_LENGTH = FRAME_CLOCK;
    
    localparam 
        S_CCW   = 4'd0,
        S_PRE_CCW   = 4'd6,
        S_CW    = 4'd1,
        S_PRE_CW    = 4'd7,
        S_UP    = 4'd2,
        S_PRE_UP    = 4'd8,
        S_DOWN  = 4'd3,
        S_PRE_DOWN  = 4'd9,
        S_STOP  = 4'd5;

    reg [22:0] frame_counter;
    integer index;
    reg find_stone;
    wire [13:0] tempX, tempY;

    wire [8:0] deg_sin, deg_cos;
    wire deg_signSin, deg_signCos;
    trig degree_trig(
        .degree(degree),
        .cos(deg_cos),
        .sin(deg_sin),
        .signCos(deg_signCos),
        .signSin(deg_signSin)
    );

    always @(posedge clock) begin //State_table
        if (!resetn | !enable) begin
            current_state = S_STOP;
        end
        endX = originX + length * deg_cos / 64'd100 * (deg_signCos ? 64'd1 : -64'd1);
        endY = originY + length * deg_sin / 64'd100;
        case (current_state)
            S_STOP: begin
                next_state = S_CCW;
            end
            S_PRE_CCW: begin
                if (frame_counter == FRAME_CLOCK)
                    next_state = S_CCW;
                else
                    next_state = S_PRE_CCW;
            end
            S_CCW: begin
                if (go)
                    next_state = S_PRE_DOWN;
                else if (degree <= 15)
                    next_state = S_PRE_CW;
                else
                    next_state = S_PRE_CCW;
            end
            S_PRE_CW: begin
                if (frame_counter == FRAME_CLOCK)
                    next_state = S_CW;
                else
                    next_state = S_PRE_CW;
            end
            S_CW: begin
                if (go)
                    next_state = S_PRE_DOWN;
                else if (degree >= 165)
                    next_state = S_PRE_CCW;
                else
                    next_state = S_PRE_CW;              
            end
            S_PRE_UP: begin
                if (frame_counter == FRAME_CLOCK)
                    next_state = S_UP;
                else
                    next_state = S_PRE_UP;
            end
            S_UP: begin
                if (rope_len <= 10) begin
                    if (rCW) 
                        next_state = S_PRE_CW;
                    else
                        next_state = S_PRE_CCW;
                end
                else 
                    next_state = S_PRE_UP;      
            end
            S_DOWN: begin
                if (frame_counter == FRAME_CLOCK)
                    next_state = S_DOWN;
                else
                    next_state = S_PRE_DOWN;
            end
            S_DOWN: begin
                //stone detect
                find_stone <= 0;
                for (index = 0; i <= 31; i=i+1) begin
                    if (item_map[index * 32 + 1] && !item_map[index * 32]) begin
                        tempX = (item_map[index * 32 + 31] << 8) + 
                                (item_map[index * 32 + 30] << 7) + 
                                (item_map[index * 32 + 29] << 6) + 
                                (item_map[index * 32 + 28] << 5) + 
                                (item_map[index * 32 + 27] << 4) + 
                                (item_map[index * 32 + 26] << 3) + 
                                (item_map[index * 32 + 25] << 2) + 
                                (item_map[index * 32 + 24] << 1) + 
                                (item_map[index * 32 + 23] << 0);
                        tempY = (item_map[index * 32 + 18] << 7) + 
                                (item_map[index * 32 + 17] << 6) + 
                                (item_map[index * 32 + 16] << 5) + 
                                (item_map[index * 32 + 15] << 4) + 
                                (item_map[index * 32 + 14] << 3) + 
                                (item_map[index * 32 + 13] << 2) + 
                                (item_map[index * 32 + 12] << 1) + 
                                (item_map[index * 32 + 11] << 0);
                        if ((tempX <= endX) & (endX <= tempX + 16) &
                            (tempY <= endY) & (endY <= tempY + 16))
                            find_stone = 1;
                            //TODO use stored info about stone types
                    end
                end
                if (find_stone | boom)
                    next_state = S_PRE_UP;
                else 
                    next_state = S_PRE_DOWN;              
            end 
          default: next_state = S_STOP;
        endcase
    end 

    always @(posedge clock) begin
        if (!resetn) begin

        end      
    end
 endmodule // RopeController
