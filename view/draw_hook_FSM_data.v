/** This FSM draws hook with a given degreen and signal
 * 
 * INPUT:
 *      clock
 *      resetn
 *      degree
 *      centerX
 *      centerY
 *      enable
 *
 * OUTPUT:
 *      outX
 *      outY
 *      color
 *      done
 *
 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 13th. 2018
 * Last Updated Nov 13th, 2018: created
 **/

module draw_hook(
    input clock, resetn, enable,
    input [8:0] centerX,
    input [9:0] centerY,
    input [8:0] degree,
    

    output reg [8:0] outX,
    output reg [7:0] outY,
    output [11:0] color,
    output reg writeEn,
    output reg done
);

    reg [4:0] current_state, next_state;
    reg [8:0] degree_counter;

    assign color = 12'h5f5f5f;
    
    localparam  S_START     =5'd0,  //Wait for enable signal
                S_DRAW      =5'd1,  //Prepare for drawing
                S_DRAW_WAIT =5'd2,  //Drawing
                S_DRAW_DONE =5'd3;  //Finish and send done sig

    localparam RADIUS = 6'd18;

    always @(*) begin
        case (current_state)
            S_START:        next_state = (enable) ? S_DRAW : S_START;
            S_DRAW:         next_state = S_DRAW_WAIT;
            S_DRAW_WAIT:    next_state = (degree_counter == 10'd360) ?
                                        S_DRAW_DONE : S_DRAW_WAIT;
            S_DRAW_DONE:    next_state = S_START;
          default: next_state = S_START;
        endcase      
    end

    reg [15: 0] xRad;
    reg [31: 0] temp;

    //Logic
    always @(posedge clock) begin
        writeEn = 1'b0;
        outX = centerX;
        outY = centerY;
        done = 1'b0;
        case (current_state)
            S_START: begin
                //pass
            end
            S_DRAW: begin
                writeEn = 1;
                degree_counter <= 0;
            end
            S_DRAW_WAIT: begin
                xRad <= degree_counter * 314 / 1800;
                
                temp <= 10000 - 100 * (xRad * xRad) / 2 + xRad*xRad*xRad*xRad / (1*2*3*4);
                outX <= centerX + temp / 10000;
                
                temp <= 10000 * xRad - 100 * xRad*xRad*xRad / 6 + xRad*xRad*xRad*xRad*xRad / 120;
                outY <= centerY + temp / 100000;

                if (degree_counter < degree + 30 | degree_counter > degree)
                    writeEn = 1'b1;
                else    
                    writeEn = 1'b0;

                degree_counter <= degree_counter + 2;
            end
            S_DRAW_DONE: begin
                done = 1'b1;
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
endmodule // draw_hook
