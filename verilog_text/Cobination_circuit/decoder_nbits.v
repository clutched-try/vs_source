module decoder_nbits #(parameter N = 4)(
    input  wire [N-1:0] i_A,
    input  wire         i_EN,
    output wire [(2**N)-1:0] o_Y
);

    // Tầng đầu: dùng 2 MSB để tạo ra 4 enable
    wire [N-1:0] enable_lvl1;

    decoder_unit dec_lvl1 (
        .i_a0(i_A[N-2]),   // bit N-2
        .i_a1(i_A[N-1]),   // bit N-1 (MSB)
        .i_EN(i_EN),
        .o_Y(enable_lvl1)
    );

    // Tầng sau: mỗi enable_lvl1[i] đi vào một decoder (N-2 bit còn lại)
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : GEN_SUBDEC
            Decoder_Nto2expN #(.N(N-2)) dec_sub (
                .i_A(i_A[N-3:0]),
                .i_EN(enable_lvl1[i]),
                .o_Y(o_Y[i*(2**(N-2)) +: (2**(N-2))])
            );
        end
    endgenerate
endmodule
