// File: bcd_to_7seg.v
// BCD (4-bit) -> 7-segment decoder
// - Parameter COMMON_ANODE = 0 : outputs are active-high (common-cathode wiring)
// - If COMMON_ANODE = 1, outputs are inverted for common-anode displays
// Segment mapping: seg[6:0] = {a, b, c, d, e, f, g}
// dp is decimal point (active-high)

`timescale 1ns/1ps

module bcd_to_7seg #(
    parameter COMMON_ANODE = 0
)(
    input  wire [3:0] bcd,   // BCD input (0..9). 10..15 -> shows dash ('-')
    output wire [6:0] seg,   // segments: {a,b,c,d,e,f,g}
    output wire       dp     // decimal point (active-high)
);

    reg [6:0] seg_reg;
    reg       dp_reg;

    // combinational decode (common-cathode truth table)
    always @(*) begin
        dp_reg = 1'b0; // default: dp off
        case (bcd)
            4'd0: seg_reg = 7'b1111110; // 0
            4'd1: seg_reg = 7'b0110000; // 1
            4'd2: seg_reg = 7'b1101101; // 2
            4'd3: seg_reg = 7'b1111001; // 3
            4'd4: seg_reg = 7'b0110011; // 4
            4'd5: seg_reg = 7'b1011011; // 5
            4'd6: seg_reg = 7'b1011111; // 6
            4'd7: seg_reg = 7'b1110000; // 7
            4'd8: seg_reg = 7'b1111111; // 8
            4'd9: seg_reg = 7'b1111011; // 9
            default: begin
                // for invalid BCD (10..15) show '-' on 7-seg (only g on)
                seg_reg = 7'b0000001; // '-' (only g)
            end
        endcase
    end

    // apply common-anode inversion if requested
    assign seg = (COMMON_ANODE != 0) ? ~seg_reg : seg_reg;
    assign dp  = (COMMON_ANODE != 0) ? ~dp_reg  : dp_reg;

endmodule



