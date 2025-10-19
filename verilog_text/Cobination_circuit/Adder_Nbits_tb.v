`timescale 1ns/1ps

module Adder_Nbits_tb;

    parameter CLK_PERIOD = 10;
    parameter WIDTH = 15;

    reg  [WIDTH-1:0] i_A;
    reg  [WIDTH-1:0] i_B;
    reg              i_Cin;
    
    wire [WIDTH-1:0] o_Sum;
    wire             o_Cout;

    // Instance DUT
    Adder_Nbits #(.WIDTH(WIDTH)) uut (
        .i_A(i_A),
        .i_B(i_B),
        .i_Cin(i_Cin),
        .o_Cout(o_Cout),
        .o_Sum(o_Sum)
    );

    // Golden reference
    reg [WIDTH:0] golden;

    integer k;
    initial begin
        // Test vài vector ngẫu nhiên + biên
        for (k = 0; k < 20; k = k + 1) begin
            i_A   = $random;
            i_B   = $random;
            i_Cin = $random % 2;

            #(CLK_PERIOD);

            golden = i_A + i_B + i_Cin;

            if ({o_Cout, o_Sum} !== golden) begin
                $display("❌ Mismatch at time %0t: A=%h B=%h Cin=%b | Expected=%h Got={%b,%h}",
                          $time, i_A, i_B, i_Cin, golden, o_Cout, o_Sum);
            end else begin
                $display("✅ Pass at time %0t: A=%h B=%h Cin=%b | Sum=%h Cout=%b",
                          $time, i_A, i_B, i_Cin, o_Sum, o_Cout);
            end
        end

        $finish;
    end

endmodule
