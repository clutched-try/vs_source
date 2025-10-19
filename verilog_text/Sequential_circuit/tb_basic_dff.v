`timescale 1ns/1ps

module tb_basic_dff;

    parameter WIDTH = 4;

    reg  [WIDTH-1:0] d;
    reg              clk;
    reg  rst;
    wire [WIDTH-1:0] q;

    // Kết nối module
    basic_dff #(.WIDTH(WIDTH)) uut (
        .i_d(d),
        .i_clk(clk),
        .i_rst(rst),
        
        .o_q(q)
    );

    // Tạo xung clock 10ns
    always #5 clk = ~clk;

    // Khởi tạo tín hiệu và dump waveform
    initial begin
        $dumpfile("tb_basic_dff.vcd");
        $dumpvars(0, tb_basic_dff);

        clk    = 0;
        d      = 0;
        rst    = 0;

        #2 rst = 1;                       // nhả clear
        forever #10 d = d + 1;             // thay đổi d
        #120 rst = 0;                      // test clear
        #5  rst = 1;
        #20 $finish;
    end


endmodule
