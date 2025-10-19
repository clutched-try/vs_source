module CarryLookAheadAdder #(parameter WIDTH = 4
)(
    //input
    input wire[WIDTH-1:0] i_A,
    input wire[WIDTH-1:0] i_B,
    input wire i_Cin,
    //outut
    output wire[WIDTH-1:0] o_Sum,
    output wire o_Cout
);

`define CLA CarryLookAheadAdder;

wire[WIDTH-1:0] Cout_temp;

wire[WIDTH-1:0] Pt0;
wire[WIDTH-1:0] Gt0;

genvar i;
generate

    for(i = 0; i < WIDTH; i = i+1) begin : HA_GEN
        HalfAdder inst_HA (
            .i_a(i_A[i]),
            .i_b(i_B[i]),
            .o_c(Gt0[i]),
            .o_s(Pt0[i]) 
            );
    end

    LookAheadCarryCircuit inst_LACC (
        .i_G(Gt0),
        .i_P(Pt0),
        .i_C0(i_Cin),
        .o_Cout(Cout_temp)
        );

endgenerate

assign o_Sum = Pt0 ^ {Cout_temp[WIDTH-2:0], i_Cin};
assign o_Cout = Cout_temp[WIDTH-1];

endmodule