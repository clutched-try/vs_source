`timescale 1ns/1ps
module tb_rfc();
    
    reg clk;
    reg write_en;
    reg read_en;
    reg data_in;
    wire data_out;

    rfc uut (
        .clk(clk),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),

        .data_out(data_out)
    );
        
    initial begin
        clk =1'b0;
        write_en = 1'b0;
        read_en = 1'b0;
        data_in = 1'b0;
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        #8; 
        write_en = 1'b1;
        read_en = 1'b1;
        #2;
        repeat(8) begin
            #20 write_en = $random % 2;
            #20 read_en = $random % 2;
            data_in = data_in + 1;
        end
        $finish;
    end
    reg exp_q;
     always @(posedge clk) begin
        if(write_en) begin
            exp_q <= data_in;
        end
    end

endmodule