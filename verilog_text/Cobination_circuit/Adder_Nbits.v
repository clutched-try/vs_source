module Adder_Nbits #(parameter WIDTH = 16
)(
    input wire[WIDTH-1:0] i_A,
    input wire[WIDTH-1:0] i_B,
    input wire i_Cin,

    output wire[WIDTH-1:0] o_Sum,
    output wire o_Cout
);

localparam  num_CLA = WIDTH % 4 ?(WIDTH / 4 + 1): (WIDTH / 4);

wire[3:0] A_temp [0:num_CLA-1];
wire[3:0] B_temp[0:num_CLA-1];
wire[3:0] Sum_temp[0:num_CLA-1];
wire[num_CLA:0] C_temp;

assign C_temp[0] = i_Cin;

genvar i;
generate
    for (i = 0; i < num_CLA; i = i + 1) begin : CLA_4bits_GEN
        if (i == num_CLA-1 && (WIDTH % 4 != 0)) begin : LAST_BLOCK
            // Khối cuối cùng chỉ lấy phần dư
            localparam LAST_WIDTH = WIDTH % 4;

            CarryLookAheadAdder_v20 #(.WIDTH(LAST_WIDTH)) inst_CLA_last (
                .i_A(i_A[i*4 +: LAST_WIDTH]),
                .i_B(i_B[i*4 +: LAST_WIDTH]),
                .i_Cin(C_temp[i]),
                .o_Cout(C_temp[i+1]),
                .o_Sum(o_Sum[i*4 +: LAST_WIDTH])
            );
        end
        else begin : NORMAL_BLOCK
            CarryLookAheadAdder_v20 #(.WIDTH(4)) inst_CLA_4bits (
                .i_A(i_A[i*4 +: 4]),
                .i_B(i_B[i*4 +: 4]),
                .i_Cin(C_temp[i]),
                .o_Cout(C_temp[i+1]),
                .o_Sum(o_Sum[i*4 +: 4])
            );
        end
    end
endgenerate

assign o_Cout = C_temp[num_CLA];


assign o_Cout = C_temp[num_CLA];

endmodule