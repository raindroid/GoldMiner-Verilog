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
    goal,
    enable_score_and_time_display,

    outX,
    outY,
    color,
    writeEn,

    display_score_and_time_done
    );

    input clk, resetn;
    input [11:0]score_to_display, goal;
    input [11:0]time_remained;
	input enable_score_and_time_display;

    output reg[8:0]outX;
    output reg[7:0]outY;
    output reg[11:0]color;
    output reg writeEn;

    output reg display_score_and_time_done;

    reg decimal_bit_count_enable,
         load_x_num,
         load_y_num,
         display_score,
         display_time,
		 display_goal,
         enable_x_adder_num,
         enable_y_adder_num,
         enable_num_pixel_counter,
         resetn_num_pixel_counter,
         resetn_decimal_counter;
   

    localparam score_x_start = 9'd80; //to 60
    localparam score_y_start = 8'd10;
    localparam time_x_start = 9'd80; //to 80
    localparam time_y_start = 8'd33;
    localparam goal_x_start = 9'd80; //to 60
    localparam goal_y_start = 8'd17;


    wire [11:0] num0_color;
    wire [11:0] num1_color;
    wire [11:0] num2_color;
    wire [11:0] num3_color;
    wire [11:0] num4_color;
    wire [11:0] num5_color;
    wire [11:0] num6_color;
    wire [11:0] num7_color;
    wire [11:0] num8_color;
    wire [11:0] num9_color;


    wire [3:0] time_one;
    wire [3:0] time_ten;
    wire [3:0] time_hun;
    wire [2:0] time_tho;
    wire [3:0] score_one;
    wire [3:0] score_ten;
    wire [3:0] score_hun;
    wire [2:0] score_tho;
    wire [3:0] goal_one;
    wire [3:0] goal_ten;
    wire [3:0] goal_hun;
    wire [2:0] goal_tho;
    wire dec_done_time, dec_done_score, dec_done_goal;
    
    reg dec_done;

    reg [5:0]num_pixel;

    reg [8:0] x_init;
    reg [7:0] y_init;
    reg [1:0]decimal_bit_count;


    wire [4:0]num_mem_address = ({num_pixel[4:2], 2'd0} + {num_pixel[1:0]+1'b1});
    
    num0 num0(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num0_color)
    );
    
    num1 num1(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num1_color)
    );

    num2 num2(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num2_color)
    );

    num3 num3(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num3_color)
    );

    num4 num4(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num4_color)
    );

    num5 num5(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num5_color)
    );

    num6 num6(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num6_color)
    );

    num7 num7(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num7_color)
    );

    num8 num8(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num8_color)
    );

    num9 num9(
        .address(num_mem_address),
	    .clock(clk),
	    .q(num9_color)
    );

    
    always@(*)begin
        if(display_score)begin
            x_init <= score_x_start;
            y_init <= score_y_start;
        end 

        else if(display_goal)begin
            x_init <= goal_x_start;
            y_init <= goal_y_start;
        end 

        else if(display_time)begin
            x_init <= time_x_start;
            y_init <= time_y_start;
        end
    end

    
    //decimal bit counter
    always@(posedge clk)begin
        if(!resetn | !resetn_decimal_counter) decimal_bit_count = 1'b0;
        else if(decimal_bit_count_enable)
            decimal_bit_count <= decimal_bit_count +1'b1;
    end

    

    bin_dec time_bin_dec(
        .clk(clk),
        .bin(time_remained),
        .rst_n(resetn),
        .one(time_one),
        .ten(time_ten),
        .hun(time_hun),
        .tho(time_tho),
        .done(dec_done_time)
		  );

	bin_dec score_bin_dec(
        .clk(clk),
        .bin(score_to_display),
        .rst_n(resetn),
        .one(score_one),
        .ten(score_ten),
        .hun(score_hun),
        .tho(score_tho),
        .done(dec_done_score)
		);
    
    bin_dec goal_bin_dec(
        .clk(clk),
        .bin(goal),
        .rst_n(resetn),
        .one(goal_one),
        .ten(goal_ten),
        .hun(goal_hun),
        .tho(goal_tho),
        .done(dec_done_goal)
		);

    always@(*)begin
      if(dec_done_time & dec_done_score & dec_done_goal)
        dec_done = 1'b1;
        else 
            dec_done = 1'b0;
    end

    reg [2:0] time_bit;
    reg [2:0] score_bit;
    reg [2:0] goal_bit;

    always@(*)begin
        if(time_remained < 10) time_bit <= 1;
        else time_bit <= 2;
    end

    always@(*)begin
        if(score_to_display < 10) score_bit <= 3'd1;
        else if(score_to_display >= 10 & score_to_display <100) score_bit <= 3'd2;
        else if(score_to_display >= 100 & score_to_display <1000) score_bit <= 3'd3;
        else score_bit <= 3'd4;
    end

    always@(*)begin
        if(goal < 10) goal_bit <= 2'd1;
        else if(goal >= 10 & goal <100) goal_bit <= 3'd2;
        else if(goal >= 100 & goal <1000) goal_bit <= 3'd3;
        else goal_bit <= 3'd4;
    end


    always@(posedge clk) begin
        color = 12'b0;
        if(display_score) begin
            if(decimal_bit_count == 0)
            begin
                case(score_one)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            else if(decimal_bit_count == 1)
            begin
                case(score_ten)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            else if(decimal_bit_count == 2)
            begin
                case(score_hun)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            else if(decimal_bit_count == 3)
            begin
                case(score_tho)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            if(color == 12'hfff)
                color = 12'b1111_1100_0011;
        end
        
        if(display_goal) begin
            if(decimal_bit_count == 0)
            begin
                case(goal_one)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            else if(decimal_bit_count == 1)
            begin
                case(goal_ten)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            else if(decimal_bit_count == 2)
            begin
                case(goal_hun)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            else if(decimal_bit_count == 3)
            begin
                case(goal_tho)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
        end

        else if(display_time) begin
            if(decimal_bit_count == 0)
            begin
                case(time_one)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
            else if(decimal_bit_count == 1)
            begin
                case(time_ten)
                    4'd0: color = num0_color;
                    4'd1: color = num1_color;
                    4'd2: color = num1_color;
                    4'd3: color = num3_color;
                    4'd4: color = num4_color;
                    4'd5: color = num5_color;
                    4'd6: color = num6_color;
                    4'd7: color = num7_color;
                    4'd8: color = num8_color;
                    4'd9: color = num9_color;
                    default: color = 12'b0;
                endcase
            end
        end
    end
    
	 reg [8:0]x;
	 reg [7:0]y;
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
		if(resetn == 0) outX <= 9'b0;
		else
			if(enable_x_adder_num) begin
				outX <= x + num_pixel[1:0];
				end
	end
	
	//y_out adder
	always@(posedge clk)begin
		if(resetn == 0) outY <= 8'b0;
		else
			if(enable_y_adder_num)begin
				outY <= y + num_pixel[4:2];
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
	 reg [4:0] current_state, next_state; 

    localparam  S_START     =5'd0,  //Wait for enable signal
                S_DRAW_SCORE      =5'd1,  //initialize start position
                S_DRAW_SCORE_WAIT = 5'd2, //prepare to draw
                S_DRAW_SCORE_BIT=5'd3,  //Draw score bit
                S_DRAW_SCORE_BIT_WAIT = 5'd4,
                S_DRAW_SCORE_BIT_DONE=5'd5,  //Draw score bit done and reset bit counter
                S_DRAW_SCORE_BIT_DONE_CLEAR = 5'd6,

                S_DRAW_GOAL      =5'd7,  //initialize start position
                S_DRAW_GOAL_WAIT = 5'd8, //prepare to draw
                S_DRAW_GOAL_BIT=5'd9,  //Draw goal bit
                S_DRAW_GOAL_BIT_WAIT = 5'd10,
                S_DRAW_GOAL_BIT_DONE=5'd11,  //Draw goal bit done and reset bit counter
                S_DRAW_GOAL_BIT_DONE_CLEAR = 5'd12,

                S_DRAW_TIME = 5'd13, //initialize start postion
                S_DRAW_TIME_WAIT = 5'd14, //prepare to draw
                S_DRAW_TIME_BIT =5'd15,  //Draw time bit
                S_DRAW_TIME_BIT_WAIT = 5'd16,
                S_DRAW_TIME_BIT_DONE=5'd17,  //Draw time bit done and reset bit counter
                S_DRAW_DONE =5'd18;  //Finish and send done sig

    //state table
    always @(*) begin:
		stae_table
        case (current_state)
            S_START:        next_state = (enable_score_and_time_display) ? S_DRAW_SCORE : S_START;
            S_DRAW_SCORE:         next_state = (dec_done) ? S_DRAW_SCORE_WAIT : S_DRAW_SCORE;
            S_DRAW_SCORE_WAIT:   next_state = S_DRAW_SCORE_BIT;
            S_DRAW_SCORE_BIT:    next_state =  ( num_pixel == 6'd32) ? S_DRAW_SCORE_BIT_DONE : S_DRAW_SCORE_BIT_WAIT;
            S_DRAW_SCORE_BIT_WAIT : next_state = S_DRAW_SCORE_BIT;
            S_DRAW_SCORE_BIT_DONE: next_state = (decimal_bit_count == score_bit-1'b1)? S_DRAW_SCORE_BIT_DONE_CLEAR : S_DRAW_SCORE;
            S_DRAW_SCORE_BIT_DONE_CLEAR: next_state=S_DRAW_GOAL;

            S_DRAW_GOAL:         next_state = (dec_done) ? S_DRAW_GOAL_WAIT : S_DRAW_GOAL;
            S_DRAW_GOAL_WAIT:   next_state = S_DRAW_GOAL_BIT;
            S_DRAW_GOAL_BIT:    next_state =  ( num_pixel == 6'd32) ? S_DRAW_GOAL_BIT_DONE : S_DRAW_GOAL_BIT_WAIT;
            S_DRAW_GOAL_BIT_WAIT : next_state = S_DRAW_GOAL_BIT;
            S_DRAW_GOAL_BIT_DONE: next_state = (decimal_bit_count == goal_bit-1'b1)? S_DRAW_GOAL_BIT_DONE_CLEAR : S_DRAW_GOAL;
            S_DRAW_GOAL_BIT_DONE_CLEAR: next_state=S_DRAW_TIME;

            S_DRAW_TIME:    next_state = S_DRAW_TIME_WAIT;
            S_DRAW_TIME_WAIT: next_state = S_DRAW_TIME_BIT;
            S_DRAW_TIME_BIT:    next_state =  (num_pixel == 6'd32) ? S_DRAW_TIME_BIT_DONE : S_DRAW_TIME_BIT_WAIT;
            S_DRAW_TIME_BIT_WAIT: next_state = S_DRAW_TIME_BIT;
            S_DRAW_TIME_BIT_DONE: next_state = (decimal_bit_count == time_bit-1'b1) ? S_DRAW_DONE : S_DRAW_TIME;
            S_DRAW_DONE:    next_state = S_START;
          default: next_state = S_START;
        endcase      
    end
    
    //Logic
    always @(posedge clk) begin
        decimal_bit_count_enable = 1'b0;
        load_x_num = 1'b0;
        load_y_num = 1'b0;
        display_score = 1'b0;
        display_time = 1'b0;
        display_goal = 1'b0;
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
                load_x_num = 1'b1;
                load_y_num = 1'b1;
            end

            S_DRAW_SCORE_WAIT:begin
                
                display_score = 1'b1;
            end

            S_DRAW_SCORE_BIT: begin
                enable_x_adder_num = 1'b1;
                enable_y_adder_num = 1'b1;
                enable_num_pixel_counter = 1'b1;
                display_score = 1'b1;
            end

            S_DRAW_SCORE_BIT_WAIT: begin
                writeEn = 1'b1;
            end

            S_DRAW_SCORE_BIT_DONE: begin
                
                decimal_bit_count_enable = 1'b1;
                resetn_num_pixel_counter = 1'b0;
                display_score = 1'b1;
            end

            S_DRAW_SCORE_BIT_DONE_CLEAR: begin
                resetn_decimal_counter = 1'b0;
            end
            

            S_DRAW_GOAL: begin
                display_goal = 1'b1;
                load_x_num = 1'b1;
                load_y_num = 1'b1;
            end

            S_DRAW_GOAL_WAIT:begin
                
                display_goal = 1'b1;
            end

            S_DRAW_GOAL_BIT: begin
                enable_x_adder_num = 1'b1;
                enable_y_adder_num = 1'b1;
                enable_num_pixel_counter = 1'b1;
                display_goal = 1'b1;
            end

            S_DRAW_GOAL_BIT_WAIT: begin
                writeEn = 1'b1;
            end

            S_DRAW_GOAL_BIT_DONE: begin
                
                decimal_bit_count_enable = 1'b1;
                resetn_num_pixel_counter = 1'b0;
                display_goal = 1'b1;
            end

            S_DRAW_SCORE_BIT_DONE_CLEAR: begin
                resetn_decimal_counter = 1'b0;
            end


            S_DRAW_TIME: begin
              display_time = 1'b1;
              load_x_num = 1'b1;
              load_y_num = 1'b1;
            end

            S_DRAW_TIME_WAIT:begin
                display_time = 1'b1;
            end
            
            S_DRAW_TIME_BIT: begin
                display_time = 1'b1;
                enable_x_adder_num = 1'b1;
                enable_y_adder_num = 1'b1;
                enable_num_pixel_counter = 1'b1;
            end
            
            S_DRAW_TIME_BIT_WAIT: begin
                display_time = 1'b1;
                writeEn = 1'b1;
            end

            S_DRAW_TIME_BIT_DONE: begin
                display_time = 1'b1;
                resetn_num_pixel_counter = 1'b0;
                decimal_bit_count_enable = 1'b1;
            end

            S_DRAW_DONE: begin
                resetn_decimal_counter = 1'b0;
                display_score_and_time_done = 1'b1;
            end

        endcase
    end
	 
	 // current_state registers
	 always@(posedge clk)
    begin: state_FFs
        if(resetn == 0)
            current_state <= S_START;
        else
            current_state <= next_state;
    end // state_FFS

endmodule