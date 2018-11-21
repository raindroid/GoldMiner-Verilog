from math import *

if __name__ == "__main__":

    print("""
//To access data (signX[degree/2] ? -1 : 1) * absX[degree / 2 * 10 + 9 : degree / 2 * 10] / 100
module trigonometry(
    input clock, enable,
    output [1799: 0] absX, absY,
    output [179:0] signX, signY
);

wire [1799: 0] rx, ry;
wire [180:0] rsx, rsy;
assign absX = rx;
assign absY = ry;
assign signX = rsx;
assign signY = rsy;

always @(posedge clock) begin
    if (enable) begin //start init our big big table

""")
    step = 2

    deg = [t for t in range(0, 360, step)]
    x = [int(100 * cos(t / 180 * pi)) for t in range(358, -2, -step)]
    y = [int(100 * sin(t / 180 * pi)) for t in range(358, -2, -step)]

    for a in range(len(deg)):
        # print('\t\trdegree[%d:%d] \t= 10\'d%3d;' % (1799 - a * 9, 1790 - a * 9, deg[a]), sep = '')
        print('\t\trx[%d:%d]\t= 10\'d%3d;' % (1799 - a * 10, 1790 - a * 10, abs(x[a])), sep='')
        print('\t\try[%d:%d]\t= 10\'d%3d;' % (1799 - a * 10, 1790 - a * 10, abs(y[a])), sep='')
        print('\t\trsx[%d]  \t= 1\'b%4d;' % (179 - a, 0 if (abs(x[a]+0.1)/(x[a]+0.1) == 1) else 1), sep='')
        print('\t\trsy[%d]  \t= 1\'b%4d;' % (179 - a, 0 if (abs(y[a]+0.1)/(y[a]+0.1) == 1) else 1), sep='')

    print("""
    end
end
endmodule
""")
