module LookAheadCarryUnit (
    //input
    input wire i_g,
    input wire i_p,
    input wire i_c0,
    //output
    output wire o_c1
);

`define LACU LookAheadCarryUnit;

assign o_c1 = i_g | (i_c0 & i_p);
endmodule