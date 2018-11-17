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
    input [13:0]score_to_display;
    input [5:0]time_remained;

    output [8:0]outX,
    output [7:0]outY;
    output [11:0]color;
    output writeEn;

    output display_score_and_time_done;
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
    wire display_score;
    wire display_time;
    
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

    //decimal bit counter
    reg [3:0]decimal_bit_count;
    wire decimal_bit_count_enable;
    always@(posedge clk)begin
        if(!resetn | !reset_decimal_counter) decimal_bit_count = 1'b0;
        else if(decimal_bit_count_enable)
            decimal_bit_count <= decimal_bit_count +1'b1;
    end

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
		if((resetn == 0) | (resetn_num_counter == 0)) num_pixel <= 6'b0;
		else
			if(enable_numb)
			num_pixel <= num_pixel + 1'b1;
	end


    //FSM starts here

    localparam  S_START     =5'd0,  //Wait for enable signal
                S_DRAW      =5'd1,  //Prepare for drawing
                S_DRAW_SCORE=5'd2,  //Draw score
                S_DRAW_TIME =5'd3,  //Draw time
                S_DRAW_DONE =5'd4;  //Finish and send done sig

    //state table
    always @(*) begin
        case (current_state)
            S_START:        next_state = (enable) ? S_DRAW : S_START;
            S_DRAW:         next_state = S_DRAW_SCORE;
            S_DRAW_SCORE:    next_state = (length_counter == MAX_C) ?
                                        S_DRAW_TIME : S_DRAW_SCORE;
            S_DRAW_TIME:    next_state = (degree_counter == 64'd360) ?
                                        S_DRAW_DONE : S_DRAW_TIME;
            S_DRAW_DONE:    next_state = S_START;
          default: next_state = S_START;
        endcase      
    end
    
    //Logic
    always @(posedge clock) begin
        writeEn = 1'b0;
        done = 1'b0;

        case (current_state)
            S_START: begin
                //pass
            end
            S_DRAW: begin
                degree_counter <= 64'd0;
                length_counter <= 64'd0;
                
                centerX = START_X + length * deg_cos / 64'd100 * (deg_signCos ? 64'd1 : -64'd1);
                centerY = START_Y + length * deg_sin / 64'd100;
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
                
                 tempX = RADIUS * cos[8:0] / 64'd100;
                 outX = centerX[8:0] + tempX[8:0] * (signCos ? 64'd1 : -64'd1);
                   
                 tempY = RADIUS * sin[8:0] / 64'd100;
                 outY = centerY[7:0] + (signSin ? tempY[7:0] : -tempY[7:0]);

                if (degree_counter < degree | degree_counter > (degree + 40))
                    writeEn = 1'b1;
                else    
                    writeEn = 1'b0;

                degree_counter <= degree_counter + 5;
            end
            S_DRAW_DONE: begin
                LEDR[3] = 1'b0;
                done = 1'b1;
            end
        endcase
    end




endmodule