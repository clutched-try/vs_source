`timescale 1ns/1ps

module tb_register_file;

    // Thông số
    parameter WIDTH = 4;
    parameter DEPTH = 8;
    parameter NUM_READ = 2;
    parameter NUM_WRITE = 2;

    // Tín hiệu test
    reg clk;
    reg [NUM_WRITE-1:0] write_en;
    reg [NUM_READ-1:0]  read_en;
    reg [$clog2(DEPTH)-1:0] addr_write [NUM_WRITE-1:0];
    reg [$clog2(DEPTH)-1:0] addr_read  [NUM_READ-1:0];
    reg [WIDTH-1:0] data_in  [NUM_WRITE-1:0];
    wire [WIDTH-1:0] data_out [NUM_READ-1:0];

    // Khởi tạo DUT
    register_file #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .NUM_READ(NUM_READ),
        .NUM_WRITE(NUM_WRITE)
    ) uut (
        .clk(clk),
        .write_en(write_en),
        .read_en(read_en),
        .addr_write(addr_write),
        .addr_read(addr_read),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock 10ns
    always #5 clk = ~clk;

    integer i;
    initial begin
        clk = 0;
        write_en = 0;
        read_en = 0;

        // Ghi thử dữ liệu vào 2 ô
        #10;
        write_en[0] = 1; addr_write[0] = 3; data_in[0] = 4'b1010;
        write_en[1] = 1; addr_write[1] = 5; data_in[1] = 4'b1100;
        #10;
        write_en = 0;

        // Đọc lại dữ liệu vừa ghi
        #10;
        read_en = 2'b11;
        addr_read[0] = 3;
        addr_read[1] = 5;
        #1;
        $display("Read data_out[0] = %b (expect 1010)", data_out[0]);
        $display("Read data_out[1] = %b (expect 1100)", data_out[1]);

        // Ghi đè tại địa chỉ 3
        #10;
        write_en[0] = 1; addr_write[0] = 3; data_in[0] = 4'b1111;
        #10;
        write_en = 0;

        // Đọc lại địa chỉ 3
        #10;
        read_en = 2'b01;
        addr_read[0] = 3;
        #1;
        $display("After overwrite, data_out[0] = %b (expect 1111)", data_out[0]);

        #20;
        $finish;
    end

endmodule
