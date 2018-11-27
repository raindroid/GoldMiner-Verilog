/**
 *  module for rope and it's movement
 **/

module NewRope(
    input clock, resetn, enable,
    input [63:0] originX,
    input [3:0] quantity,

    input go_KEY, //physical key for the go input 

    output reg[9:0] endX, endY, degree, //not all the output is useful
    output [9:0]rope_len,

    output [9:0] current_score,

    //interface with ram
    input [31:0] read_data,
    output reg read_req, write_req,
    output [3:0] address,
    output reg [31:0] write_data,
    input read_done, write_done,
    output reg release_resource,

    //Test only
    output [9:0]LEDR,
    output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
    // output bomb_use

 );
    parameter mode = 1'b0;
    parameter player = 1'b0;
    parameter originY = 64'd45;

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
                S_AFTER_MOVE_WRITE  = 5'd25,
                S_AFTER_MOVE_WAIT   = 5'd23,
                S_UP_DELAY  = 5'd10,
                S_PRE_CHECK = 5'd11,
                S_IN_CHECK  = 5'd20,
                S_IN_CHECK_READ     = 5'd12,
                S_IN_CHECK_CHECK    = 5'd19,
                S_SAVE      = 5'd13,
                S_SAVE_WAIT = 5'd24; 


    reg rCW; //Is or was in cw rotation
    reg [31: 0] length; //more precise length
    reg [3:0] rope_index;
    assign rope_len[9:0] = length[17:8];  //magnify by << 8, to get drawable length
    
    reg [4:0] current_state, next_state;

    //Game data
    parameter FRAME_CLOCK = 833_334; //used for frame counter
    // parameter ROPE_MAX = 200;
    parameter ROPE_MIN = 10'd20;
    parameter UP_DELAY_TIMES = 3;
    parameter DELTA_LEN = 18'd5;
        
    //for data manipulation
    
    assign address = rope_index;

    //some info
    reg [31:0] frame_counter;
    reg found_stone;     //a flag to tell should we move a stone or not
    reg [3:0] move_index;   //possibly store the stone we need to move
    reg [31:0] tempData;    
    wire [1:0] tempType;
    assign tempType[1:0] = tempData[3:2];

    //for check part
    wire [13:0] tempX, tempY;
    assign tempX = {5'b0, tempData[31:23]};
    assign tempY = {6'b0, tempData[18:11]};

    //for score
    parameter SCORE_STONE = 8'd10;
    parameter SCORE_GOLD = 8'd20;
    parameter SCORE_DIAMOND = 8'd50;
    reg scoreEn, scorePlus;
    reg [7:0] score_change;
    Score my_score(
        .clock(clock),
        .resetn(resetn),
        .writeEn(scoreEn),
        .plus(scorePlus),
        .score_change_DATA(score_change),
        .score(current_score)
    );
    
    //for trig formula
    wire [8:0] deg_sin, deg_cos;
    wire deg_signSin, deg_signCos;
    trig deg_trig(
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
    defparam go_DET.PULSE_LENGTH = FRAME_CLOCK;

    //Debug
    // assign LEDR[0] = (rope_len < ROPE_MIN);
    // assign LEDR[1] = write_req;
    // assign LEDR[2] = scoreEn;
    // assign LEDR[3] = rCW;
    // assign LEDR[4] = found_stone;
    // assign LEDR[5] = tempType[0];
    // assign LEDR[6] = tempType[1];
    // assign LEDR[9:7] = move_index[2:0];
    assign LEDR[4:0] = current_state[4:0];
    hex_decoder H0(
        .hex_digit(rope_index), 
        .segments(HEX0)
        );
    hex_decoder H3(
        .hex_digit(rope_len[3:0]), 
        .segments(HEX3)
        );
    hex_decoder H4(
        .hex_digit(rope_len[7:4]), 
        .segments(HEX4)
        );
    hex_decoder H5(
        .hex_digit({3'b0,rope_len[8]}), 
        .segments(HEX5)
        );

    always @(posedge clock) begin
        //update x,y based on length and degree
        endX = originX + ((rope_len * deg_cos) >> 8) * (deg_signCos ? 64'd1 : -64'd1);
        endY = originY + ((rope_len * deg_sin) >> 8) * 64'd1;

        read_req = 0;
        write_req = 0;
        release_resource = 0;
        
        case (current_state)
            S_STOP: begin
                degree = 10'd90;
                rCW = 0;
                frame_counter = 0;
                found_stone = 0;
                tempData = 0;
                rope_index = 0;
                write_data = 0;
                move_index = 0;
                length = ROPE_MIN << 8;

                next_state = S_PRE_RCCW;
            end
            S_PRE_RCCW: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK) begin
                    next_state = S_IN_RCCW;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_RCCW;
                end
            end
            S_IN_RCCW: begin
                degree = degree - 1;
                rCW = 0;
                if (degree < 15 + 1)
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
                if (frame_counter >= FRAME_CLOCK) begin
                    next_state = S_IN_RCW;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_RCW;
                end
            end
            S_IN_RCW: begin
                degree = degree + 1;
                rCW = 1;
                if (degree >= 165 - 1)
                    next_state = S_PRE_RCCW;
                else if (go)
                    next_state = S_PRE_DOWN;
                else
                    next_state = S_PRE_RCW;
                frame_counter = 0;
            end
            S_PRE_UP: begin
                frame_counter = frame_counter + 1;
                if (frame_counter >= (FRAME_CLOCK * 2 + (64'b1 * found_stone * UP_DELAY_TIMES * FRAME_CLOCK))) begin
                    next_state = S_IN_UP;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_UP;
                end
            end
            S_IN_UP: begin
                length = length - (DELTA_LEN << 8);
                if (rope_len < ROPE_MIN + 1) begin
                //reach the top
                    if (found_stone)
                        next_state = S_MOVE;
                    else if (rCW)
                        next_state = S_PRE_RCW;
                    else
                        next_state = S_PRE_RCCW;
                end
                else begin
                    if (found_stone)
                        next_state = S_MOVE;
                    else
                        next_state = S_PRE_UP;
                end
                frame_counter = 0;
            end
            S_MOVE: begin
                rope_index = move_index;
                next_state = S_MOVE_READ;
            end
            S_MOVE_READ: begin
                read_req = 1;
                next_state = S_MOVE_READ_WAIT;
            end
            S_MOVE_READ_WAIT: begin
                if (!read_done) begin
                    read_req = 1;
                    next_state = S_MOVE_READ_WAIT;
                end
                else begin 
                    release_resource = 1;
                    tempData = read_data;
                    next_state = S_MOVE_NEW_XY;
                end
            end
            S_MOVE_NEW_XY: begin
                write_data = (tempType[1:0] << 2) + ((endX[8:0] - 4) << 23) + ((endY[7:0] - 4) << 11) + 2'b11;
                next_state = S_MOVE_WRITE;
            end
            S_MOVE_WRITE: begin
                write_req = 1;
                next_state = S_MOVE_WRITE_WAIT;
            end
            S_MOVE_WRITE_WAIT: begin
                if (!write_done) begin
                    write_req = 1;
                    next_state = S_MOVE_WRITE_WAIT;
                end
                else begin 
                    release_resource = 1;
                    if (rope_len < ROPE_MIN + 10'd10) begin
                        next_state = S_AFTER_MOVE;
                    end
                    else begin
                        next_state = S_PRE_UP;
                    end
                    frame_counter = 0;
                end
            end
            S_AFTER_MOVE: begin
                //Score part
                scorePlus = 1'b1;
                scoreEn = 1'b1;
                score_change = (tempType == 2'b0 ? SCORE_STONE : 
                        (tempType == 2'b1 ? SCORE_GOLD : SCORE_DIAMOND));
                //Make the item invisible
                write_data[1:0] = 2'b0; // 10 for visible, 1 for moving
                next_state = S_AFTER_MOVE_WRITE;
            end
            S_AFTER_MOVE_WRITE: begin
                write_req = 1;
                next_state = S_AFTER_MOVE_WAIT;
            end
            S_AFTER_MOVE_WAIT: begin
                if (write_done) begin
                    write_req = 1;
                    next_state = S_AFTER_MOVE_WAIT;
                end
                else begin 
                    release_resource = 1;
                    found_stone = 0;
                    next_state = S_PRE_UP;
                    frame_counter = 0;
                end
            end
            S_PRE_DOWN: begin
                found_stone = 0;
                frame_counter = frame_counter + 1;
                if (frame_counter >= FRAME_CLOCK) begin
                    next_state = S_IN_DOWN;
                    frame_counter = 0;
                end
                else begin
                    next_state = S_PRE_DOWN;
                end
            end
            S_IN_DOWN: begin
                frame_counter = 0;
                length = length + (DELTA_LEN << 8);
                if (endX < 2 | endX >= 318 | endY >= 238 ) begin
                    next_state = S_PRE_UP;
                end
                else
                    next_state = S_PRE_CHECK;
            end
            S_PRE_CHECK: begin
                rope_index = 0;
                next_state = S_IN_CHECK;
            end
            S_IN_CHECK: begin
                if (rope_index >= quantity) begin
                    //not found
                    next_state = S_PRE_DOWN;
                    frame_counter = 0;
                end
                else begin
                    read_req = 1;
                    next_state = S_IN_CHECK_READ;
                end
            end
            S_IN_CHECK_READ: begin 
                if (!read_done) begin
                    read_req = 1;
                    next_state = S_IN_CHECK_READ;
                end
                else begin 
                    release_resource = 1;
                    tempData = read_data;
                    next_state = S_IN_CHECK_CHECK;
                end
            end
            S_IN_CHECK_CHECK: begin
                if (tempData[0] | !tempData[1]) begin
                    rope_index = rope_index + 1;
                    read_req = 1;
                    next_state = S_IN_CHECK;
                end
                else if (((tempX) < endX) & 
                        (endX <= (tempX + 16 < 320 ? tempX + 16: 320)) &
                        ((tempY - 6 > 0 ? tempY - 6 : 0) < endY) & 
                        (endY <= (tempY + 16 < 240 ? tempY + 16 : 240))) begin
                            found_stone = 1;
                            tempData[0] = 1;
                            move_index = rope_index;
                            next_state = S_SAVE;
                            frame_counter = 0;
                end
                else begin
                    next_state = S_IN_CHECK;
                    read_req = 1;
                    rope_index = rope_index + 1;
                end
            end
            S_SAVE: begin
                write_req = 1;
                next_state = S_SAVE_WAIT;
                frame_counter = 0;
            end
            S_SAVE_WAIT: begin
                if (!write_done) begin
                    write_req = 1;
                    next_state = S_SAVE_WAIT;
                end
                else begin 
                    release_resource = 1;
                    next_state = S_PRE_UP;              
                end
            end
          default: next_state = S_STOP;
        endcase
    end

    always @(posedge clock) begin
        if (!resetn) begin
            current_state <= S_STOP;
        end            
        // else if (draw_stone_flag) begin
        //     current_state <=S_WAIT_FOR_LIVE ;
        // end
        else begin
            current_state <= next_state;
        end
    end

endmodule // Rope