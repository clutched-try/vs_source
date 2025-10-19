`timescale 1ns / 1ps

module tb_Det1011_MooreFSM;
    reg clk, rst_n, i_seq;
    wire o_det;

    // Khởi tạo DUT (Device Under Test)
    Det1011_MooreFSM dut (
        .i_seq(i_seq),
        .clk(clk),
        .rst_n(rst_n),
        .o_det(o_det)
    );

    // Tạo xung clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Chuỗi đầu vào cần kiểm tra
    reg [15:0] sequence = 16'b1011011010110110;
    integer i;

    initial begin
        $dumpfile("tb_Det1011_MooreFSM.vcd"); // cho GTKWave
        $dumpvars(0, tb_Det1011_MooreFSM);

        // Reset
        rst_n = 0;
        i_seq = 0;
        #15;
        rst_n = 1;

        // Đưa lần lượt từng bit vào FSM
        for (i = 15; i >= 0; i = i - 1) begin
            i_seq = sequence[i];
            #10; // mỗi bit một chu kỳ clock
        end

        #20;
        $finish;
    end
endmodule
