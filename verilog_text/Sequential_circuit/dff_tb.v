// -----------------------------------------------------------------------------
// Simple testbench for the DFF module
// Instantiate a 4-bit DFF as an example. Adjust parameters as needed.
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

module dff_tb;

    parameter WIDTH = 4;

    reg         clk;
    reg         rst;    // follows RESET_POLARITY used below (0 = active-low here)
    reg         en;
    reg  [WIDTH-1:0]  d;
    wire [WIDTH-1:0]  q;

    // Instantiate: WIDTH=4, ASYNC_RESET=1, RESET_POLARITY=0 (active-low)
    dff #(.WIDTH(WIDTH), .ASYNC_RESET(1), .RESET_POLARITY(0)) uut (
        .clk(clk), .rst(rst), .en(en), .d(d), .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz style (10ns period) for simulation convenience
    end

    // Test sequence
    initial begin
        // Start with reset asserted (active-low -> rst=0)
        rst = 0; en = 0; d = 4'h0;
        #12;
        // Deassert reset
        rst = 1;
        #10;

        // Drive some data while enable is 1
        en = 1; d = 4'hA; // q should capture A at next rising edge
        #20;              // wait a few clocks
        d = 4'h5;
        #10;

        // Disable enable, change d (q should hold previous value)
        en = 0; d = 4'hF;
        #20;

        // Re-enable
        en = 1;
        #10;

        // Assert reset again (active-low -> rst=0)
        rst = 0;
        #10;

        $finish;
    end


    initial begin
        $dumpfile("dff_tb.vcd");
        $dumpvars(0, dff_tb);
    end

    initial begin
        $display("time clk rst en d q");
        $monitor("%0t  %b   %b   %b  %h %h", $time, clk, rst, en, d, q);
    end

endmodule
