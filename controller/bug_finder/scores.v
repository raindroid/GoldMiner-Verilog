/**
 * This is the module for saving scores
 *
 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      writeEn
 *      plus
 *      [7:0] score_change_DATA
 *      
 *
 * PARAMETER:
 *
 * OUTPUT:
 *      score

 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 18, 2018
 * Last Updated: Nov 18, 2018, seems correct
 * Tested: pass the sims
 **/

module Score(
    input clock, resetn,
    input writeEn, plus,
    input [7:0] score_change_DATA,

    output reg [9:0] score
);

    always @(posedge clock) begin
        if (!resetn) begin
            score = 0;
        end
        else if (writeEn) begin
            score = score + (plus ? 64'd1 : -64'd1) * score_change_DATA;
        end
    end

endmodule // Scores