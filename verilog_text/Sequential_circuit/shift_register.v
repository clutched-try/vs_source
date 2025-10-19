module universal_shift_register #(
    parameter WIDTH = 4
) (
    input wire [WIDTH-1:0]  i_load,
    input wire              i_rst,
    input wire              i_en_load,
    input wire              i_rotate,
    input wire              i_shift,
    input wire              i_clk,

    output wire  [WIDTH-1:0]  o_q
);
    reg [WIDTH-1:0] d_input;
    wire [1:0] check_condition;
    assign check_condition = {i_rotate, i_shift};
    genvar i;
    generate
        for(i = 0; i < WIDTH; i = i + 1) begin : DFF_GEN
            dff #(
                .WIDTH(1),
                .ASYNC_RESET(1),
                .RESET_POLARITY(0)
            )inst_dff (
                .clk(i_clk),
                .rst(i_rst),
                .en(1'b1),
                .d(d_input[i]),
                .q(o_q[i])
                );
        end
    endgenerate
    integer j;
    always @(*) begin
        
        if(i_en_load)
            d_input = i_load;        
        else begin
            case (check_condition)
                2'b00: begin
                    for(j = 1; j < WIDTH - 1; j = j + 1) begin
                        d_input[j] = o_q[j-1];
                    end
                    d_input[0] = i_load[0];
                    d_input[WIDTH-1] = o_q[WIDTH-2];
                end 
                2'b01: begin
                    for(j = 1; j < WIDTH - 1; j = j + 1) begin
                       d_input[j] = o_q[j+1];
                    end
                    d_input[0] = o_q[1];
                    d_input[WIDTH-1] = i_load[WIDTH-1];
                end
                2'b10: begin
                    for(j = 1; j < WIDTH - 1; j = j + 1) begin
                       d_input[j] = o_q[j+1];
                    end
                    d_input[0] = o_q[1];
                    d_input[WIDTH-1] = o_q[0];
                end
                default:  begin
                    for(j = 1; j < WIDTH - 1; j = j + 1) begin
                        d_input[j] = o_q[j-1];
                    end
                    d_input[0] = o_q[WIDTH-1];
                    d_input[WIDTH-1] = o_q[WIDTH-2];
                end
                
            endcase
        end
    end

endmodule