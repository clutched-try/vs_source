module HalfAdder (
    //input
    input wire i_a,
    input wire i_b,
    //output
    output wire o_c,
    output wire o_s
);

    assign o_s = i_a ^ i_b; //Sum
    assign o_c = i_a & i_b; //Carry

endmodule