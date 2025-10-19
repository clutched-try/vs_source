module mux2 (
    input wire [1:0] i_d,
    input wire i_s,

    output o_y
);

assign o_y = o_s ? i_d[1] : i_d[2];

endmodule