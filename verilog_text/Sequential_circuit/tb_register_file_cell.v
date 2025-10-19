`timescale 1ns/1ps
module tb_register_file_cell;

    parameter NUM_READ = 2;
    parameter CLOCK_PERIOD = 5;

    reg clk;
    reg data_in;
    reg write_en;
    reg [NUM_READ-1:0] read_en;
    wire data_out1, data_out0;


    register_file_cell #(
        .NUM_READ(NUM_READ)
    ) uut(
        .clk(clk),
        .data_in(data_in),
        .write_en(write_en),
        .read_en(read_en),

        .data_out({data_out1, data_out0})
    );

    initial begin
        write_en = 1'b0;
        for (integer i = 0; i < NUM_READ; i = i + 1) begin
            read_en[i] = 1'b0;
        end
        clk = 1'b0;
        data_in = 1'b0;

        forever begin
            #CLOCK_PERIOD clk = ~clk;
        end
    end

    initial begin
        #(CLOCK_PERIOD*2) write_en = 1'b1;
         for (integer i = 0; i < 50; i= i + 1) begin
            #(CLOCK_PERIOD*2) data_in = data_in + 1;
        end
        #CLOCK_PERIOD $finish;
    end

     initial begin
        forever begin
            #(CLOCK_PERIOD*4)
            read_en = read_en + 1;
            end
    end

endmodule