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
    input [9:0] length,
    input [8:0] degree,
    

    output reg [8:0] outX,
    output reg [7:0] outY,
    output [11:0] color,
    output reg writeEn,
    output reg done,
    output reg [9:0] LEDR
);

    reg [63:0] centerX, centerY;
    reg [4:0] current_state, next_state;
    reg [63:0] degree_counter, length_counter;

    // wire [63: 0] xRad = degree_counter * 64'd314 / 64'd1800;
    reg [63: 0] tempX, tempY;
    reg [63: 0] midX, interX;
    wire [8: 0] cos, sin;
    wire signCos, signSin;

    assign color = 12'b1011_1011_1011;
    
    localparam  S_START     =5'd0,  //Wait for enable signal
                S_DRAW      =5'd1,  //Prepare for drawing
                S_DRAW_ROPE =5'd5,  //Draw rope
                S_DRAW_HOOK =5'd2,  //Draw hook
                S_DRAW_DONE =5'd3;  //Finish and send done sig

    localparam RADIUS = 64'd4;
    localparam MAX_C = 64'd256;
    localparam START_X = 64'd160,
                START_Y = 64'd45;
    reg [63:0]rope_len;

    trig counter_trig(
        .degree(degree_counter),
        .cos(cos),
        .sin(sin),
        .signCos(signCos),
        .signSin(signSin)
    );

    wire [8:0] deg_sin, deg_cos;
    wire deg_signSin, deg_signCos;
    trig degree_trig(
        .degree(degree + 20),
        .cos(deg_cos),
        .sin(deg_sin),
        .signCos(deg_signCos),
        .signSin(deg_signSin)
    );


    always @(*) begin
        case (current_state)
            S_START:        next_state = (enable) ? S_DRAW : S_START;
            S_DRAW:         next_state = S_DRAW_ROPE;
            S_DRAW_ROPE:    next_state = (length_counter == MAX_C) ?
                                        S_DRAW_HOOK : S_DRAW_ROPE;
            S_DRAW_HOOK:    next_state = (degree_counter == 64'd360) ?
                                        S_DRAW_DONE : S_DRAW_HOOK;
            S_DRAW_DONE:    next_state = S_START;
          default: next_state = S_START;
        endcase      
    end

    reg [63:0] longX, longY;

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
//                writeEn = 0;
                degree_counter <= 64'd0;
                length_counter <= 64'd0;
                
                centerX = START_X + ((length * deg_cos) >> 8) * (deg_signCos ? 64'd1 : -64'd1);
                centerY = START_Y + ((length * deg_sin) >> 8);
                LEDR = 9'b0;
            end
            S_DRAW_ROPE: begin
                LEDR[3] = 1'b1;

                rope_len = length;

                
                 tempX = (centerX - START_X) * length_counter >> 8;
                 longX = START_X + tempX;
                 outX = longX [8:0];

                 
                 tempY = (centerY - START_Y) * length_counter >> 8;
                 longY = START_Y + tempY;
                 outY = longY [7:0];

                 writeEn = 1'b1;

                length_counter <= length_counter + 1;
            end
            S_DRAW_HOOK: begin
                LEDR[2] = 1'b1;
                
                 tempX = (RADIUS * cos[8:0]) >> 8;
                 outX = centerX[8:0] + tempX[8:0] * (signCos ? 64'd1 : -64'd1);
                   
                 tempY = (RADIUS * sin[8:0]) >> 8;
                 outY = centerY[7:0] + (signSin ? tempY[7:0] : -tempY[7:0]);

                if (degree_counter < degree | degree_counter > (degree + 40))
                    writeEn = 1'b1;
                else    
                    writeEn = 1'b0;

                degree_counter <= degree_counter + 4;
            end
            S_DRAW_DONE: begin
                LEDR[3] = 1'b0;
                done = 1'b1;
            end
        endcase
    end

    //state changes
    always @(posedge clock) begin
        if (!resetn) begin
            current_state <= S_START;
			end
        else
            current_state <= next_state;
    end
endmodule // draw_hook
