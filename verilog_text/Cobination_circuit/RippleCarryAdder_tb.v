`timescale 1ns/1ps

module RippleCarryAdder_tb;

    parameter CLK_PERIOD = 10;
    parameter WIDTH = 4;

    reg  [WIDTH-1:0] i_A;
    reg  [WIDTH-1:0] i_B;
    reg              i_Cin;
    
    wire [WIDTH-1:0] o_Sum;
    wire             o_Cout;

    // Instance DUT
    RippleCarryAdder #(.WIDTH(WIDTH)) uut (
        .i_A(i_A),
        .i_B(i_B),
        .i_Cin(i_Cin),
        .o_Cout(o_Cout),
        .o_Sum(o_Sum)
    );

    initial begin
        i_A   = {WIDTH{1'b0}};
        i_B   = {WIDTH{1'b0}};
        i_Cin = 1'b0;

        repeat (2**(2*WIDTH+1)) begin
            #(CLK_PERIOD) {i_A, i_B, i_Cin} = {i_A, i_B, i_Cin} + 1;
        end

        #(CLK_PERIOD)$finish;
    end
    
    initial begin
        $display("time |   A    |   B    | Cin |  Sum  | Cout");
        $display("------------------------------------------------");
        $monitor("%4t | %b | %b |  %b  | %b |   %b",
                 $time, i_A, i_B, i_Cin, o_Sum, o_Cout);
    end
endmodule
