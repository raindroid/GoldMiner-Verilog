/**
 * THis is the module for controller part before the game scene
 * Including functions:
 *      send signal to MODEL to reset data
 *      request input of user naem(s)

 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      start: start command at 1
 *      cbk_from_reset: callback from RESET 1 for success, 0 for in progress
 *      cbk_from_view: callback from VIEW 1 for success, 0 for in progress
 *      cbk_from_end_confirm: this is a ending-comfirmed signal given back by VIEW, 1 for success, 0 for in progress
 *      mode: this is a gloabal variable that tells us it is a DNE(00)/1-player(01)/2-player-co(10)/2-player-op(11) game
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
 * Last Updated: Nov 12, 2018, seems work
 * Tested: Done
 **/

module test_pregame_controller(

);

endmodule // test_pregame_controller

module pregame_controller(
    input clock, resetn, 
    input start,
    input cbk_from_reset, cbk_from_view, cbk_from_end_confirm,
    input [1:0] mode,

    output reg [1:0] user_name_req,
    output reg clear_req
);
    parameter DELAY_TIME = 10'h10;
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
            S_RESET_WAIT:   next_state = (cbk_from_reset) ? S_WAIT_MODE : S_RESET_WAIT;
            S_WAIT_MODE:    next_state = (mode[0] | mode[1]) ? S_1st_DELAY : S_WAIT_MODE;
            S_1st_DELAY:    next_state = (delay_counter == DELAY_TIME) ? S_REQ_1st : S_1st_DELAY;
            S_REQ_1st:      next_state = S_WAIT_1st;
            S_WAIT_1st:     next_state = (cbk_from_view) ? S_2nd_DELAY : S_WAIT_1st;
            S_2nd_DELAY:    next_state = (delay_counter == DELAY_TIME) ? 
                                         ((mode[1]) ? S_REQ_2nd : S_END) : S_2nd_DELAY;
            S_REQ_2nd:      next_state = S_WAIT_2nd;
            S_WAIT_2nd:     next_state = (cbk_from_view) ? S_END : S_WAIT_2nd;
            S_END:          next_state = (cbk_from_end_confirm) ? S_START : S_END;
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
                //pass
            end
            S_WAIT_MODE: begin
                //prepare for delay state
                delay_counter = 0;
            end
            S_1st_DELAY: begin
                delay_counter <= delay_counter + 1;
            end
            S_REQ_1st: begin
                user_name_req = 2'b10;
            end
            S_WAIT_1st: begin
                //prepare for delay state
                delay_counter = 0;
            end
            S_2nd_DELAY: begin
                delay_counter <= delay_counter + 1;
            end
            S_REQ_2nd: begin
                user_name_req = 2'b11;
            end
            S_WAIT_2nd: begin
                //pass
            end
            S_END: begin
                user_name_req = 2'b01;
            end
        endcase
    end

    //state changes
    always @(posedge clock) begin
        if (!resetn)
            current_state <= S_START;
        else
            current_state <= next_state;
    end

endmodule // pregame_controller