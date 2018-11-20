//Need to use as (cos >> 8)

module trig(
    input [8:0] degree,

    output reg [8:0]cos, sin,
    output reg signCos, signSin
);
    wire [8:0] sub_deg;
    assign sub_deg = degree >> 1;

    always @(*) begin
        case (degree)
	0: begin
		cos	= 9'd256;
		sin	= 9'd  0;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	1: begin
		cos	= 9'd255;
		sin	= 9'd  8;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	2: begin
		cos	= 9'd255;
		sin	= 9'd 17;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	3: begin
		cos	= 9'd254;
		sin	= 9'd 26;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	4: begin
		cos	= 9'd253;
		sin	= 9'd 35;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	5: begin
		cos	= 9'd252;
		sin	= 9'd 44;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	6: begin
		cos	= 9'd250;
		sin	= 9'd 53;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	7: begin
		cos	= 9'd248;
		sin	= 9'd 61;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	8: begin
		cos	= 9'd246;
		sin	= 9'd 70;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	9: begin
		cos	= 9'd243;
		sin	= 9'd 79;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	10: begin
		cos	= 9'd240;
		sin	= 9'd 87;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	11: begin
		cos	= 9'd237;
		sin	= 9'd 95;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	12: begin
		cos	= 9'd233;
		sin	= 9'd104;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	13: begin
		cos	= 9'd230;
		sin	= 9'd112;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	14: begin
		cos	= 9'd226;
		sin	= 9'd120;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	15: begin
		cos	= 9'd221;
		sin	= 9'd127;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	16: begin
		cos	= 9'd217;
		sin	= 9'd135;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	17: begin
		cos	= 9'd212;
		sin	= 9'd143;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	18: begin
		cos	= 9'd207;
		sin	= 9'd150;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	19: begin
		cos	= 9'd201;
		sin	= 9'd157;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	20: begin
		cos	= 9'd196;
		sin	= 9'd164;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	21: begin
		cos	= 9'd190;
		sin	= 9'd171;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	22: begin
		cos	= 9'd184;
		sin	= 9'd177;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	23: begin
		cos	= 9'd177;
		sin	= 9'd184;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	24: begin
		cos	= 9'd171;
		sin	= 9'd190;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	25: begin
		cos	= 9'd164;
		sin	= 9'd196;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	26: begin
		cos	= 9'd157;
		sin	= 9'd201;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	27: begin
		cos	= 9'd150;
		sin	= 9'd207;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	28: begin
		cos	= 9'd143;
		sin	= 9'd212;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	29: begin
		cos	= 9'd135;
		sin	= 9'd217;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	30: begin
		cos	= 9'd128;
		sin	= 9'd221;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	31: begin
		cos	= 9'd120;
		sin	= 9'd226;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	32: begin
		cos	= 9'd112;
		sin	= 9'd230;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	33: begin
		cos	= 9'd104;
		sin	= 9'd233;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	34: begin
		cos	= 9'd 95;
		sin	= 9'd237;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	35: begin
		cos	= 9'd 87;
		sin	= 9'd240;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	36: begin
		cos	= 9'd 79;
		sin	= 9'd243;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	37: begin
		cos	= 9'd 70;
		sin	= 9'd246;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	38: begin
		cos	= 9'd 61;
		sin	= 9'd248;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	39: begin
		cos	= 9'd 53;
		sin	= 9'd250;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	40: begin
		cos	= 9'd 44;
		sin	= 9'd252;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	41: begin
		cos	= 9'd 35;
		sin	= 9'd253;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	42: begin
		cos	= 9'd 26;
		sin	= 9'd254;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	43: begin
		cos	= 9'd 17;
		sin	= 9'd255;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	44: begin
		cos	= 9'd  8;
		sin	= 9'd255;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	45: begin
		cos	= 9'd  0;
		sin	= 9'd256;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	46: begin
		cos	= 9'd  8;
		sin	= 9'd255;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	47: begin
		cos	= 9'd 17;
		sin	= 9'd255;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	48: begin
		cos	= 9'd 26;
		sin	= 9'd254;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	49: begin
		cos	= 9'd 35;
		sin	= 9'd253;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	50: begin
		cos	= 9'd 44;
		sin	= 9'd252;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	51: begin
		cos	= 9'd 53;
		sin	= 9'd250;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	52: begin
		cos	= 9'd 61;
		sin	= 9'd248;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	53: begin
		cos	= 9'd 70;
		sin	= 9'd246;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	54: begin
		cos	= 9'd 79;
		sin	= 9'd243;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	55: begin
		cos	= 9'd 87;
		sin	= 9'd240;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	56: begin
		cos	= 9'd 95;
		sin	= 9'd237;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	57: begin
		cos	= 9'd104;
		sin	= 9'd233;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	58: begin
		cos	= 9'd112;
		sin	= 9'd230;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	59: begin
		cos	= 9'd120;
		sin	= 9'd226;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	60: begin
		cos	= 9'd127;
		sin	= 9'd221;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	61: begin
		cos	= 9'd135;
		sin	= 9'd217;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	62: begin
		cos	= 9'd143;
		sin	= 9'd212;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	63: begin
		cos	= 9'd150;
		sin	= 9'd207;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	64: begin
		cos	= 9'd157;
		sin	= 9'd201;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	65: begin
		cos	= 9'd164;
		sin	= 9'd196;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	66: begin
		cos	= 9'd171;
		sin	= 9'd190;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	67: begin
		cos	= 9'd177;
		sin	= 9'd184;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	68: begin
		cos	= 9'd184;
		sin	= 9'd177;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	69: begin
		cos	= 9'd190;
		sin	= 9'd171;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	70: begin
		cos	= 9'd196;
		sin	= 9'd164;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	71: begin
		cos	= 9'd201;
		sin	= 9'd157;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	72: begin
		cos	= 9'd207;
		sin	= 9'd150;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	73: begin
		cos	= 9'd212;
		sin	= 9'd143;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	74: begin
		cos	= 9'd217;
		sin	= 9'd135;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	75: begin
		cos	= 9'd221;
		sin	= 9'd127;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	76: begin
		cos	= 9'd226;
		sin	= 9'd120;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	77: begin
		cos	= 9'd230;
		sin	= 9'd112;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	78: begin
		cos	= 9'd233;
		sin	= 9'd104;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	79: begin
		cos	= 9'd237;
		sin	= 9'd 95;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	80: begin
		cos	= 9'd240;
		sin	= 9'd 87;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	81: begin
		cos	= 9'd243;
		sin	= 9'd 79;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	82: begin
		cos	= 9'd246;
		sin	= 9'd 70;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	83: begin
		cos	= 9'd248;
		sin	= 9'd 61;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	84: begin
		cos	= 9'd250;
		sin	= 9'd 53;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	85: begin
		cos	= 9'd252;
		sin	= 9'd 44;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	86: begin
		cos	= 9'd253;
		sin	= 9'd 35;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	87: begin
		cos	= 9'd254;
		sin	= 9'd 26;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	88: begin
		cos	= 9'd255;
		sin	= 9'd 17;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	89: begin
		cos	= 9'd255;
		sin	= 9'd  8;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	90: begin
		cos	= 9'd256;
		sin	= 9'd  0;
		signCos	= 1'b   0;
		signSin	= 1'b   1;
	end
	91: begin
		cos	= 9'd255;
		sin	= 9'd  8;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	92: begin
		cos	= 9'd255;
		sin	= 9'd 17;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	93: begin
		cos	= 9'd254;
		sin	= 9'd 26;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	94: begin
		cos	= 9'd253;
		sin	= 9'd 35;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	95: begin
		cos	= 9'd252;
		sin	= 9'd 44;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	96: begin
		cos	= 9'd250;
		sin	= 9'd 53;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	97: begin
		cos	= 9'd248;
		sin	= 9'd 61;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	98: begin
		cos	= 9'd246;
		sin	= 9'd 70;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	99: begin
		cos	= 9'd243;
		sin	= 9'd 79;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	100: begin
		cos	= 9'd240;
		sin	= 9'd 87;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	101: begin
		cos	= 9'd237;
		sin	= 9'd 95;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	102: begin
		cos	= 9'd233;
		sin	= 9'd104;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	103: begin
		cos	= 9'd230;
		sin	= 9'd112;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	104: begin
		cos	= 9'd226;
		sin	= 9'd120;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	105: begin
		cos	= 9'd221;
		sin	= 9'd128;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	106: begin
		cos	= 9'd217;
		sin	= 9'd135;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	107: begin
		cos	= 9'd212;
		sin	= 9'd143;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	108: begin
		cos	= 9'd207;
		sin	= 9'd150;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	109: begin
		cos	= 9'd201;
		sin	= 9'd157;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	110: begin
		cos	= 9'd196;
		sin	= 9'd164;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	111: begin
		cos	= 9'd190;
		sin	= 9'd171;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	112: begin
		cos	= 9'd184;
		sin	= 9'd177;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	113: begin
		cos	= 9'd177;
		sin	= 9'd184;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	114: begin
		cos	= 9'd171;
		sin	= 9'd190;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	115: begin
		cos	= 9'd164;
		sin	= 9'd196;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	116: begin
		cos	= 9'd157;
		sin	= 9'd201;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	117: begin
		cos	= 9'd150;
		sin	= 9'd207;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	118: begin
		cos	= 9'd143;
		sin	= 9'd212;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	119: begin
		cos	= 9'd135;
		sin	= 9'd217;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	120: begin
		cos	= 9'd128;
		sin	= 9'd221;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	121: begin
		cos	= 9'd120;
		sin	= 9'd226;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	122: begin
		cos	= 9'd112;
		sin	= 9'd230;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	123: begin
		cos	= 9'd104;
		sin	= 9'd233;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	124: begin
		cos	= 9'd 95;
		sin	= 9'd237;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	125: begin
		cos	= 9'd 87;
		sin	= 9'd240;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	126: begin
		cos	= 9'd 79;
		sin	= 9'd243;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	127: begin
		cos	= 9'd 70;
		sin	= 9'd246;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	128: begin
		cos	= 9'd 61;
		sin	= 9'd248;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	129: begin
		cos	= 9'd 53;
		sin	= 9'd250;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	130: begin
		cos	= 9'd 44;
		sin	= 9'd252;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	131: begin
		cos	= 9'd 35;
		sin	= 9'd253;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	132: begin
		cos	= 9'd 26;
		sin	= 9'd254;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	133: begin
		cos	= 9'd 17;
		sin	= 9'd255;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	134: begin
		cos	= 9'd  8;
		sin	= 9'd255;
		signCos	= 1'b   0;
		signSin	= 1'b   0;
	end
	135: begin
		cos	= 9'd  0;
		sin	= 9'd256;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	136: begin
		cos	= 9'd  8;
		sin	= 9'd255;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	137: begin
		cos	= 9'd 17;
		sin	= 9'd255;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	138: begin
		cos	= 9'd 26;
		sin	= 9'd254;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	139: begin
		cos	= 9'd 35;
		sin	= 9'd253;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	140: begin
		cos	= 9'd 44;
		sin	= 9'd252;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	141: begin
		cos	= 9'd 53;
		sin	= 9'd250;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	142: begin
		cos	= 9'd 61;
		sin	= 9'd248;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	143: begin
		cos	= 9'd 70;
		sin	= 9'd246;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	144: begin
		cos	= 9'd 79;
		sin	= 9'd243;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	145: begin
		cos	= 9'd 87;
		sin	= 9'd240;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	146: begin
		cos	= 9'd 95;
		sin	= 9'd237;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	147: begin
		cos	= 9'd104;
		sin	= 9'd233;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	148: begin
		cos	= 9'd112;
		sin	= 9'd230;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	149: begin
		cos	= 9'd120;
		sin	= 9'd226;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	150: begin
		cos	= 9'd128;
		sin	= 9'd221;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	151: begin
		cos	= 9'd135;
		sin	= 9'd217;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	152: begin
		cos	= 9'd143;
		sin	= 9'd212;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	153: begin
		cos	= 9'd150;
		sin	= 9'd207;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	154: begin
		cos	= 9'd157;
		sin	= 9'd201;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	155: begin
		cos	= 9'd164;
		sin	= 9'd196;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	156: begin
		cos	= 9'd171;
		sin	= 9'd190;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	157: begin
		cos	= 9'd177;
		sin	= 9'd184;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	158: begin
		cos	= 9'd184;
		sin	= 9'd177;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	159: begin
		cos	= 9'd190;
		sin	= 9'd171;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	160: begin
		cos	= 9'd196;
		sin	= 9'd164;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	161: begin
		cos	= 9'd201;
		sin	= 9'd157;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	162: begin
		cos	= 9'd207;
		sin	= 9'd150;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	163: begin
		cos	= 9'd212;
		sin	= 9'd143;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	164: begin
		cos	= 9'd217;
		sin	= 9'd135;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	165: begin
		cos	= 9'd221;
		sin	= 9'd128;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	166: begin
		cos	= 9'd226;
		sin	= 9'd120;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	167: begin
		cos	= 9'd230;
		sin	= 9'd112;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	168: begin
		cos	= 9'd233;
		sin	= 9'd104;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	169: begin
		cos	= 9'd237;
		sin	= 9'd 95;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	170: begin
		cos	= 9'd240;
		sin	= 9'd 87;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	171: begin
		cos	= 9'd243;
		sin	= 9'd 79;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	172: begin
		cos	= 9'd246;
		sin	= 9'd 70;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	173: begin
		cos	= 9'd248;
		sin	= 9'd 61;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	174: begin
		cos	= 9'd250;
		sin	= 9'd 53;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	175: begin
		cos	= 9'd252;
		sin	= 9'd 44;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	176: begin
		cos	= 9'd253;
		sin	= 9'd 35;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	177: begin
		cos	= 9'd254;
		sin	= 9'd 26;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	178: begin
		cos	= 9'd255;
		sin	= 9'd 17;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end
	179: begin
		cos	= 9'd255;
		sin	= 9'd  8;
		signCos	= 1'b   1;
		signSin	= 1'b   0;
	end


	default: begin
		cos	= 9'd128;
		sin	= 9'd  0;
		signCos	= 1'b   1;
		signSin	= 1'b   1;
	end
	
    endcase

    end

endmodule // trig
