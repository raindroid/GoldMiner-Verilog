/**
 * This is the module for generating new item list
 * List Format:
 *      At most 30 items in the list
 *      0  - 9  : golds
 *      10 - 19 ：stones
 *      20 - 29 : diamonds 
 *      For item n: 
            d[n << 5 + 31 : n << 5 + 19] >> 4 == left  when drawing
            d[n << 5 + 18 : n << 5 + 8] >> 4 == top 
            d[n << 5] moved?
            d[n << 5 + 1] visible?
            d[n << 5 + 7 : n << 5 + 2] extendable data, not in
 *
 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      quantity
 *      item
 *
 * PARAMETER:
 *
 * OUTPUT:
 *      [17:0] item

 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 17, 2018
 * Last Updated: Nov 17, 2018, just started
 * Tested: init
 **/

 module Rand(
    input clock, resetn, enable,
    output reg [8 : 0] out
 );
    parameter SEED = 16'd163;
    parameter parA = 16'd43;
    parameter parB = 16'd181;
    wire[40: 0] temp;
    reg [5: 0] counter;
    assign temp = counter * out + parB;
    always @(posedge clock) begin
        if (!resetn) begin 
            out = SEED;
            counter = 1;
        end
        else if (enable) begin 
            out <= temp % 457;
            counter = counter + temp[5:2];
        end
    end
 endmodule // Rand
 
 module ItemMap(
     clock,
     resetn, 
     generateEn, 
    //  quantity, 
     size,
     data,
     counter,

    moveEn,
    moveIndex,
    moveX,      //please multiple by << 4
    moveY,   
    moveState,
    visible,
 );
    parameter MAX_SIZE = 576; //576
    input clock, resetn, generateEn;
    // input [4:0] quantity;
    input [5:0] size;
    output reg [MAX_SIZE - 1: 0] data;
    input moveEn;
    input [5:0]moveIndex;
    input [10:0]moveX;      //please multiple by << 4
    input [10:0]moveY;   
    input moveState, visible;
    output reg [5:0] counter;

    reg regO[31:0];
    wire [4:0]x;
    wire [3:0]y;
    Rand rand_gen(
        .clock(clock),
        .resetn(resetn),
        .enable(generateEn),
        .out({x,y})
    );
    wire [13:0] tempX, tempY;
    integer index;
    integer k;
    reg isCovered;
    reg isMoving;
    reg [25:0] usedData [31:0];

    reg [13:0] testX, testY;
    reg [25:0] tempData, tempOld;
    always @(posedge clock, negedge generateEn) begin
        if (!generateEn) begin
            counter = 0;
        end

        if (!resetn) begin
            data = 0;
            counter = 0;
            isMoving = 0;
            
        end
        else if (generateEn) begin
            isCovered <= 0;
            testX <= x % 20;
            testY <= y % 10;
            tempData <=  ((x%20) << 21) + ((y%10) << 9);
            for (index = 0; index < counter; index = index + 1) begin

                tempOld = usedData[index];
                if (tempOld[25:0] == tempData[25:0]) isCovered <= 1;
                
            end
            if (!isCovered) begin
                usedData[counter] <= tempData;
                data <= data + (tempData << (counter * 26));
                counter <= counter + 1;
            end
        end
        else if (moveEn) begin
            isMoving = 1;

            data[moveIndex * 26] <= moveState;
            data <= data + (moveX[10]? -1: 1) * ((moveX[9:0] >> 0) << (moveIndex * 26 + 13)) + 
                (moveY[10]? -1: 1) * ((moveY >> 0) << (moveIndex * 26 + 1));
        end 
    end
    assign tempX = (data[moveIndex * 26 + 25] << 12) + 
                    (data[moveIndex * 26 + 24] << 11) + 
                    (data[moveIndex * 26 + 23] << 10) + 
                    (data[moveIndex * 26 + 22] << 9) + 
                    (data[moveIndex * 26 + 21] << 8) + 
                    (data[moveIndex * 26 + 20] << 7) + 
                    (data[moveIndex * 26 + 19] << 6) + 
                    (data[moveIndex * 26 + 18] << 5) + 
                    (data[moveIndex * 26 + 17] << 4) + 
                    (data[moveIndex * 26 + 16] << 3) + 
                    (data[moveIndex * 26 + 15] << 2) + 
                    (data[moveIndex * 26 + 14] << 1) + 
                    (data[moveIndex * 26 + 13] << 0);

    assign  tempY = (data[moveIndex * 26 + 12] << 11) + 
                    (data[moveIndex * 26 + 11] << 10) + 
                    (data[moveIndex * 26 + 10] << 9) + 
                    (data[moveIndex * 26 + 9] << 8) + 
                    (data[moveIndex * 26 + 8] << 7) + 
                    (data[moveIndex * 26 + 7] << 6) + 
                    (data[moveIndex * 26 + 6] << 5) + 
                    (data[moveIndex * 26 + 5] << 4) + 
                    (data[moveIndex * 26 + 4] << 3) + 
                    (data[moveIndex * 26 + 3] << 2) + 
                    (data[moveIndex * 26 + 2] << 1) + 
                    (data[moveIndex * 26 + 1] << 0);
 endmodule // ItemGenerator