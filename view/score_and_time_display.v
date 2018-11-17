/* This is the module display the score and time, both data and FSM contained
Input :
    clk
    resetn
    score_to_display
    time_remained
    enable_score_and_time_display

Output:
    outX
    outY
    color
    writeEn

    display_score_and_time_done

Author : Yifan Cui
Created 2018/11/16
*/

module score_and_time_display(
    clk,
    resetn,
    score_to_display,
    time_remained,
    enable_score_and_time_display,

    outX,
    outY,
    color,
    writeEn,

    display_score_and_time_done
    );

    input clk, resetn;
    input [7:0]score_to_display;
    input [7:0]time_remained;

    output [8:0]outX,
    output [7:0]outY;
    output [11:0]color;
    output writeEn;

    output display_score_and_time_done;

    wire decimal_bit_count_enable,
         load_x_num,
         load_y_num,
         display_score,
         display_time,
         enable_x_adder_num,
         enable_y_adder_num,
         enable_num_pixel_counter,
         resetn_num_pixel_counter,
         resetn_decimal_counter,
    wire [4:0]num_mem_address = ({num_pixel[4:3]-1'b1, 3'd0} + {gold_pixel_cout[2:0] - 1'b1});

    localparam score_x_start = 9'd100; //to 60
    localparam score_y_start = 8'd15;
    localparam time_x_start = 9'd100; //to 80
    localparam time_y_start = 8'd30;


    wire [11:0] num1_color;

    num1 num1(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num1_color));
    );


    reg [1:0]x_address;
    reg [2:0]y_address;

    reg [4:0]num_pixel;

    reg [8:0] x_init;
    reg [7:0] y_init;
    
    always@(posedge clk)begin
        if(display_score)begin
            x_init <= score_x_start;
            y_init <= score_y_start;
        end 
        else if(display_time)begin
            x_init <= time_x_start;
            y_init <= time_y_start;
        end
    end

    wire [1:0]decimal_bit_count;
    //decimal bit counter
    reg [3:0]decimal_bit_count;
    wire decimal_bit_count_enable;
    always@(posedge clk)begin
        if(!resetn | !resetn_decimal_counter) decimal_bit_count = 1'b0;
        else if(decimal_bit_count_enable)
            decimal_bit_count <= decimal_bit_count +1'b1;
    end

    wire [3:0]time_one;
    wire [3:0]time_ten;
    wire [1:0]time_hun;
    wire [3:0]score_one;
    wire [3:0]score_ten;
    wire [1:0]score_hun;

    bin_dec time_bin_dec(
        .clk(clk),
        .bin(time_remained),
        .rst_n(resetn),
        .one(time_one),
        .ten(time_ten),
        .hun(time_hun)
    );

    bin_dec score_bin_dec(
        .clk(clk),
        .bin(score_remained),
        .rst_n(resetn),
        .one(score_one),
        .ten(score_ten),
        .hun(score_hun)
    );

    //color register
	always@(posedge clk)begin
		if(!resetn)	color = 12'b0;
		else color <= num1_color;
	end
    
    //x register
	always@(posedge clk)begin
		if(resetn == 0) x <= 9'b0;
		else
			if(load_x_num) begin
			x[8:0] <= x_init - 5 * decimal_bit_count;
			end
	end
	
	//y register
	always@(posedge clk)begin
		if(resetn == 0) y <= 8'b0;
		else
			if(load_y_num) begin
			y[7:0] <= y_init;
			end
	end
	

	//x_out adder
	always@(posedge clk)begin
		if(resetn == 0) X_out_num <= 9'b0;
		else
			if(enable_x_adder_num) begin
				X_out_num <= x + num_pixel[2:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) Y_out_gold <= 8'b0;
		else
			if(enable_y_adder_num)begin
				Y_out_num <= y + num_pixel[3:2];
				end
	end


    //6-bit counter
	always@(posedge clk)begin
		if((resetn == 0) | (resetn_num_pixel_counter == 0)) num_pixel <= 6'b0;
		else
			if(enable_num_pixel_counter)
			num_pixel <= num_pixel + 1'b1;
	end


    //FSM starts here

    localparam  S_START     =5'd0,  //Wait for enable signal
                S_DRAW_SCORE      =5'd1,  //initialize start position
                S_DRAW_SCORE_WAIT = 5'd2, //prepare to draw
                S_DRAW_SCORE_BIT=5'd3,  //Draw score bit
                S_DRAW_SCORE_BIT_WAIT = 5'd10;
                S_DRAW_SCORE_BIT_DONE=5'd4,  //Draw score bit done and reset bit counter
                S_DRAW_TIME = 5'd5, //initialize start postion
                S_DRAW_TIME_WAIT = 5'd6; //prepare to draw
                S_DRAW_TIME_BIT =5'd7,  //Draw time bit
                S_DRAW_TIME_BIT_WAIT = 5'd11;
                S_DRAW_TIME_BIT_DONE=5'd8,  //Draw time bit done and reset bit counter
                S_DRAW_DONE =5'd9;  //Finish and send done sig

    //state table
    always @(*) begin
        case (current_state)
            S_START:        next_state = (enable) ? S_DRAW : S_START;
            S_DRAW_SCORE:         next_state = S_DRAW_SCORE_WAIT;
            S_DRAW_SCORE_WAIT:   next_state = S_DRAW_SCORE_BIT
            S_DRAW_SCORE_BIT:    next_state =  ( num_pixel == 6'd32) ? S_DRAW_SCORE_BIT_DONE : S_DRAW_SCORE_BIT_WAIT;
            S_DRAW_SCORE_BIT_WAIT : next_state = S_DRAW_SCORE_BIT;
            S_DRAW_SCORE_BIT_DONE: next_state = (decimal_bit_count == 3)? S_DRAW_TIME : S_DRAW_SCORE_WAIT;
            S_DRAW_TIME:    next_state = S_DRAW_TIME_WAIT;
            S_DRAW_TIME_WAIT: next_state = S_DRAW_TIME_BIT;
            S_DRAW_TIME_BIT:    next_state =  (num_pixel == 6'd32) ? S_DRAW_TIME_BIT_DONE : S_DRAW_TIME_BIT_WAIT;
            S_DRAW_TIME_BIT_WAIT: next_state = S_DRAW_TIME_BIT;
            S_DRAW_TIME_BIT_DONE: (decimal_bit_count == 3) ? S_DRAW_DONE : S_DRAW_TIME_WAIT;
            S_DRAW_DONE:    next_state = S_START;
          default: next_state = S_START;
        endcase      
    end
    
    //Logic
    always @(posedge clock) begin
        decimal_bit_count_enable = 1'b0;
        load_x_num = 1'b0;
        load_y_num = 1'b0;
        display_score = 1'b0;
        display_time = 1'b0;
        enable_x_adder_num = 1'b0;
        enable_y_adder_num =1'b0;
        enable_num_pixel_counter = 1'b0;
        resetn_num_pixel_counter = 1'b1;
        resetn_decimal_counter =1'b1;
        writeEn = 1'b0;
        display_score_and_time_done = 1'b0;

        case (current_state)
            S_START: begin
                //pass
            end

            S_DRAW_SCORE: begin
                display_score = 1'b1;
            end

            S_DRAW_SCORE_WAIT:begin
                load_x_num = 1'b1;
                load_y_num = 1'b1;
            end

            S_DRAW_SCORE_BIT: begin
                enable_x_adder_num = 1'b1;
                enable_y_adder_num = 1'b1;
            end

            S_DRAW_SCORE_BIT_WAIT: begin
                writeEn = 1'b1;
            end

            S_DRAW_SCORE_BIT_DONE: begin
                resetn_num_pixel_counter = 1'b0;
                decimal_bit_count_enable = 1'b1;
            end

            S_DRAW_TIME: begin
              resetn_decimal_counter = 1'b0;
              display_time = 1'b1;
            end

            S_DRAW_TIME_WAIT:begin
                load_x_num = 1'b1;
                load_y_num = 1'b1;
            end
            
            S_DRAW_TIME_BIT: begin
                enable_x_adder_num = 1'b1;
                enable_y_adder_num = 1'b1;
            end
            
            S_DRAW_TIME_BIT_WAIT: begin
                writeEn = 1'b1;
            end

            S_DRAW_TIME_BIT_DONE: begin
                resetn_num_pixel_counter = 1'b0;
                decimal_bit_count_enable = 1'b1;
            end

            S_DRAW_DONE: begin
                display_score_and_time_done = 1'b1;
            end

        endcase
    end

endmodule