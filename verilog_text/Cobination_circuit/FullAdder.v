module FullAdder(
    //input
    input wire i_A,
    input wire i_B,
    input wire i_Cin,
    //output
    output wire o_Cout,
    output wire o_Sum
);

wire Ct0, St0;

HalfAdder inst_HA (
    .i_a(i_A),
    .i_b(i_B),
    .o_c(Ct0),
    .o_s(St0)
);

assign o_Sum = St0 ^ i_Cin; //Sum
assign o_Cout = Ct0 | (St0 & i_Cin); //Carry

endmodule