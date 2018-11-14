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
    input [7:0] centerY,
    input [8:0] degree,
    

    output reg [8:0] outX,
    output reg [7:0] outY,
    output [11:0] color,
    output reg writeEn,
    output reg done,
    output reg [9:0] LEDR
);

    reg [4:0] current_state, next_state;
    reg [63:0] degree_counter, length_counter;

    assign color = 12'b1011_1011_1011;
    
    localparam  S_START     =5'd0,  //Wait for enable signal
                S_DRAW      =5'd1,  //Prepare for drawing
                S_DRAW_ROPE =5'd5,  //Draw rope
                S_DRAW_HOOK =5'd2,  //Draw hook
                S_DRAW_DONE =5'd3;  //Finish and send done sig

    localparam RADIUS = 6'd4;
    localparam ROPE_START_X = 9'd160,
                ROPE_START_Y = 9'd45;

    always @(*) begin
        case (current_state)
            S_START:        next_state = (enable) ? S_DRAW : S_START;
            S_DRAW:         next_state = S_DRAW_ROPE;
            S_DRAW_ROPE:    next_state = (length_counter == 340) ?
                                        S_DRAW_HOOK : S_DRAW_ROPE;
            S_DRAW_HOOK:    next_state = (degree_counter == 10'd360) ?
                                        S_DRAW_DONE : S_DRAW_HOOK;
            S_DRAW_DONE:    next_state = S_START;
          default: next_state = S_START;
        endcase      
    end

    wire [63: 0] xRad = degree_counter * 64'd314 / 64'd1800;
    reg [63: 0] tempX, tempY;
    reg [63: 0] midX, interX;
    reg [8: 0] cos, sin;
    reg signCos, signSin;

    //Logic
    always @(posedge clock) begin
        writeEn = 1'b0;
        outX = centerX;
        outY = centerY;
        done = 1'b0;

        case (degree_counter)
            0: begin
                cos	= 9'd100;
                sin	= 9'd  0;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            5: begin
                cos	= 9'd 99;
                sin	= 9'd  8;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            10: begin
                cos	= 9'd 98;
                sin	= 9'd 17;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            15: begin
                cos	= 9'd 96;
                sin	= 9'd 25;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            20: begin
                cos	= 9'd 93;
                sin	= 9'd 34;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            25: begin
                cos	= 9'd 90;
                sin	= 9'd 42;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            30: begin
                cos	= 9'd 86;
                sin	= 9'd 49;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            35: begin
                cos	= 9'd 81;
                sin	= 9'd 57;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            40: begin
                cos	= 9'd 76;
                sin	= 9'd 64;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            45: begin
                cos	= 9'd 70;
                sin	= 9'd 70;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            50: begin
                cos	= 9'd 64;
                sin	= 9'd 76;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            55: begin
                cos	= 9'd 57;
                sin	= 9'd 81;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            60: begin
                cos	= 9'd 50;
                sin	= 9'd 86;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            65: begin
                cos	= 9'd 42;
                sin	= 9'd 90;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            70: begin
                cos	= 9'd 34;
                sin	= 9'd 93;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            75: begin
                cos	= 9'd 25;
                sin	= 9'd 96;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            80: begin
                cos	= 9'd 17;
                sin	= 9'd 98;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            85: begin
                cos	= 9'd  8;
                sin	= 9'd 99;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            90: begin
                cos	= 9'd  0;
                sin	= 9'd100;
                signCos	= 1'b   1;
                signSin	= 1'b   1;
            end
            95: begin
                cos	= 9'd  8;
                sin	= 9'd 99;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            100: begin
                cos	= 9'd 17;
                sin	= 9'd 98;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            105: begin
                cos	= 9'd 25;
                sin	= 9'd 96;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            110: begin
                cos	= 9'd 34;
                sin	= 9'd 93;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            115: begin
                cos	= 9'd 42;
                sin	= 9'd 90;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            120: begin
                cos	= 9'd 49;
                sin	= 9'd 86;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            125: begin
                cos	= 9'd 57;
                sin	= 9'd 81;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            130: begin
                cos	= 9'd 64;
                sin	= 9'd 76;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            135: begin
                cos	= 9'd 70;
                sin	= 9'd 70;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            140: begin
                cos	= 9'd 76;
                sin	= 9'd 64;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            145: begin
                cos	= 9'd 81;
                sin	= 9'd 57;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            150: begin
                cos	= 9'd 86;
                sin	= 9'd 49;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            155: begin
                cos	= 9'd 90;
                sin	= 9'd 42;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            160: begin
                cos	= 9'd 93;
                sin	= 9'd 34;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            165: begin
                cos	= 9'd 96;
                sin	= 9'd 25;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            170: begin
                cos	= 9'd 98;
                sin	= 9'd 17;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            175: begin
                cos	= 9'd 99;
                sin	= 9'd  8;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            180: begin
                cos	= 9'd100;
                sin	= 9'd  0;
                signCos	= 1'b   0;
                signSin	= 1'b   1;
            end
            185: begin
                cos	= 9'd 99;
                sin	= 9'd  8;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            190: begin
                cos	= 9'd 98;
                sin	= 9'd 17;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            195: begin
                cos	= 9'd 96;
                sin	= 9'd 25;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            200: begin
                cos	= 9'd 93;
                sin	= 9'd 34;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            205: begin
                cos	= 9'd 90;
                sin	= 9'd 42;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            210: begin
                cos	= 9'd 86;
                sin	= 9'd 50;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            215: begin
                cos	= 9'd 81;
                sin	= 9'd 57;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            220: begin
                cos	= 9'd 76;
                sin	= 9'd 64;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            225: begin
                cos	= 9'd 70;
                sin	= 9'd 70;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            230: begin
                cos	= 9'd 64;
                sin	= 9'd 76;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            235: begin
                cos	= 9'd 57;
                sin	= 9'd 81;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            240: begin
                cos	= 9'd 50;
                sin	= 9'd 86;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            245: begin
                cos	= 9'd 42;
                sin	= 9'd 90;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            250: begin
                cos	= 9'd 34;
                sin	= 9'd 93;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            255: begin
                cos	= 9'd 25;
                sin	= 9'd 96;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            260: begin
                cos	= 9'd 17;
                sin	= 9'd 98;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            265: begin
                cos	= 9'd  8;
                sin	= 9'd 99;
                signCos	= 1'b   0;
                signSin	= 1'b   0;
            end
            270: begin
                cos	= 9'd  0;
                sin	= 9'd100;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            275: begin
                cos	= 9'd  8;
                sin	= 9'd 99;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            280: begin
                cos	= 9'd 17;
                sin	= 9'd 98;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            285: begin
                cos	= 9'd 25;
                sin	= 9'd 96;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            290: begin
                cos	= 9'd 34;
                sin	= 9'd 93;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            295: begin
                cos	= 9'd 42;
                sin	= 9'd 90;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            300: begin
                cos	= 9'd 50;
                sin	= 9'd 86;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            305: begin
                cos	= 9'd 57;
                sin	= 9'd 81;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            310: begin
                cos	= 9'd 64;
                sin	= 9'd 76;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            315: begin
                cos	= 9'd 70;
                sin	= 9'd 70;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            320: begin
                cos	= 9'd 76;
                sin	= 9'd 64;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            325: begin
                cos	= 9'd 81;
                sin	= 9'd 57;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            330: begin
                cos	= 9'd 86;
                sin	= 9'd 50;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            335: begin
                cos	= 9'd 90;
                sin	= 9'd 42;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            340: begin
                cos	= 9'd 93;
                sin	= 9'd 34;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            345: begin
                cos	= 9'd 96;
                sin	= 9'd 25;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            350: begin
                cos	= 9'd 98;
                sin	= 9'd 17;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
            355: begin
                cos	= 9'd 99;
                sin	= 9'd  8;
                signCos	= 1'b   1;
                signSin	= 1'b   0;
            end
        endcase

        case (current_state)
            S_START: begin
                //pass
            end
            S_DRAW: begin
//                writeEn = 0;
                degree_counter <= 0;
                length_counter <= 0;
            LEDR = 9'b0;
            end
            S_DRAW_ROPE: begin
                LEDR[3] = 1'b1;
                
                 tempX = length_counter * cos / 9'd100;
                 outX = ROPE_START_X + tempX[8:0] * (signCos ? 9'd1 : -9'd1);

                 
                 tempY = length_counter * sin / 9'd100;
                 outY = ROPE_START_Y + (signSin ? tempY[7:0] : -tempY[7:0]);

                length_counter <= length_counter + 1;
            end
            S_DRAW_HOOK: begin
                LEDR[2] = 1'b1;
                
                 tempX = RADIUS * cos / 9'd100;
                 outX = centerX + tempX[8:0] * (signCos ? 9'd1 : -9'd1);
                   
                 tempY = RADIUS * sin / 9'd100;
                 outY = centerY + (signSin ? tempY[7:0] : -tempY[7:0]);

                if (degree_counter < degree | degree_counter > (degree + 40))
                    writeEn = 1'b1;
                else    
                    writeEn = 1'b0;

                degree_counter <= degree_counter + 5;
            end
            S_DRAW_DONE: begin
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
