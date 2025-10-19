module Det1011_MooreFSM #(
    parameter INIT = 3'b000,
    parameter GET_1 = 3'b101,
    parameter GET_10 = 3'b011,
    parameter GET_101 = 3'b111,
    parameter GET_1011 = 3'b001
)(
    input wire i_seq,
    input wire clk,
    input wire rst_n, // reset asyn active-low

    output wire o_det
);
    reg [2:0] state;
    reg [2:0] next_state;

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
        GET_101:  next_state = (i_seq) ? GET_1011 : GET_10;
        GET_1011: next_state = (!i_seq) ? GET_10 : GET_1;  
       endcase
    end
    assign o_det = (state == GET_1011) ? 1'b1 : 1'b0;
endmodule