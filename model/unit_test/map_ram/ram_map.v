/** 
 *  This Module controls the data of map
 *  
 *  INPUT:
 *      read_req_code
 *      write_req_code
 *          [2:0] each
 *          format: {player2_req, player1_req, draw_req} each with 1 bit
 *          priority: draw_req > player1_req > player2_req
 *          NOTE: draw_req is not allowed to write any data
 *      address0
 *      address1
 *      address2
 *          [3:0] each
 *          address0 - draw_address
 *          address1 - player1_rope_index
 *          address2 - player2_rope_index
 *      write_data
 *          [31:0]
 *
 *  OUTPUT:
 *      read_data_done
 *      write_data_done
 *          reg [2:0] each
 *          format, priority, NOTE: see above "req_code"
 *          NOTE2: only 1 of 6 bits can be 1 in one clock
 *      data
 *          wire [31:0]
 **/

module initialize_1(
    input [3:0] address,
    input clock, resetn,
    input [31:0]data,
    input wren,
    output reg [31:0] q
);
    reg [31:0]rdata;
    always @(posedge clock) begin
        if (!resetn) begin
            rdata = 0;
        end
        else if (!wren) begin
            q <= rdata;
        end
        else begin
            
            rdata <= data;
            q <= data;
        end
    end

endmodule // 

module MapRam(
    input clock, resetn, enable,
    input [2:0] read_req_code, write_req_code,

    input [3:0] address0, address1, address2,
    input [31:0] write_data1, write_data2,

    output reg [2:0] read_data_done, write_data_done,
    output [31:0] data
 );
    
    reg [3:0] address;
    
    reg writeEn;
    reg [31:0] write_data;
    
    //I dont know the name right now
    initialize_1 map(
        .resetn(resetn),
        .address(address),
        .clock(clock),
        .data(write_data),
        .wren(writeEn),
        .q(data)
    );

    reg [5:0] current_state, next_state;

    localparam  S_START         = 6'd    0,
                S_FUNC_SEL      = 6'd    1,
                S_READ_REQ_0_R  = 6'd    3,
                S_WRITE_REQ_1_R = 6'd    5,
                S_WRITE_REQ_2_R = 6'd    7,
                S_READ_REQ_1_R  = 6'd    9,
                S_READ_REQ_2_R  = 6'd   11;
    
    always @(posedge clock) begin
        writeEn = 0;
        read_data_done = 0;
        write_data_done = 0;
        case (current_state)
            S_START: begin
                next_state = S_FUNC_SEL;
            end 
            S_FUNC_SEL: begin
                if (read_req_code[0]) begin
                    address = address0;
                    next_state = S_READ_REQ_0_R;
                end
                else if (write_req_code[1]) begin
                    address = address1;
                    writeEn = 1;
                    write_data = write_data1;
                    next_state = S_WRITE_REQ_1_R;
                end
                else if (write_req_code[2]) begin
                    address = address2;
                    writeEn = 1;
                    write_data = write_data2;
                    next_state = S_WRITE_REQ_2_R;
                end
                else if (read_req_code[1]) begin
                    address = address1;
                    next_state = S_READ_REQ_1_R;
                end
                else if (read_req_code[2]) begin
                    address = address2;
                    next_state = S_READ_REQ_2_R;
                end
                else begin
                    next_state = S_FUNC_SEL;
                end
            end
            S_READ_REQ_0_R: begin
                read_data_done[0] = 1;
                next_state = S_START;
            end
            S_WRITE_REQ_1_R: begin
                write_data_done[1] = 1;
                next_state = S_START;
            end
            S_WRITE_REQ_2_R: begin
                write_data_done[2] = 1;
                next_state = S_START;
            end
            S_READ_REQ_1_R: begin
                read_data_done[1] = 1;
                next_state = S_START;
            end
            S_READ_REQ_2_R: begin
                read_data_done[2] = 1;
                next_state = S_START;
            end
        endcase
    end

    always @(posedge clock) begin
        if (!resetn)
            current_state = S_START;
        else
            current_state = next_state;
    end
    
endmodule // MapRam
