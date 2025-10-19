`timescale 1ns/1ps

module tb_Det1011_MealyFSM;

    reg clk;
    reg rst_n;
    reg i_seq;
    wire o_det;

    // Instantiate DUT
    Det1011_MealyFSM uut (
        .i_seq(i_seq),
        .clk(clk),
        .rst_n(rst_n),
        .o_det(o_det)
    );

    // Clock 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence: 1011011
    reg [6:0] test_seq = 7'b1011011;
    integer i;

    initial begin
        // Dump file for GTKWave
        $dumpfile("tb_Det1011_MealyFSM.vcd");
        $dumpvars(0, tb_Det1011_MealyFSM);

        // Reset hệ thống
        rst_n = 0;
        i_seq = 0;
        #12;  // giữ reset vài chu kỳ
        rst_n = 1;

        // Gửi chuỗi từng bit
        for (i = 0; i < 7; i = i + 1) begin
            @(negedge clk);  // đổi giá trị ở cạnh xuống → ổn định khi vào cạnh lên
            i_seq = test_seq[6 - i];  // gửi từ MSB xuống LSB: 1 0 1 1 0 1 1
        end

        // chờ vài chu kỳ
        #20;
        $finish;
    end

    // Theo dõi log
    initial begin
        $display("Time\tclk\trst\ti_seq\to_det");
        $monitor("%4dns\t%b\t%b\t%b\t%b", $time, clk, rst_n, i_seq, o_det);
    end

endmodule
