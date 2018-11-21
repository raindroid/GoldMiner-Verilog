/**
 * This is the module for generating new item list
 * List Format:
 *      At most 5 items each in the list
 *      For item n: 
            d[n * 32 + 31 : n * 32 + 19] >> 4 == left  when drawing
            d[n * 32 + 18 : n * 32 + 7] >> 4 == top 
            d[n * 32] moved?
            d[n * 32 + 1] visible?
            d[n * 32 + 3 : n * 32 + 2] type: 0 - stone, 1 - gold, 2 - diamond
            d[n * 32 + 6 : n * 32 + 4] extendable data, not in use
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
 * Version: 0.2.1
 * Created: Nov 17, 2018
 * Last Updated: Nov 19, 2018, ...
 * Tested: run more tests
 **/

module test_top(
    input clk, resetn,enable_random
);
    localparam gold_count = 1,
                stone_count = 1,
                diamond_count = 1;
     
    localparam MAX_SIZE = 32 << 5; //1024
	wire [1023: 0] data;
	wire [5:0]memory_counter;
	wire [63:0]moveIndex;
	assign moveIndex = 0;
	 ItemMap item_map(
    .clock(clk),
    .resetn(resetn), 
    .generateEn(enable_random), 
    .data(data),
    .counter(memory_counter),
    .stoneQuantity(1), 
    .goldQuantity(1), 
    .diamondQuantity(1),

    .moveEn(0),
    .moveIndex(0),
    .moveX(0),      //please multiple by << 4
    .moveY(0),   

    .moveEn2(0),
    .moveIndex2(0),
    .moveX2(0),      //please multiple by << 4
    .moveY2(0),   

    .moveState2(0),
    .visible2(0),
    .moveState(0),
    .visible(0)
    );
	wire [8:0] x_init_gold,x_init_stone,x_init_diamond;
	wire [7:0] y_init_gold,y_init_stone,y_init_diamond;

	assign x_init_gold = (data[1 * 32 + 31] << 8) + 
                    (data[1 * 32 + 30] << 7) + 
                    (data[1 * 32 + 29] << 6) + 
                    (data[1 * 32 + 28] << 5) + 
                    (data[1 * 32 + 27] << 4) + 
                    (data[1 * 32 + 26] << 3) + 
                    (data[1 * 32 + 25] << 2) + 
                    (data[1 * 32 + 24] << 1) + 
	                (data[1 * 32 + 23] << 0);

	assign y_init_gold = (data[1 * 32 + 18] << 7) + 
                     (data[1 * 32 + 17] << 6) + 
                     (data[1 * 32 + 16] << 5) + 
                     (data[1 * 32 + 15] << 4) + 
                     (data[1 * 32 + 14] << 3) + 
                     (data[1 * 32 + 13] << 2) + 
                     (data[1 * 32 + 12] << 1) + 
                     (data[1 * 32 + 11] << 0) + 80;

	assign x_init_stone = data[(0 * 32 + 31):(0 * 32 + 23)];
	assign y_init_stone = data[(0 * 32 + 18):(0 * 32 + 11)] + 80;

	assign x_init_diamond = (data[(2) * 32 + 31] << 8) + 
                    (data[(2)  * 32 + 30] << 7) + 
                    (data[(2)  * 32 + 29] << 6) + 
                    (data[(2)  * 32 + 28] << 5) + 
                    (data[(2)  * 32 + 27] << 4) + 
                    (data[(2)  * 32 + 26] << 3) + 
                    (data[(2)  * 32 + 25] << 2) + 
                    (data[(2)  * 32 + 24] << 1) + 
	                 (data[(2)  * 32 + 23] << 0);
	
    assign y_init_diamond= (data[(2) * 32 + 18] << 7) + 
                     (data[(2) * 32 + 17] << 6) + 
                     (data[(2) * 32 + 16] << 5) + 
                     (data[(2) * 32 + 15] << 4) + 
                     (data[(2) * 32 + 14] << 3) + 
                     (data[(2) * 32 + 13] << 2) + 
                     (data[(2) * 32 + 12] << 1) + 
                     (data[(2) * 32 + 11] << 0) + 80;
endmodule // test_top

 module Rand(
    input clock, resetn, enable,
    output reg [8 : 0] out
 );
    parameter SEED = 16'd173;
    parameter parA = 16'd13;
    parameter parB = 16'd187;
    wire[15: 0] temp;
    // reg [5: 0] counter;
    assign temp = parA * out + parB;
    always @(posedge clock) begin
        if (!resetn) begin 
            out = SEED;
            // counter = 1;
        end
        else if (enable) begin 
            // out <= temp % 457;
            out = temp > 16'd3877 ? temp - 16'd3877 : temp;
            // counter = counter + temp[5:2];
        end
    end
 endmodule // Rand
 
 module ItemMap(
    clock,
    resetn, 
    generateEn, 
    data,
    counter,
    stoneQuantity,
    goldQuantity,
    diamondQuantity,     

    moveEn,
    moveIndex,
    moveX,      //please multiple by << 4
    moveY, 
    moveState,
    visible,  

    moveEn2,
    moveIndex2,
    moveX2,      //please multiple by << 4
    moveY2,   
    moveState2,
    visible2,

    LEDR
 );
    output [8:0] LEDR;
    

    parameter stone_size = 16;
    parameter gold_size = 16;
    parameter diamond_size = 8;
    localparam size = 16; 
    parameter MAX_SIZE = 16 << 32; //512

    //Input & output table START
    input clock, resetn, generateEn;
    output reg [511: 0] data;
    input [3:0]stoneQuantity, goldQuantity, diamondQuantity;

    input moveEn;
    input [5:0]moveIndex;
    input [10:0]moveX;      //please multiple by << 4
    input [10:0]moveY;   
    input moveState, visible;
    input moveEn2;
    input [5:0]moveIndex2;
    input [10:0]moveX2;      //please multiple by << 4
    input [10:0]moveY2;   
    input moveState2, visible2;

    // assign LEDR [8:0] = data[31 : 23];

    output reg [3:0] counter;
    //Input & output table END

    //Continuously generate random numbers
    wire [3:0]quantity;
    wire [4:0]x;
    wire [3:0]y;
    reg randEn;
    Rand rand_gen(
        .clock(clock),
        .resetn(resetn),
        .enable(randEn),
        .out({x,y})
    );
    wire [13:0] tempX, tempY;
    wire [13:0] testX, testY;
    wire [1:0] type;

    
    reg [31:0] usedData [15:0]; //No need for reseting
    reg [31:0] tempData;
    wire [31:0] genData;
    wire [31:0] tempOld;

    assign quantity = stoneQuantity + goldQuantity + diamondQuantity;
    reg [7:0] check_counter;

    reg [4:0] current_state, next_state;
    reg isCovered;
    wire [9:0] counter32;
    
    assign type = (counter < stoneQuantity) ? 2'd0 : 
                (counter < stoneQuantity + goldQuantity) ? 2'd1 : 2'd2;
    assign tempX = tempData >> 27;
    assign tempY = tempData[18:0] >> 15;
    assign testX = tempX << 4;
    assign testY = (tempY << 4) + 80;
    assign tempOld = usedData[check_counter][31:0];
    assign counter32 = counter << 5;
    assign genData = (((x >= 20) ? 39 - x : 5'd20 - x) << 5'd27) + 
                    (((y >= 10) ? 19 - y : 10 - y) << 5'd15);


    localparam  S_START     = 5'd0,
                S_PRE_GEN   = 5'd1,
                S_IN_GEN    = 5'd2,
                S_PRE_CHECK = 5'd3,
                S_IN_CHECK  = 5'd4,
                S_SAVE      = 5'd5,
                S_AFTER_SAVE= 5'd6,
                S_MODIFY    = 5'd7;
   
    always @(posedge clock) begin
        // if (!generateEn) counter <= 0;
		//   if (!resetn) counter <= 0;
        case (current_state)
            S_START: begin
                randEn = 1'b0;
                if (generateEn)
                    next_state = S_PRE_GEN;
                else if (moveEn | moveEn2)
                    next_state = S_MODIFY;
            end 
            S_PRE_GEN: begin
                randEn = 1'b1;
                counter <= 0;
                next_state = S_IN_GEN;
                data = 0;
            end
            S_IN_GEN: begin
                tempData =  genData;
                next_state = S_PRE_CHECK;
            end
            S_PRE_CHECK: begin
                check_counter <= 0;
                next_state = S_IN_CHECK;
                isCovered <= 0; //test_only
            end
            S_IN_CHECK: begin
                if (check_counter >= counter)
                    //We have been through all past data, no same one
                    next_state = S_SAVE; 
                else begin
                    //begin our check process
                    if (tempOld[31:0] == tempData[31:0]) begin
                        //Go back and regenerate
                        next_state = S_IN_GEN;
                        isCovered = 1;
                    end
                    else
                        next_state = S_IN_CHECK;
                    check_counter <= check_counter + 1;
                end
            end
            S_SAVE: begin
                usedData[counter] <= tempData;
                data = data + (tempData << (counter32)) + 
                     (type << (counter32 + 2));
                counter <= counter + 1;
                next_state = S_AFTER_SAVE;
            end
            S_AFTER_SAVE: begin
                if (counter >= quantity) 
                    next_state = S_START;
                else
                    next_state = S_IN_GEN;
            end
            S_MODIFY: begin
                next_state = S_START;
                if (moveEn & moveEn2) begin
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
                    data <= data + (moveX[10]? -1: 1) * ((moveX[9:0]) << (moveIndex * 32 + 19)) + 
                        (moveY[10]? -1: 1) * ((moveY[9:0]) << (moveIndex * 32 + 7));
                    data[moveIndex * 32 + 1] <= visible;
                    data[moveIndex * 32] <= moveState;
                end
                else if (moveEn2) begin
                    data <= data + (moveX2[10]? -1: 1) * ((moveX2[9:0]) << (moveIndex2 * 32 + 19)) + 
                        (moveY2[10]? -1: 1) * ((moveY2[9:0]) << (moveIndex2 * 32 + 7));
                    data[moveIndex2 * 32 + 1] <= visible2;
                    data[moveIndex2 * 32] <= moveState2;
                end
            end
            default: next_state = S_START;
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
    //The rest is only for test purpose
    // assign tempX = (data[moveIndex * 32 + 31] << 12) + 
    //         (data[moveIndex * 32 + 30] << 11) + 
    //         (data[moveIndex * 32 + 29] << 10) + 
    //         (data[moveIndex * 32 + 28] << 9) + 
    //         (data[moveIndex * 32 + 27] << 8) + 
    //         (data[moveIndex * 32 + 26] << 7) + 
    //         (data[moveIndex * 32 + 25] << 6) + 
    //         (data[moveIndex * 32 + 24] << 5) + 
    //         (data[moveIndex * 32 + 23] << 4) + 
    //         (data[moveIndex * 32 + 22] << 3) + 
    //         (data[moveIndex * 32 + 21] << 2) + 
    //         (data[moveIndex * 32 + 20] << 1) + 
    //         (data[moveIndex * 32 + 19] << 0);

    // assign  tempY = (data[moveIndex * 32 + 18] << 11) + 
    //         (data[moveIndex * 32 + 17] << 10) + 
    //         (data[moveIndex * 32 + 16] << 9) + 
    //         (data[moveIndex * 32 + 15] << 8) + 
    //         (data[moveIndex * 32 + 14] << 7) + 
    //         (data[moveIndex * 32 + 13] << 6) + 
    //         (data[moveIndex * 32 + 12] << 5) + 
    //         (data[moveIndex * 32 + 11] << 4) + 
    //         (data[moveIndex * 32 + 10] << 3) + 
    //         (data[moveIndex * 32 + 9] << 2) + 
    //         (data[moveIndex * 32 + 8] << 1) + 
    //         (data[moveIndex * 32 + 7] << 0);
    //  assign testX = (data[moveIndex * 32 + 31] << 8) + 
    //                  (data[moveIndex * 32 + 30] << 7) + 
    //                  (data[moveIndex * 32 + 29] << 6) + 
    //                 (data[moveIndex * 32 + 28] << 5) + 
    //                 (data[moveIndex * 32 + 27] << 4) + 
    //                  (data[moveIndex * 32 + 26] << 3) + 
    //                  (data[moveIndex * 32 + 25] << 2) + 
    //                  (data[moveIndex * 32 + 24] << 1) + 
    //                  (data[moveIndex * 32 + 23] << 0);
    //  assign testY = (data[moveIndex * 32 + 18] << 7) + 
    //                  (data[moveIndex * 32 + 17] << 6) + 
    //                  (data[moveIndex * 32 + 16] << 5) + 
    //                  (data[moveIndex * 32 + 15] << 4) + 
    //                  (data[moveIndex * 32 + 14] << 3) + 
    //                  (data[moveIndex * 32 + 13] << 2) + 
    //                  (data[moveIndex * 32 + 12] << 1) + 
    //                  (data[moveIndex * 32 + 11] << 0) + 80;
    
 endmodule // ItemGenerator