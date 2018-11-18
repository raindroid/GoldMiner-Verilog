/*
This module will separate the number in to decimal bits for the convenience of number display
Input: clk
       rst_n
Output: hun
        ten
        one

External resource found at https://blog.csdn.net/li200503028/article/details/19507061
originally created by stubben_bear

*/


module bin_dec(clk,bin,rst_n,one,ten,hun
    );
input  [7:0] bin;
input        clk,rst_n;
output [3:0] one,ten;
output [1:0] hun;
reg    [3:0] one,ten;
reg    [1:0] hun;
reg    [3:0] count;
reg    [17:0]shift_reg=18'b000000000000000000;
////////////////////// counters ////////////////////////
always @ ( posedge clk or negedge rst_n )
begin
 if( !rst_n ) 
   count<=0;
 else if (count==9)
   count<=0;
 else
   count<=count+1;
end

////////////////////// binary to decimal /////////////////
always @ (posedge clk or negedge rst_n )
begin
  if (!rst_n)
       shift_reg=0;
  else if (count==0)
       shift_reg={10'b0000000000,bin};
  else if ( count<=8)                //shift 8times
   begin
      if(shift_reg[11:8]>=5)         //check if >5，if yes +3  
          begin
             if(shift_reg[15:12]>=5) //check if the 10's bit >5，if yes +3  
                 begin
                    shift_reg[15:12]=shift_reg[15:12]+2'b11;   
                    shift_reg[11:8]=shift_reg[11:8]+2'b11;
                    shift_reg=shift_reg<<1;  //after finish 10's bit and 1's bit，shift left
                end
             else
                begin
                shift_reg[15:12]=shift_reg[15:12];
                shift_reg[11:8]=shift_reg[11:8]+2'b11;
                shift_reg=shift_reg<<1;
                end
          end              
      else
          begin
             if(shift_reg[15:12]>=5)
                 begin
                    shift_reg[15:12]=shift_reg[15:12]+2'b11;
                    shift_reg[11:8]=shift_reg[11:8];
                    shift_reg=shift_reg<<1;
                end
             else
                begin
                    shift_reg[15:12]=shift_reg[15:12];
                    shift_reg[11:8]=shift_reg[11:8];
                    shift_reg=shift_reg<<1;
                end
          end        
    end
  end

/////////////////outputs//////////////////////////
always @ ( posedge clk or negedge rst_n )
begin
 if ( !rst_n )
  begin
    one<=0;
    ten<=0;
    hun<=0; 
  end
 else if (count==9)  //finish shifting, set 100's, 10's, and 1's
  begin
    one<=shift_reg[11:8];
    ten<=shift_reg[15:12];
    hun<=shift_reg[17:16]; 
  end
end
endmodule
