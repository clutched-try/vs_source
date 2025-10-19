//2to4 decoder
module decoder_unit(
    input  wire i_a0,
    input  wire i_a1,
    input  wire i_EN,
    output wire [3:0] o_Y
);
    assign o_Y[0] = i_EN & ~i_a1 & ~i_a0;
    assign o_Y[1] = i_EN & ~i_a1 &  i_a0;
    assign o_Y[2] = i_EN &  i_a1 & ~i_a0;
    assign o_Y[3] = i_EN &  i_a1 &  i_a0;
endmodule
