/**
 * This is the module for saving bombs
 *
 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      buy
 *      used //avoid duplication of name `use`
 *
 * PARAMETER:
 *
 * OUTPUT:
 *      quantity

 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 18, 2018
 * Last Updated: Nov 18, 2018, seems correct
 * Tested: pass the sims
 **/

 module Bomb(
    input clock, resetn,
    input buy, used,
    output reg [7:0] quantity
 );

    always @(posedge clock) begin
        if (!resetn) begin
            quantity = 0;
        end
        else if (buy) begin
            quantity = quantity + 1;
        end
        else if (used) begin
            quantity = quantity - 1;
        end
    end
 
 endmodule // Bomb