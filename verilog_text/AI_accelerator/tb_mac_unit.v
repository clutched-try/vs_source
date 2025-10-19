// tb_mac_unit.v
`timescale 1ns/1ps
module tb_mac_unit;
    reg clk = 0;
    always #5 clk = ~clk; // 100 MHz -> 10 ns period

    reg rst_n;
    reg en;
    reg valid_in;
    reg [15:0] a;
    reg [15:0] b;
    wire valid_out;
    wire [39:0] acc_out;

    mac_unit #(.AW(16), .BW(16), .ACCW(40), .SIGNED(0)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .valid_in(valid_in),
        .a(a),
        .b(b),
        .valid_out(valid_out),
        .acc_out(acc_out)
    );

    initial begin
        rst_n = 0; en = 0; valid_in = 0; a = 0; b = 0;
        #25;
        rst_n = 1;
        #10;

        en = 1;
        // apply sequence of multiplies
        a = 10; b = 2; valid_in = 1; #10;
        a = 3;  b = 5; valid_in = 1; #10;
        a = 100; b = 7; valid_in = 1; #10;
        valid_in = 0; a = 0; b = 0; #40;

        // check acc_out
        $display("Final acc_out = %0d", acc_out);
        $finish;
    end
endmodule
