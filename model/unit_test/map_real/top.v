module top(
    input [9:0] SW,
    input [3:0] KEY,
    output [9:0] LEDR
    // input CLOCK_50
);
    wire [31:0] out;
    MapRam map(
        .clock(KEY[1]),
        .resetn(KEY[0]),
        .read_req_code(3'b1),
        .write_req_code(0),
        .address0(SW[3:0]),
        .address1(SW[3:0]),
        .address2(SW[3:0]),
        .write_data1(0),
        .write_data2(0),
        .data(out)
    );
    assign LEDR[9:0] = out[31:22];
endmodule // Top