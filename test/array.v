module array_test(
    input clock, resetn
);
reg [31:0] x[127:0];
// For loop with arrays
integer index;
always @(posedge clock, negedge resetn) begin
  if (!resetn) begin
    // reset arrayb
    for (index=0; index<256; index=index+1) begin
      x[index] <= 8'h00;
    end
  end
  else begin
    for (index=0; index<256; index=index+1) begin
      x[index] <= x[index] + 1;
    end
  end
end
endmodule // array_test