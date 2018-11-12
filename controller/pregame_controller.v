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
 *      user_name_req: 
            no username required(00), end username requirement(01)
            1st user name required(10), 2nd user name required(11)
                *MSB indicates whether a username is required
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
                S_WAIT_MODE     = 5'd3, //Wait for getting mode from view
                S_1st_DELAY     = 5'd4,
                S_REQ_1st       = 5'd5,
                S_WAIT_1st      = 5'd6,
                S_2nd_DELAY     = 5'd7,
                S_REQ_2nd       = 5'd8,
                S_WAIT_2nd      = 5'd9,
                S_END           = 5'd10;
    
    localparam frame_clock = 833_333;

    //State table
    always @(*) begin
        case (current_state)
            S_START:        next_state = (start) ? S_RESET : S_START;
            S_RESET:        next_state = S_RESET_WAIT;
            S_RESET_WAIT:   next_state = (cbk_for_reset) ? S_WAIT_MODE : S_RESET_WAIT;
            S_WAIT_MODE:    next_state = (cbk_for_view) ? S_1st_DELAY : S_RESET_WAIT;
            S_1st_DELAY:    next_state = (delay_counter == 100) ? S_REQ_1st : S_1st_DELAY;
            S_REQ_1st:      next_state = S_WAIT_1st;
            S_WAIT_1st:     next_state = (cbk_for_view) ? S_2nd_DELAY : S_WAIT_1st;
            S_2nd_DELAY:    next_state = (delay_counter == 100) ? S_REQ_2st : S_2nd_DELAY;
            S_REQ_2nd:      next_state = S_WAIT_2st;
            S_WAIT_2nd:     next_state = (cbk_for_view) ? S_END : S_WAIT_2nd;
            S_END:          next_state = (cbk_for_end_confirm) ? S_START : S_END;
          default:          next_state = S_START;
        endcase
    end

    //Logic part
    always @(posedge clock) begin
        clear_req = 0;
        user_name_req = 2'b0;
        case (current_state)
            S_START: begin 
            end
            S_RESET: begin
                clear_req = 1;
            end
            S_RESET_WAIT: begin
                
            end
            S_WAIT_MODE: begin
              
            end
            S_1st_DELAY: begin
              
            end
            S_REQ_1st: begin
              
            end
            S_WAIT_1st: begin
              
            end
            S_2nd_DELAY: begin
              
            end
            S_REQ_2nd: begin
              
            end
            S_WAIT_2nd: begin
              
            end
            S_END: begin
              
            end
        endcase
    end

endmodule // pregame_controller