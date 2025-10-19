`timescale 1ns/1ps

module tb_decoder_nbits();

    parameter CLK_PERIOD = 10;
    parameter N = 3;

    reg [N-1:0] i_A;
    reg         i_EN;

    wire [2**(N)-1:0] o_Y;

    // Instance DUT
    decoder_nbits #(.N(N)) uut(
        .i_A(i_A),
        .i_EN(i_EN),

        .o_Y(o_Y)
    );

    initial begin
        i_A = {N{1'b0}};
        i_EN = 1'b0;

        repeat (2**(N+4)) begin
            #(CLK_PERIOD) i_A = i_A + 1;
            #(CLK_PERIOD*3) i_EN = 1'b1;
        end
       $finish;
    end

endmodule