// mac_unit with pipelined
// 2-stage pipeline: stage0 = multiply (combinational, registered), stage1 = accumulate
module mac_unit #(
    parameter AW = 16,
    parameter BW = 16,
    parameter ACCW = 40,
    parameter SIGNED = 0
)(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    input  wire valid_in,
    input  wire [AW-1:0] a,
    input  wire [BW-1:0] b,
    output reg  valid_out,
    output reg  [ACCW-1:0] acc_out
);
    localparam MW = AW + BW;

    // stage 0 register (holds product)
    reg [MW-1:0] prod_reg;
    reg          valid_reg;

    wire [MW-1:0] mult;
    generate
        if (SIGNED) begin
            assign mult = $signed($signed(a)) * $signed($signed(b));
        end else begin
            assign mult = a * b;
        end
    endgenerate

    // stage0: register product
    always @(posedge clk) begin
        if (!rst_n) begin
            prod_reg <= {MW{1'b0}};
            valid_reg <= 1'b0;
        end else begin
            prod_reg <= mult;
            valid_reg <= valid_in;
        end
    end

    // stage1: accumulate
    always @(posedge clk) begin
        if (!rst_n) begin
            acc_out <= {ACCW{1'b0}};
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_reg;
            if (en && valid_reg) begin
                // extend/truncate product to ACCW
                if (MW <= ACCW) begin
                    if (SIGNED)
                        acc_out <= $signed(acc_out) + $signed({{(ACCW-MW){prod_reg[MW-1]}}, prod_reg});
                    else
                        acc_out <= acc_out + {{(ACCW-MW){1'b0}}, prod_reg};
                end else begin
                    acc_out <= acc_out + prod_reg[MW-1 -: ACCW];
                end
            end
        end
    end
endmodule
