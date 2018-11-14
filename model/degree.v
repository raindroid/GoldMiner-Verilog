module trig(
    input [8:0] degree,

    output reg [8:0]cos, sin,
    output reg signCos, signSin
);

    always @(*) begin
        case (degree)
	0: begin
		cos	= 9'd100;
		sin	= 9'd  0;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	5: begin
		cos	= 9'd 99;
		sin	= 9'd  8;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	10: begin
		cos	= 9'd 98;
		sin	= 9'd 17;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	15: begin
		cos	= 9'd 96;
		sin	= 9'd 25;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	20: begin
		cos	= 9'd 93;
		sin	= 9'd 34;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	25: begin
		cos	= 9'd 90;
		sin	= 9'd 42;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	30: begin
		cos	= 9'd 86;
		sin	= 9'd 49;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	35: begin
		cos	= 9'd 81;
		sin	= 9'd 57;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	40: begin
		cos	= 9'd 76;
		sin	= 9'd 64;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	45: begin
		cos	= 9'd 70;
		sin	= 9'd 70;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	50: begin
		cos	= 9'd 64;
		sin	= 9'd 76;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	55: begin
		cos	= 9'd 57;
		sin	= 9'd 81;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	60: begin
		cos	= 9'd 50;
		sin	= 9'd 86;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	65: begin
		cos	= 9'd 42;
		sin	= 9'd 90;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	70: begin
		cos	= 9'd 34;
		sin	= 9'd 93;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	75: begin
		cos	= 9'd 25;
		sin	= 9'd 96;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	80: begin
		cos	= 9'd 17;
		sin	= 9'd 98;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	85: begin
		cos	= 9'd  8;
		sin	= 9'd 99;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	90: begin
		cos	= 9'd  0;
		sin	= 9'd100;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	95: begin
		cos	= 9'd  8;
		sin	= 9'd 99;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	100: begin
		cos	= 9'd 17;
		sin	= 9'd 98;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	105: begin
		cos	= 9'd 25;
		sin	= 9'd 96;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	110: begin
		cos	= 9'd 34;
		sin	= 9'd 93;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	115: begin
		cos	= 9'd 42;
		sin	= 9'd 90;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	120: begin
		cos	= 9'd 49;
		sin	= 9'd 86;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	125: begin
		cos	= 9'd 57;
		sin	= 9'd 81;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	130: begin
		cos	= 9'd 64;
		sin	= 9'd 76;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	135: begin
		cos	= 9'd 70;
		sin	= 9'd 70;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	140: begin
		cos	= 9'd 76;
		sin	= 9'd 64;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	145: begin
		cos	= 9'd 81;
		sin	= 9'd 57;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	150: begin
		cos	= 9'd 86;
		sin	= 9'd 49;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	155: begin
		cos	= 9'd 90;
		sin	= 9'd 42;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	160: begin
		cos	= 9'd 93;
		sin	= 9'd 34;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	165: begin
		cos	= 9'd 96;
		sin	= 9'd 25;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	170: begin
		cos	= 9'd 98;
		sin	= 9'd 17;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	175: begin
		cos	= 9'd 99;
		sin	= 9'd  8;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	180: begin
		cos	= 9'd100;
		sin	= 9'd  0;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	185: begin
		cos	= 9'd 99;
		sin	= 9'd  8;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	190: begin
		cos	= 9'd 98;
		sin	= 9'd 17;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	195: begin
		cos	= 9'd 96;
		sin	= 9'd 25;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	200: begin
		cos	= 9'd 93;
		sin	= 9'd 34;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	205: begin
		cos	= 9'd 90;
		sin	= 9'd 42;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	210: begin
		cos	= 9'd 86;
		sin	= 9'd 50;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	215: begin
		cos	= 9'd 81;
		sin	= 9'd 57;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	220: begin
		cos	= 9'd 76;
		sin	= 9'd 64;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	225: begin
		cos	= 9'd 70;
		sin	= 9'd 70;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	230: begin
		cos	= 9'd 64;
		sin	= 9'd 76;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	235: begin
		cos	= 9'd 57;
		sin	= 9'd 81;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	240: begin
		cos	= 9'd 50;
		sin	= 9'd 86;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	245: begin
		cos	= 9'd 42;
		sin	= 9'd 90;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	250: begin
		cos	= 9'd 34;
		sin	= 9'd 93;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	255: begin
		cos	= 9'd 25;
		sin	= 9'd 96;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	260: begin
		cos	= 9'd 17;
		sin	= 9'd 98;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	265: begin
		cos	= 9'd  8;
		sin	= 9'd 99;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	270: begin
		cos	= 9'd  0;
		sin	= 9'd100;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	275: begin
		cos	= 9'd  8;
		sin	= 9'd 99;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	280: begin
		cos	= 9'd 17;
		sin	= 9'd 98;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	285: begin
		cos	= 9'd 25;
		sin	= 9'd 96;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	290: begin
		cos	= 9'd 34;
		sin	= 9'd 93;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	295: begin
		cos	= 9'd 42;
		sin	= 9'd 90;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	300: begin
		cos	= 9'd 50;
		sin	= 9'd 86;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	305: begin
		cos	= 9'd 57;
		sin	= 9'd 81;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	310: begin
		cos	= 9'd 64;
		sin	= 9'd 76;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	315: begin
		cos	= 9'd 70;
		sin	= 9'd 70;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	320: begin
		cos	= 9'd 76;
		sin	= 9'd 64;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	325: begin
		cos	= 9'd 81;
		sin	= 9'd 57;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	330: begin
		cos	= 9'd 86;
		sin	= 9'd 50;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	335: begin
		cos	= 9'd 90;
		sin	= 9'd 42;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	340: begin
		cos	= 9'd 93;
		sin	= 9'd 34;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	345: begin
		cos	= 9'd 96;
		sin	= 9'd 25;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	350: begin
		cos	= 9'd 98;
		sin	= 9'd 17;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	355: begin
		cos	= 9'd 99;
		sin	= 9'd  8;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end

    default: begin
		cos	= 9'd  0;
		sin	= 9'd100;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end

    endcase

    end

endmodule // trig
