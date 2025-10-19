module RippleCarryAdder #(parameter WIDTH = 4
)(
    //input
    input wire[WIDTH-1:0] i_A,
    input wire[WIDTH-1:0] i_B,
    input wire i_Cin,
    //outut
    output wire[WIDTH-1:0] o_Sum,
    output wire o_Cout

);


wire [WIDTH:0] Ct0;
assign Ct0[0] = i_Cin;


genvar i;
generate
    for (i = 0; i < WIDTH ; i=i+1) begin : FA_GEN
        FullAdder inst_FA (
            .i_A(i_A[i]),
            .i_B(i_B[i]),
            .i_Cin(Ct0[i]),
            .o_Cout(Ct0[i+1]),
            .o_Sum(o_Sum[i])
            );
    end
endgenerate

assign o_Cout = Ct0[WIDTH];

endmodule
