`timescale 1ns / 1ps

module tb_shift_register;

    // --- Tham số ---
    parameter WIDTH = 4;

    // --- Khai báo tín hiệu ---
    reg  [WIDTH-1:0] i_load;
    reg               i_rst;
    reg               i_en_load;
    reg               i_rotate;
    reg               i_shift;
    reg               i_clk;
    wire [WIDTH-1:0]  o_q;

    // --- Instantiate DUT (Device Under Test) ---
    universal_shift_register #(
        .WIDTH(WIDTH)
    ) uut (
        .i_load(i_load),
        .i_rst(i_rst),
        .i_en_load(i_en_load),
        .i_rotate(i_rotate),
        .i_shift(i_shift),
        .i_clk(i_clk),
        .o_q(o_q)
    );

    // --- Clock 10ns (100MHz) ---
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    // --- Test sequence ---
    initial begin
        // Khởi tạo
        i_rst      = 0;
        i_en_load  = 0;
        i_rotate   = 0;
        i_shift    = 0;
        i_load     = 4'b0000;

        // Reset
        #10 i_rst = 1;

        // Load giá trị ban đầu
        #10;
        i_en_load = 1;
        i_load    = 4'b1010;  // dữ liệu nạp vào
        #10 i_en_load = 0;

        // --- Test Shift Right (00) ---
        i_rotate = 0;
        i_shift  = 0;
        #40;  // 4 chu kỳ clock

        // --- Test Shift Left (01) ---
        i_rotate = 0;
        i_shift  = 1;
        #40;

        // --- Test Rotate Left (10) ---
        i_rotate = 1;
        i_shift  = 0;
        #40;

        // --- Test Rotate Right (11) ---
        i_rotate = 1;
        i_shift  = 1;
        #40;

        // Kết thúc mô phỏng
        $finish;
    end

    // --- Theo dõi kết quả ---
    initial begin
        $monitor("T=%0t | load=%b | en_load=%b | rotate=%b | shift=%b | o_q=%b",
                  $time, i_load, i_en_load, i_rotate, i_shift, o_q);
    end

endmodule
