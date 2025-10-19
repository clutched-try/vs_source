module Det1011_MealyFSM #(
    parameter INIT = 2'b00,
    parameter GET_1 = 2'b01,
    parameter GET_10 = 2'b11,
    parameter GET_101 = 2'b10
)(
    input wire i_seq,
    input wire clk,
    input wire rst_n, // reset asyn active-low

    output reg o_det
);
    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= INIT;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
       case (state)
        INIT:     next_state = (i_seq) ? GET_1 : INIT;
        GET_1:    next_state = (!i_seq) ? GET_10 : GET_1;
        GET_10:   next_state = (i_seq) ? GET_101 : INIT;
        GET_101:  next_state = (i_seq) ? GET_1 : GET_10;
        default:  next_state = INIT;
       endcase
    end
    always @(*) begin
        case (state)
            INIT: o_det = 1'b0;
            GET_1: o_det = 1'b0;
            GET_10: o_det = 1'b0;
            GET_101: o_det = i_seq; 
            default: o_det = 1'b0;
        endcase 
    end
endmodule