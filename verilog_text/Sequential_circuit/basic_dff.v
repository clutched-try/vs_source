module basic_dff #(
    parameter WIDTH = 4
)(
    input wire [WIDTH-1:0] i_d,
    input wire             i_clk,
    input wire             i_rst,

    output reg [WIDTH-1:0] o_q
);

always @(posedge i_clk or negedge i_rst) begin
    if(!i_rst)
        o_q <= {WIDTH{1'b0}};
    else
        o_q <= i_d;
end
    
endmodule