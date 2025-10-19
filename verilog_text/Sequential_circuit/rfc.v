module rfc (
    input wire clk,
    input wire read_en,
    input wire write_en,
    input wire data_in,
    output reg data_out
);
  reg out;  
    always @(posedge clk) begin
        if(write_en) begin
            out <= data_in;
        end
    end

    always @(*) begin
        data_out = (read_en) ? out : 1'b0;
    end

endmodule