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
 *      mode1 & player1 - origin (77, 45)
 *      mode1 & player2 - origin (237, 45)
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

 module RopeController(
    input clock, resetn, enable,
    input[] stone_list_DATA, gold_list_DATA, diamond_list_DATA
 );
 
 endmodule // RopeController
