module mux_n_to_1 #(
    parameter WIDTH_SELECT = 2,
    parameter WIDTH = 2**WIDTH_SELECT
) (
    input  wire [WIDTH-1:0]            i_d,   // data inputs
    input  wire [WIDTH_SELECT-1:0]     i_s,   // select lines
    output wire                        o_y    // output
);

    // Mảng trung gian lưu kết quả từng tầng
    wire [WIDTH-1:0] layer [WIDTH_SELECT:0];

    // Gán tầng 0 = ngõ vào ban đầu
    assign layer[0] = i_d;

    genvar level, idx;
    generate
        for (level = 0; level < WIDTH_SELECT; level = level + 1) begin : MUX_LAYER
            for (idx = 0; idx < (WIDTH >> (level + 1)); idx = idx + 1) begin : MUX_GEN
                mux_2to1 u_mux (
                    .i_d(layer[level][2*idx +: 2]),
                    .i_s(i_s[level]),
                    .o_y(layer[level+1][idx])
                );
            end
        end
    endgenerate

    // Ngõ ra cuối cùng
    assign o_y = layer[WIDTH_SELECT][0];

endmodule
