module audio(
	input [9:0]SW,
	input               resetn,
	input               clk,
	input               enable,
	input				AUD_ADCDAT,

	// Bidirectionals
	inout				AUD_BCLK,
	inout				AUD_ADCLRCK,
	inout				AUD_DACLRCK,

	inout				FPGA_I2C_SDAT,

	// Outputs
	output				AUD_XCK,
	output				AUD_DACDAT,

	output				FPGA_I2C_SCLK
);

	//Audio
	reg [6:0]sound_address;
	wire [2:0]sound_sample;
	audio_test aduio_test0(
		.address(sound_address),
		.clock(clk),
		.q(sound_sample)
	);

	reg [4:0]current_state, next_state;
	
	//fsm
	localparam  S_START = 5'd0,
				S_LOAD = 5'd1,
				S_DONE = 5'd2;

	always@(posedge clk)begin

		case(current_state)

			S_START: begin
				sound_address = 0;
				next_state = (enable) ? S_LOAD : S_START;
			end

			S_LOAD: begin
				if(sound_address <= 99)begin
			    	sound_address = sound_address + 1'b1;
					next_state = S_LOAD;
					end
				else begin
					sound_address = 0;
					next_state = S_DONE;
				end

			end

			S_DONE:begin
			  	next_state = S_START;
			end

			default: next_state = S_START;
			endcase
	end


	always @(posedge clk) begin
        if (!resetn) begin
            current_state <= S_START;
        end            
        else begin
            current_state <= next_state;
        end
    end


	

		// Internal Wires
	wire				audio_in_available;
	wire		[31:0]	left_channel_audio_in;
	wire		[31:0]	right_channel_audio_in;
	wire				read_audio_in;

	wire				audio_out_allowed;
	wire		[31:0]	left_channel_audio_out;
	wire		[31:0]	right_channel_audio_out;
	wire				write_audio_out;

	// Internal Registers

	reg [18:0] delay_cnt;
	wire [18:0] delay;

	reg snd;

	localparam 	do = 3'd1,
				mi = 3'd2,
				so = 3'd3,
				do_high = 3'd4;
	wire [2:0]input_note; // change to input later !
	assign input_note[2:0] = SW[2:0];
	reg [7:0]delay_8_bit;
	always @(posedge clk)begin
		case(input_note)
			do: begin
				delay_8_bit = 8'b01011101;
			end

			mi: begin
				delay_8_bit = 8'b01001001;
			end

			so: begin
				delay_8_bit = 8'b00111110;
			end

			do_high: begin
				delay_8_bit = 8'b00101110;
			end

			default: delay_8_bit = 0;
		endcase
	end


	always @(posedge clk)
		if(delay_cnt == delay) begin
			delay_cnt <= 0;
			snd <= !snd;
		end
		else delay_cnt <= delay_cnt + 1;

	assign delay = {delay_8_bit, 11'd0};

	wire [31:0] sound = (delay_8_bit == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;


	assign read_audio_in			= audio_in_available & audio_out_allowed;

	assign left_channel_audio_out	= left_channel_audio_in+sound;
	assign right_channel_audio_out	= right_channel_audio_in+sound;
	assign write_audio_out			= audio_in_available & audio_out_allowed;

	Audio_Controller Audio_Controller (
		// Inputs
		.CLOCK_50					(clk),
		.reset						(~resetn),

		.clear_audio_in_memory		(),
		.read_audio_in				(read_audio_in),
		
		.clear_audio_out_memory		(),
		.left_channel_audio_out		(left_channel_audio_out),
		.right_channel_audio_out	(right_channel_audio_out),
		.write_audio_out			(write_audio_out),

		.AUD_ADCDAT					(AUD_ADCDAT),

		// Bidirectionals
		.AUD_BCLK					(AUD_BCLK),
		.AUD_ADCLRCK				(AUD_ADCLRCK),
		.AUD_DACLRCK				(AUD_DACLRCK),


		// Outputs
		.audio_in_available			(audio_in_available),
		.left_channel_audio_in		(left_channel_audio_in),
		.right_channel_audio_in		(right_channel_audio_in),

		.audio_out_allowed			(audio_out_allowed),

		.AUD_XCK					(AUD_XCK),
		.AUD_DACDAT					(AUD_DACDAT)

	);

	avconf #(.USE_MIC_INPUT(1)) avc (
		.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
		.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
		.CLOCK_50					(clk),
		.reset						(~resetn)
	);
endmodule