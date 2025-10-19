module pe #(
    parameter WIDTH_A = 16,
    parameter WIDTH_B = 16,
    parameter WIDTH_ACC = 32,
    parameter SIGNED = 1
) (
    input wire [WIDTH_A-1:0] a,
    input wire [WIDTH_B-1:0] b,
    input wire clk,
    input wire rst_n,
    input wire en,

    output reg [WIDTH_ACC-1:0] acc,
    
    //Tín hiệu điều khiển pineline khi nối các PE
    input wire valid_in, 
    output reg valid_out
);
    
    localparam WIDTH_MULT = WIDTH_A + WIDTH_B;
    reg [WIDTH_MULT-1:0] prod_mult;
    wire [WIDTH_MULT-1:0] mult;
    reg valid_reg;

generate
    if(SIGNED) begin
       assign mult = $signed($signed(a)) * $signed($signed(b));
    end
    else begin
       assign mult = a * b;
    end
endgenerate

always @(posedge clk) begin
    if(!rst_n) begin // Khi rst_n active
        prod_mult <= {WIDTH_MULT{1'b0}};
        valid_reg <= 1'b0;
    end
    else begin
        prod_mult <= mult;
        valid_reg <= valid_in;
    end
end

always @(posedge clk) begin
    if(!rst_n) begin // Khi rst_n active
        acc <= {WIDTH_ACC{1'b0}};
        valid_out <= 1'b0;
    end
    //
    else begin
        valid_out <= valid_reg;
        //Kiểm tra đầu vào đã sẳn sàng
        if(en && valid_reg) begin
            if(WIDTH_MULT < WIDTH_ACC) begin
                if(SIGNED) begin
                    acc <= $signed($signed(acc)) + {{WIDTH_ACC-WIDTH_MULT{prod_mult[WIDTH_MULT-1]}},prod_mult[WIDTH_MULT-1:0]}; // mở rộng dấu bằng bit MSB
                end
                else begin
                    acc <= acc+ {{WIDTH_ACC-WIDTH_MULT{1'b0}},prod_mult[WIDTH_MULT-1:0]};
                end
            end

            else begin
                acc <= acc + prod_mult[WIDTH_MULT -: WIDTH_ACC] ;
            end
        end
    end
end

endmodule