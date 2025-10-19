module LookAheadCarryCircuit #(parameter WIDTH = 4
)(
    //input
    input wire[WIDTH-1:0] i_G,
    input wire[WIDTH-1:0] i_P,
    input wire i_C0,
    //output
    output wire[WIDTH-1:0] o_Cout
);

`define LACC LookAheadCarryCircuit;

wire[WIDTH:0] Ct0;
assign Ct0[0] = i_C0;

genvar i;
generate
    for (i = 0; i<WIDTH; i = i+1 ) begin : LACU_GEN
        LookAheadCarryUnit inst_LACU(
            .i_g(i_G[i]),
            .i_p(i_P[i]),
            .i_c0(Ct0[i]),
            .o_c1(Ct0[i+1])
        );
    end
endgenerate

assign o_Cout = Ct0[WIDTH:1];

endmodule