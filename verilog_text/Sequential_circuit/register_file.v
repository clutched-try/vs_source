module register_file #(
    parameter WIDTH     = 4,
    parameter DEPTH     = 8,
    parameter NUM_READ  = 2,
    parameter NUM_WRITE = 2
)(
    input  wire clk,
    input  wire [NUM_WRITE-1:0] write_en,
    input  wire [NUM_READ-1:0]  read_en,
    input  wire [$clog2(DEPTH)-1:0] addr_write [NUM_WRITE-1:0],
    input  wire [$clog2(DEPTH)-1:0] addr_read  [NUM_READ-1:0],
    input  wire [WIDTH-1:0] data_in  [NUM_WRITE-1:0],
    output reg  [WIDTH-1:0] data_out [NUM_READ-1:0]
);

    // Bộ nhớ chính
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    integer i, j;

    // ==============================
    // WRITE OPERATION
    // ==============================
    always @(posedge clk) begin
        for (i = 0; i < NUM_WRITE; i = i + 1) begin
            if (write_en[i]) begin
                mem[addr_write[i]] <= data_in[i];
            end
        end
    end

    // ==============================
    // READ OPERATION
    // ==============================
    always @(*) begin
        for (i = 0; i < NUM_READ; i = i + 1) begin
            for(j = 0; j < NUM_WRITE; j = j + 1) begin
                if(read_en[i]) begin
                    if(write_en[j] && (addr_read[i] == addr_write[j])) begin
                        data_out[i] = data_in[j];
                    end
                    else begin
                        data_out[i] = mem[addr_read[i]];
                    end
                end
            end
        end
    end

endmodule
