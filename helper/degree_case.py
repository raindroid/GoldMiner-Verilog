from math import *
if __name__ == "__main__":
    print("""
module trig(
    input [8:0] degree,

    output reg [8:0]cos, sin,
    output reg signCos, signSin
);
    wire [8:0] sub_deg;
    assign sub_deg = degree >> 1;

    always @(*) begin
        case (degree)""")

    step = 2

    deg = [t for t in range(0, 360, step)]
    x = [int(256 * cos(t / 180 * pi)) for t in range(0, 360, step)]
    y = [int(256 * sin(t / 180 * pi)) for t in range(0, 360, step)]

    for a in range(len(deg)):
        # print('\t\trdegree[%d:%d] \t= 10\'d%3d;' % (1799 - a * 9, 1790 - a * 9, deg[a]), sep = '')
        print("\t%d: begin" % (deg[a] >> 1))
        print('\t\tcos\t= 9\'d%3d;' % ( abs(x[a])), sep='')
        print('\t\tsin\t= 9\'d%3d;' % ( abs(y[a])), sep='')
        print('\t\tsignCos\t= 1\'b%4d;' % ( 0 if x[a] < 0 else 1), sep='')
        print('\t\tsignSin\t= 1\'b%4d;' % ( 0 if y[a] < 0 else 1), sep='')
        print("\tend")

    print("""

	default: begin
		cos	= 9'd128;
		sin	= 9'd  0;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	
    endcase

    end

endmodule // trig""")