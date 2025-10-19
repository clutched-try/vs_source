// dff.v
// Parameterized D flip-flop (DFF)
// - WIDTH: bit-width of the D/Q signals
// - ASYNC_RESET: 1 = asynchronous reset, 0 = synchronous reset
// - RESET_POLARITY: 1 = active-high reset, 0 = active-low reset
// Signals:
// clk  : clock (posedge triggered)
// rst  : reset (polarity controlled by RESET_POLARITY)
// en   : enable (when 1, Q follows D on clock)
// d    : data input
// q    : registered output

module dff #(
    parameter integer WIDTH = 1,
    parameter integer ASYNC_RESET = 1,      // 1 = async, 0 = sync
    parameter integer RESET_POLARITY = 1    // 1 = active-high, 0 = active-low
) (
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 en,
    input  wire [WIDTH-1:0]     d,
    output reg  [WIDTH-1:0]     q
);

generate
    if (ASYNC_RESET) begin
        if (RESET_POLARITY) begin : ASYNC_ACTIVE_HIGH
            // Asynchronous active-high reset
            always @(posedge clk or posedge rst) begin
                if (rst)
                    q <= {WIDTH{1'b0}};
                else if (en)
                    q <= d;
            end
        end else begin : ASYNC_ACTIVE_LOW
            // Asynchronous active-low reset
            always @(posedge clk or negedge rst) begin
                if (!rst)
                    q <= {WIDTH{1'b0}};
                else if (en)
                    q <= d;
            end
        end
    end else begin : SYNC_RESET
        // Synchronous reset (polarity controlled by RESET_POLARITY)
        always @(posedge clk) begin
            if ((RESET_POLARITY && rst) || (!RESET_POLARITY && !rst))
                q <= {WIDTH{1'b0}};
            else if (en)
                q <= d;
        end
    end
endgenerate

endmodule

