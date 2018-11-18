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
    input [1023: 0] itemp_map,
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
    assign rope_len = length[17:8];
    
    reg [3:0] current_state, next_state;
    
    localparam 
        S_CCW   =

    always @(posedge clock) begin

    end 
 endmodule // RopeController
