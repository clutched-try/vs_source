// -------------------------
// Simple testbench
// -------------------------
module tb_bcd_to_7seg;
    reg [3:0] bcd;
    wire [6:0] seg;
    wire dp;

    // Instantiate DUT (change parameter if you want common anode)
    bcd_to_7seg #(.COMMON_ANODE(0)) dut (
        .bcd(bcd),
        .seg(seg),
        .dp(dp)
    );

    initial begin
        $display("time\tbcd\tseg\tdp");
        $monitor("%0t\t%0d\t%b\t%b", $time, bcd, seg, dp);

        // cycle through 0..15
        for (integer i = 0; i < 16; i = i + 1) begin
            bcd = i[3:0];
            #10;
        end

        #10 $finish;
    end

endmodule