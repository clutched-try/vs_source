module CarryLookAheadAdder_v20 #(parameter WIDTH = 4
)(
     //input
    input wire[WIDTH-1:0] i_A,
    input wire[WIDTH-1:0] i_B,
    input wire i_Cin,
    //outut
    output wire[WIDTH-1:0] o_Sum,
    output wire o_Cout
);

wire[WIDTH:0] Ct0;
assign Ct0[0] = i_Cin;

wire [WIDTH-1:0] P;
wire[WIDTH-1:0] G;
assign P = i_A ^ i_B;
assign G = i_A & i_B;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : CLA_LOOP
        assign Ct0[i+1] = G[i] | (P[i] & Ct0[i]);
        assign o_Sum[i] = P[i] ^ Ct0[i];
    end
endgenerate


assign o_Cout = Ct0[WIDTH];

endmodule