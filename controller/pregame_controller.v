/**
 * THis is the module for controller part before the game scene
 * Including functions:
 *      send signal to MODEL to reset data
 *      request input of user naem(s)

 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      start: start command at 1
 *      cbk_for_reset: callback from RESET 1 for success, 0 for in progress
 *      cbk_for_view: callback from VIEW 1 for success, 0 for in progress
 *      cbk_for_end_confirm: this is a ending-comfirmed signal given back by VIEW, 1 for success, 0 for in progress
 *      mode: this is a gloabal variable that tells us it is a 1-player(00)/2-player-co(10)/2-player-op(11) game
                MSB indicates whether it is 1 or 2 player
 * OUTPUT:
 *      user_name_req: no username required(00), 1st user name required(10), 2nd user name required(11)
                MSB indicates whether a username is required
 *      clear_req: start clear data request
 *      

 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 12, 2018
 * Last Updated: Nov 12, 2018, just started
 * Tested: Not Yet
 **/

module test_pregame_controller(

);

endmodule // test_pregame_controller

module pregame_controller(
    input clock, resetn, cbk_for_view, cbk_for_end_confirm
    input [1:0] mode,

    output reg [1:0] user_name_req,
    output reg clear_req
);
    reg [4:0] current_state, next_state;
    reg [9:0] delay_counter;

    localparam  S_START         = 5'd0,
                S_RESET         = 5'd1,
                S_RESET_WAIT    = 5'd2,
                S_WAIT_MODE     = 5'd3,
                S_1st_DELAY     = 5'd4,
                S_REQ_1st       = 5'd5,
                S_WAIT_1st      = 5'd6,
                S_2nd_DELAY     = 5'd7,
                S_REQ_2nd       = 5'd8,
                S_WAIT_2nd      = 5'd9,
                S_END           = 5'd10,
                S_END_WAIT      = 5'd11;

    always @(*) begin
        case (current_state)
            S_START: (start) ? S_RESET : S_START;
            S_RESET: S_RESET_WAIT;
            S_RESET_WAIT: (cbk_for_reset) ? S_WAIT_MODE //Todo
          default: 
        endcase
    end

endmodule // pregame_controller