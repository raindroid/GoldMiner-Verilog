/**
 *  module for rope and it's movement
 **/

module Rope(
    input clock, resetn, enable,
    input draw_stone_flag, //on when the previous drawing is in process
    input [3:0] draw_index,
    input [3:0] quantity,

    input go_KEY, //physical key for the go input
    //bomb_KEY,
    // input bomb_quantity,

    output reg[9:0] rotation_speed, line_speed, endX, endY, degree, //not all the output is useful
    output reg[9:0]rope_len,

    output [31:0] data
    output [9:0] current_score;
    // output bomb_use

 );
    parameter mode = 1'b0;
    parameter player = 1'b0;
    parameter originX = ((!mode) ? 10'd160 : (player ? 10'd237 : 10'd77));
    parameter originY = 10'd45;

    /**
     * STATE
     * 00 - rotate ccw
     * 01 - rotate cw
     * 10 - down
     * 11 - up
     **/
    reg [1:0] state; 
    reg rCW; //Is or was in cw rotation
    reg [17: 0] length; //more precise length
    assign rope_len = length[17:8];  //magnify by << 8, to get drawable length
    
    reg [4:0] current_state, next_state;

    parameter FRAME_CLOCK = 833_334; //used for frame counter
    parameter ROPE_MAX = 200;
    parameter UP_DELAY_TIMES = 3;

    reg [3:0] rope_index; //the index for rope to control
    reg [31:0] data_write; //used to write to the ram
    reg writeEn;
    
    //for data manipulation
    wire [31:0]read_data; //data output
    assign data = read_data;
	wire [3:0]read_address;
    assign read_address = draw_stone_flag ? draw_index : rope_index;

    //some info
    reg [31:0] frame_counter;
    reg found_stone;     //a flag to tell should we move a stone or not
    reg [3:0] move_index;   //possibly store the stone we need to move
    reg [31:0] tempData;    
    reg [1:0] tempType;

    //for check part
    reg [3:0] check_counter;
    reg [13:0] tempX, tempY;

    //for score
    parameter SCORE_STONE = 1;
    parameter SCORE_GOLE = 2;
    parameter SCORE_DIAMOND = 5;
    reg scoreEn, scorePlus;
    reg [7:0] score_change;
    Score my_score(
        .clock(clock),
        .resetn(resetn),
        .writeEn(scoreEn),
        .plus(scorePlus),
        .score_change_DATA(score_change),
        .score(current_score)
    )
    
    //for trig formula
    wire [8:0] deg_sin, deg_cos;
    wire deg_signSin, deg_signCos;
    trig degree_trig(
        .degree(degree),
        .cos(deg_cos),
        .sin(deg_sin),
        .signCos(deg_signCos),
        .signSin(deg_signSin)
    );

    //for go KEY
    wire go, fire; //go is the moving signal
    key_detector go_DET(
        .clock(clock), 
        .resetn(resetn),
        .key(go_KEY),
        .pulse(go)
    );
    defparam PULSE_LENGTH = FRAME_CLOCK;

    //for ram
	initialize_1 initial_1(
        .address(read_address),
        .clock(clock),
        .data(data_write),
        .wren(writeEn),
        .q(read_data));

    localparam  S_STOP      = 5'd0,
                S_PRE_RCCW  = 5'd1,
                S_IN_RCCW   = 5'd2,
                S_PRE_RCW   = 5'd3,
                S_IN_RCW    = 5'd4,
                S_PRE_UP    = 5'd5,
                S_IN_UP     = 5'd6,
                S_PRE_DOWN  = 5'd7,
                S_IN_DOWN   = 5'd8,
                S_MOVE      = 5'd9,
                S_MOVE_READ = 5'd14,
                S_MOVE_READ_WAIT    = 5'd15,
                S_MOVE_NEW_XY       = 5'd18,
                S_MOVE_WRITE= 5'd16,
                S_MOVE_WRITE_WAIT   = 5'd17,
                S_MOVE_DELAY    = 5'd22,
                S_AFTER_MOVE    = 5'd21,
                S_UP_DELAY  = 5'd10,
                S_PRE_CHECK = 5'd11,
                S_IN_CHECK  = 5'd20,
                S_IN_CHECK_READ     = 5'd12,
                S_IN_CHECK_CHECK    = 5'd19,
                S_SAVE      = 5'd13;

    always @(posedge clock) begin
        //update x,y based on length and degree
        endX = originX + ((length * deg_cos) >> 8) * (deg_signCos ? 64'd1 : -64'd1);
        endY = originY + ((length * deg_sin) >> 8);

        scoreEn = 0;
        writeEn = 0;

        case (current_state)
            S_STOP: begin
                state = 2'b00;
                rCW = 0;
                length = 10 << 8;
                degree = 170;
                if (enable) next_state = S_PRE_RCCW;
                else next_state = S_STOP;
                frame_counter = 0;
            end
            S_PRE_RCCW: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK & (!draw_stone_flag)) begin
                    next_state = S_IN_RCCW;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_RCCW;
                end
            end
            S_IN_RCCW: begin
                degree = degree - 1;
                if (degree <= 15)
                    next_state = S_PRE_RCW;
                else if (go)
                    next_state = S_PRE_DOWN;
                else
                    next_state = S_PRE_RCCW;
                frame_counter = 0;
            end
            S_PRE_RCW: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK & (!draw_stone_flag)) begin
                    next_state = S_IN_RCW;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_RCW;
                end
            end
            S_IN_RCW: begin
                degree = degree + 1;
                if (degree >= 165)
                    next_state = S_PRE_RCCW;
                else if (go)
                    next_state = S_PRE_DOWN;
                else
                    next_state = S_PRE_RCW;
                frame_counter = 0;
            end
            S_PRE_UP: begin
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK & (!draw_stone_flag)) begin
                    next_state = S_IN_UP;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_UP;
                end
            end
            S_IN_UP: begin
                length = length - 1 << 3;
                if (rope_len <= 10) begin
                  //reach the top
                    if (found_stone)
                        next_state = S_MOVE;
                    else if (rCW)
                        next_state = S_PRE_RCW;
                    else
                        next_state = S_PRE_RCCW;
                end
                else 
                    next_state = S_PRE_UP;
                frame_counter = 0;
            end
            S_MOVE: begin
                next_state = S_MOVE_READ;
            end
            S_MOVE_READ: begin
                rope_index = move_index;
                next_state = S_MOVE_READ_WAIT;
            end
            S_MOVE_READ_WAIT: begin
                tempData = read_data;
                next_state = S_MOVE_NEW_XY;
            end
            S_MOVE_NEW_XY: begin
                tempData = tempData - ((8'd8 * deg_sin) << 7) -
                        ((9'd8 * deg_cos * signCos) << 19);
                next_state = S_MOVE_WRITE;
            end
            S_MOVE_WRITE: begin
                writeEn = 1;
                rope_index = move_index;
                data_write = tempData;
                next_state = S_MOVE_WRITE_WAIT;
            end
            S_MOVE_WRITE_WAIT: begin
                writeEn = 1;
                rope_index = move_index;
                if (rope_len <= 10) begin
                    //Score part
                    scorePlus = 1'b1;
                    scoreEn = 1'b1;
                    tempType = tempData[3:2];
                    score_change = (tempData == 2'b0 ? SCORE_STONE : 
                            (tempData == 2'b1 ? SCORE_GOLE : SCORE_DIAMOND));
                    //Make the item invisible
                    data_write[1:0] = 2'b0; // 10 for visible, 1 for moving

                    next_state = S_MOVE_DELAY;
                end
                else begin
                    data_write = tempData;
                    next_state = S_PRE_UP;
                end
                frame_counter = 0;
            end
            S_MOVE_DELAY: begin
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK * UP_DELAY_TIMES & (!draw_stone_flag)) begin
                    next_state = S_AFTER_MOVE;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_MOVE_DELAY;
                end
            end
            S_AFTER_MOVE: begin
                writeEn = 1
                if (rCW)
                    next_state = S_PRE_RCW;
                else
                    next_state = S_PRE_RCCW;
            end
            S_PRE_DOWN: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK & (!draw_stone_flag)) begin
                    next_state = S_IN_DOWN;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_DOWN;
                end
            end
            S_IN_DOWN: begin
                frame_counter = 0;
                if (rope_len == ROPE_MAX) 
                    next_state = S_PRE_UP;
                else
                    next_state = S_PRE_CHECK;
            end
            S_PRE_CHECK: begin
                rope_index = 0;
                next_state = S_IN_CHECK;
            end
            S_IN_CHECK: begin
                rope_index = rope_index + 1;
                if (rope_index >= quantity) begin
                    //not found
                    next_state = S_PRE_DOWN;
                    frame_counter = 0;
                end
                else 
                    next_state = S_IN_CHECK_READ;
            end
            S_IN_CHECK_READ: begin
                tempData = read_data;
                tempX = {1'b0, read_data[31:19]};
                tmepY = {2'b0, read_data[18:7]};
                next_state = S_IN_CHECK_CHECK;
            end
            S_IN_CHECK_CHECK: begin
                if (tempData[0] | !tempData[1]) begin
                    next_state = S_IN_CHECK;
                end
                else if ((tempX < endX) & (endX < tempX + 16) &
                        (tempY < endY) & (endY < tempY + 16)) begin
                            find_stone = 1;
                            move_index = rope_index;
                            next_state = S_SAVE;
                            frame_counter = 0;
                end
                else 
                    next_state = S_IN_CHECK;
            end
            S_SAVE: begin
                writeEn = 1'b1;
                tempData[0] = 1;
                next_state = S_PRE_UP;
                frame_counter = 0;
            end
          default: 
        endcase
    end

    always @(posedge clock) begin
        if (!resetn) begin
            current_state <= S_STOP;
        end            
        else begin
            current_state <= next_state;
        end
    end

endmodule // Rope