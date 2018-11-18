/**
 * This is the module for generating new item list
 * List Format:
 *      At most 30 items in the list
 *      0  - 7  : golds
 *      8 -  15：stones
 *      16 - : diamonds 
 *      For item n: 
            d[n * 32 + 31 : n * 32 + 19] >> 4 == left  when drawing
            d[n * 32 + 18 : n * 32 + 7] >> 4 == top 
            d[n * 32] moved?
            d[n * 32 + 1] visible?
            d[n * 32 + 7 : n * 32 + 2] extendable data, not in use
 *
 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      quantity
 *      item

        moveEn,
        moveIndex,
        moveX,      //please multiple by << 4
        moveY,   
        moveEn2,
        moveIndex2,
        moveX2,      //please multiple by << 4
        moveY2,   
        moveState2,
        visible2,
        moveState,
        visible,
 *
 * PARAMETER:
 *
 * OUTPUT:
 *      [1 * 32 - 1 : 0] item

 * Author: Yucan Wu
 * Version: 0.1.1
 * Created: Nov 17, 2018
 * Last Updated: Nov 18, 2018, shoule be ok
 * Tested: see TODO
 **/

 //Todo:
 // 1. store info about type
 // 2. generate in order

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
     data,
     counter,
	  quantity,
     

    moveEn,
    moveIndex,
    moveX,      //please multiple by << 4
    moveY,   

    moveEn2,
    moveIndex2,
    moveX2,      //please multiple by << 4
    moveY2,   

    moveState2,
    visible2,
    moveState,
    visible,
 );
    parameter stone_size = 16;
    parameter gold_size = 16;
    parameter diamond_size = 8;
    localparam size = 16; 
    parameter MAX_SIZE = 32 << 5; //1024
    input clock, resetn, generateEn;
    output reg [MAX_SIZE - 1: 0] data;
    input moveEn;
    input [5:0]moveIndex;
    input [10:0]moveX;      //please multiple by << 4
    input [10:0]moveY;   
    input moveState, visible;
    input [5:0] quantity;
    output reg [5:0] counter;
    input moveEn2;
    input [5:0]moveIndex2;
    input [10:0]moveX2;      //please multiple by << 4
    input [10:0]moveY2;   
    input moveState2, visible2;

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
    reg [63:0] usedData [63:0];

    wire [13:0] testX, testY;
    reg [31:0] tempData, tempOld;
    always @(posedge clock) begin
        if (!generateEn) begin
            counter = 0;
        end

        if (!resetn) begin
            data = 0;
            counter = 0;
            isMoving = 0;            
        end
        else if (generateEn & counter < quantity) begin
            isCovered <= 0;
            tempData <=  ((x%20) << 27) + ((y%10) << 15);
            for (index = 0; index < counter; index = index + 1) begin

                tempOld = usedData[index];
                // tempOld = (usedData[index][31] << 31) + 
                //         (usedData[index][30] << 30) + 
                //         (usedData[index][29] << 29) + 
                //         (usedData[index][28] << 28) + 
                //         (usedData[index][27] << 27) +
                //         (usedData[index][18] << 18) + 
                //         (usedData[index][17] << 17) + 
                //         (usedData[index][16] << 16) + 
                //         (usedData[index][15] << 15);
                if (tempOld[31:0] == tempData[31:0]) isCovered <= 1;
                
            end
            if (!isCovered) begin
                usedData[counter] <= tempData;
                data <= data + (tempData << (counter * 32));
                counter <= counter + 1;
            end
        end
        else begin 
            if (moveEn & moveEn2) begin
                isMoving = 1;
                isMoving = 1;
                data <= data + (moveX[10]? -1: 1) * ((moveX[9:0]) << (moveIndex * 32 + 19)) + 
                    (moveY[10]? -1: 1) * ((moveY[9:0]) << (moveIndex * 32 + 7)) +
                    (moveX2[10]? -1: 1) * ((moveX2[9:0]) << (moveIndex2 * 32 + 19)) + 
                    (moveY2[10]? -1: 1) * ((moveY2[9:0]) << (moveIndex2 * 32 + 7));
                data[moveIndex2 * 32 + 1] <= visible2;
                data[moveIndex2 * 32] <= moveState2;
                data[moveIndex * 32 + 1] <= visible;
                data[moveIndex * 32] <= moveState;
            end 
            else if (moveEn) begin
                isMoving = 1;
                data <= data + (moveX[10]? -1: 1) * ((moveX[9:0]) << (moveIndex * 32 + 19)) + 
                    (moveY[10]? -1: 1) * ((moveY[9:0]) << (moveIndex * 32 + 7));
                data[moveIndex * 32 + 1] <= visible;
                data[moveIndex * 32] <= moveState;
            end
            else if (moveEn2) begin
                isMoving = 1;
                data <= data + (moveX2[10]? -1: 1) * ((moveX2[9:0]) << (moveIndex2 * 32 + 19)) + 
                    (moveY2[10]? -1: 1) * ((moveY2[9:0]) << (moveIndex2 * 32 + 7));
                data[moveIndex2 * 32 + 1] <= visible2;
                data[moveIndex2 * 32] <= moveState2;
            end
        end
    end

    //The rest is only for test purpose
    assign tempX = (data[moveIndex * 32 + 31] << 12) + 
            (data[moveIndex * 32 + 30] << 11) + 
            (data[moveIndex * 32 + 29] << 10) + 
            (data[moveIndex * 32 + 28] << 9) + 
            (data[moveIndex * 32 + 27] << 8) + 
            (data[moveIndex * 32 + 26] << 7) + 
            (data[moveIndex * 32 + 25] << 6) + 
            (data[moveIndex * 32 + 24] << 5) + 
            (data[moveIndex * 32 + 23] << 4) + 
            (data[moveIndex * 32 + 22] << 3) + 
            (data[moveIndex * 32 + 21] << 2) + 
            (data[moveIndex * 32 + 20] << 1) + 
            (data[moveIndex * 32 + 19] << 0);

    assign  tempY = (data[moveIndex * 32 + 18] << 11) + 
            (data[moveIndex * 32 + 17] << 10) + 
            (data[moveIndex * 32 + 16] << 9) + 
            (data[moveIndex * 32 + 15] << 8) + 
            (data[moveIndex * 32 + 14] << 7) + 
            (data[moveIndex * 32 + 13] << 6) + 
            (data[moveIndex * 32 + 12] << 5) + 
            (data[moveIndex * 32 + 11] << 4) + 
            (data[moveIndex * 32 + 10] << 3) + 
            (data[moveIndex * 32 + 9] << 2) + 
            (data[moveIndex * 32 + 8] << 1) + 
            (data[moveIndex * 32 + 7] << 0);

    assign testX = (data[moveIndex2 * 32 + 31] << 12) + 
            (data[moveIndex2 * 32 + 30] << 11) + 
            (data[moveIndex2 * 32 + 29] << 10) + 
            (data[moveIndex2 * 32 + 28] << 9) + 
            (data[moveIndex2 * 32 + 27] << 8) + 
            (data[moveIndex2 * 32 + 26] << 7) + 
            (data[moveIndex2 * 32 + 25] << 6) + 
            (data[moveIndex2 * 32 + 24] << 5) + 
            (data[moveIndex2 * 32 + 23] << 4) + 
            (data[moveIndex2 * 32 + 22] << 3) + 
            (data[moveIndex2 * 32 + 21] << 2) + 
            (data[moveIndex2 * 32 + 20] << 1) + 
            (data[moveIndex2 * 32 + 19] << 0);

    assign  testY = (data[moveIndex2 * 32 + 18] << 11) + 
            (data[moveIndex2 * 32 + 17] << 10) + 
            (data[moveIndex2 * 32 + 16] << 9) + 
            (data[moveIndex2 * 32 + 15] << 8) + 
            (data[moveIndex2 * 32 + 14] << 7) + 
            (data[moveIndex2 * 32 + 13] << 6) + 
            (data[moveIndex2 * 32 + 12] << 5) + 
            (data[moveIndex2 * 32 + 11] << 4) + 
            (data[moveIndex2 * 32 + 10] << 3) + 
            (data[moveIndex2 * 32 + 9] << 2) + 
            (data[moveIndex2 * 32 + 8] << 1) + 
            (data[moveIndex2 * 32 + 7] << 0);
    //sample use
    // assign testX = (data[moveIndex * 32 + 31] << 8) + 
    //                 (data[moveIndex * 32 + 30] << 7) + 
    //                 (data[moveIndex * 32 + 29] << 6) + 
    //                 (data[moveIndex * 32 + 28] << 5) + 
    //                 (data[moveIndex * 32 + 27] << 4) + 
    //                 (data[moveIndex * 32 + 26] << 3) + 
    //                 (data[moveIndex * 32 + 25] << 2) + 
    //                 (data[moveIndex * 32 + 24] << 1) + 
    //                 (data[moveIndex * 32 + 23] << 0);
    // assign testY = (data[moveIndex * 32 + 18] << 7) + 
    //                 (data[moveIndex * 32 + 17] << 6) + 
    //                 (data[moveIndex * 32 + 16] << 5) + 
    //                 (data[moveIndex * 32 + 15] << 4) + 
    //                 (data[moveIndex * 32 + 14] << 3) + 
    //                 (data[moveIndex * 32 + 13] << 2) + 
    //                 (data[moveIndex * 32 + 12] << 1) + 
    //                 (data[moveIndex * 32 + 11] << 0) + 80;
    
 endmodule // ItemGenerator