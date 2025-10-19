`timescale 1ns/1ps

module FullAdder_tb;

    parameter CLK_PERIOD = 10;

    reg i_A;
    reg i_B;
    reg i_Cin;

    wire o_Cout;
    wire o_Sum;

    // Instance DUT
    FullAdder uut (
        .i_A(i_A),
        .i_B(i_B),
        .i_Cin(i_Cin),
        .o_Cout(o_Cout),
        .o_Sum(o_Sum)
    );

    // Test stimulus
    initial begin
        $display("Time | A B Cin | Sum Cout ");
        $display("-------------------------");

        {i_A, i_B, i_Cin} = 3'b000;

        repeat (8) begin
            #(CLK_PERIOD) {i_A, i_B, i_Cin} = {i_A, i_B, i_Cin} + 1;
        end

        #(CLK_PERIOD) $finish;
    end

    // Monitor in a separate block
    initial begin
        $monitor("time=%0t | A=%b B=%b Cin=%b | Sum=%b Cout=%b",
                  $time, i_A, i_B, i_Cin, o_Sum, o_Cout);
    end

endmodule
