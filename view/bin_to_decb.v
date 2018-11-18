/*
This module will separate the number in to decimal bits for the convenience of number display
Input: clk
       rst_n
Output: tho
        hun
        ten
        one
        done

External resource found at https://blog.csdn.net/li200503028/article/details/19507061
originally created by stubben_bear
for design purpose the input bit are extended to 12 bits
modified by Yifan Cui
*/


module bin_dec(clk,bin,rst_n,one,ten,hun,tho,done
);
input [11:0] bin;
input clk,rst_n;
output [3:0] one,ten,hun;
output [2:0] tho;
output reg done;
reg [3:0] one,ten,hun;
reg [2:0] tho;
reg [3:0] count;
reg [26:0]shift_reg=27'b000_0000_0000_0000_0000_0000_0000;
////////////////////// counters ////////////////////////
always @ ( posedge clk or negedge rst_n )
begin
 if( !rst_n ) 
	count<=0;
else if (count==13)
	count<=0;
else
	count<=count+1'b1;
end

////////////////////// binary to decimal /////////////////
always @ (posedge clk or negedge rst_n )
begin
	if (!rst_n)
		shift_reg=0;
	else if (count==0)
		shift_reg={15'b000_0000_0000_0000,bin};
	else if ( count<=13) //shift 8times
		begin
			if(shift_reg[15:12]>=5)//check if >5，if yes +3 
			begin
				if(shift_reg[19:16]>=5) //check if the 10's bit >5，if yes +3 
						if(shift_reg[23:20]>=5)begin //check if the 100's bit >5，if yes +3 
							 shift_reg[23:20]=shift_reg[23:20]+2'b11;
							 shift_reg[19:16]=shift_reg[19:16]+2'b11;
							 shift_reg[15:12]=shift_reg[15:12]+2'b11;
							 shift_reg=shift_reg<<1; //after finishing 100's bit, 10's bit and 1's bit，shift left
						end
						else begin
							 shift_reg[23:20]=shift_reg[23:20];
							 shift_reg[19:16]=shift_reg[19:16]+2'b11;
							 shift_reg[15:12]=shift_reg[15:12]+2'b11;
							 shift_reg=shift_reg<<1; //after finishing 10's bit and 1's bit，shift left
						end
				else begin
						if(shift_reg[23:20]>=5)begin
							 shift_reg[23:20]=shift_reg[23:20]+2'b11;
							 shift_reg[19:16]=shift_reg[19:16];
							 shift_reg[15:12]=shift_reg[15:12]+2'b11;
							 shift_reg=shift_reg<<1;
						end
				end
			end
			else
			begin
				if(shift_reg[19:16]>=5) //check if the 10's bit >5，if yes +3 
						if(shift_reg[23:20]>=5)
							begin //check if the 100's bit >5，if yes +3 
							 shift_reg[23:20]=shift_reg[23:20]+2'b11;
							 shift_reg[19:16]=shift_reg[19:16]+2'b11;
							 shift_reg[15:12]=shift_reg[15:12];
							 shift_reg=shift_reg<<1; //after finishing 100's bit, 10's bit and 1's bit，shift left
							end
						else 
							begin
							 shift_reg[23:20]=shift_reg[23:20];
							 shift_reg[19:16]=shift_reg[19:16]+2'b11;
							 shift_reg[15:12]=shift_reg[15:12];
							 shift_reg=shift_reg<<1; //after finishing 10's bit and 1's bit，shift left
							end
				 else 
					begin
						if(shift_reg[23:20]>=5)begin
							 shift_reg[23:20]=shift_reg[23:20]+2'b11;
							 shift_reg[19:16]=shift_reg[19:16];
							 shift_reg[15:12]=shift_reg[15:12];
							 shift_reg=shift_reg<<1;
						end
					end
			end
		end
end

/////////////////outputs//////////////////////////
always @ ( posedge clk or negedge rst_n )
begin
	if( !rst_n )
		begin
		one<=0;
		ten<=0;
		hun<=0;
      tho<=0;
      done = 1'b0;
		end
	else if (count==13)	//finish shifting, set 100's, 10's, and 1's
		begin
		one<=shift_reg[15:12];
		ten<=shift_reg[19:16];
		hun<=shift_reg[23:20];
      tho<=shift_reg[26:24];
      done = 1'b1;
	   end
end
endmodule
