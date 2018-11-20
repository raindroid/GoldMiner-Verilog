/**
 *  This module test the function of mod rand

 *  Requires: item_generator.v
 **/

module project_test(
    input [3:0] KEY,
    output [9:0] LEDR
);

    wire clock, resetn, enable;
    wire [8:0] out;

    assign clock = KEY[0];
    assign resetn = KEY[1];
    assign enable = KEY[2];
    assign LEDR = {1'b0, out};

    Rand test_r(
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .out(out)
    );

endmodule