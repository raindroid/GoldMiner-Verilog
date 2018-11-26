module top(
    input [9:0] SW,
    input [3:0] KEY,
    output [9:0] LEDR,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    wire [9:0] deg, rope_len;
    Rope rope(
        .clock(~KEY[1]), 
        .resetn(~KEY[0]), 
        .enable(1),
        .draw_stone_flag(0), //on when the previous drawing is in process
        .draw_index(0),
        .quantity(1),

        .go_KEY(~KEY[3]), //physical key for the go input
        //bomb_KEY,
        // input bomb_quantity,

        .degree(deg), //not all the output is useful
        .rope_len(rope_len),

        //output [9:0] current_score,

        //Test only
        .LEDR(LEDR),
        .HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
        // output bomb_use

    );
endmodule // top

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
