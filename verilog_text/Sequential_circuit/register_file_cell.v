module register_file_cell #(
    parameter NUM_READ = 1
)(
    input wire clk,
    input wire data_in,
    input wire write_en,
    input wire [NUM_READ-1:0] read_en,

    output wire [NUM_READ-1:0] data_out
);
wire [$clog2(8)-1:0] x;
reg q;

always @(posedge clk) begin
    if(write_en) begin
        q <= data_in;
    end
end

wire [NUM_READ-1:0] en_r;
wire [NUM_READ-1:0] out;


genvar i;
generate
    for(i = 0; i < NUM_READ; i = i + 1) begin : READ_BLOCK
        assign out[i] = (en_r[i]) ? q : 1'bz;
    end
endgenerate

assign en_r = read_en;
assign data_out = out;
endmodule