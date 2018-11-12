/**
 * THis is a simple module to transfer a physical button or key into 
 * a pulse, in order to avoid repeat recognization of inputs

 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      key: the physical button, 0 for unpressed, 1 for pressed down
 * OUTPUT:
 *      pulse: 0 when it is unpressed, 1 when pressed and last for 'PULSE_LENGTH'

 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 11, 2018
 * Last Updated: Nov 11, 2018, done simulation
 * Tested: Looks good, modelsim passed
 **/

 module test_key_detector(
     input clock, resetn,
     input KEY,
     output out
 );
    key_detector k(clock, resetn, KEY, out);
        defparam k.PULSE_LENGTH = 5; 
 endmodule // test_key_detector

 module key_detector(
     input clock, resetn,
     input key,
     output reg pulse
 );
    parameter PULSE_LENGTH = 5; //define the length of output pulse

    reg [1:0] current_state, next_state; 
    reg [25: 0] counter; //Just make sure it is big enough for at least 1 frame 
                          //(around 833_333 clock cycles)
    
//Control part

    //Define all the states
    localparam      S_LOAD_KEY      = 2'b0,
                    S_LOAD_KEY_WAIT = 2'b1;

    //State table
    always @(*) begin
        case (current_state)
            S_LOAD_KEY: next_state = (!key) ? S_LOAD_KEY : S_LOAD_KEY_WAIT;
            S_LOAD_KEY_WAIT: next_state = (counter == PULSE_LENGTH - 1) ? S_LOAD_KEY : S_LOAD_KEY_WAIT;
            default: next_state = S_LOAD_KEY;
        endcase
    end

//Datapath part

    //Counter logic
    always @(posedge clock, posedge current_state) begin 
        if (current_state == S_LOAD_KEY_WAIT) begin
            pulse = 1;
            counter <= (counter + 1) % PULSE_LENGTH;
        end else begin
            pulse = 0;
            counter = 0;
        end
    end

    always @(posedge clock) begin
        if (!resetn)
            current_state <= S_LOAD_KEY;
        else
            current_state <= next_state;
    end

 endmodule // key_detector