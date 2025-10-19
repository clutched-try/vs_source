module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    // parameter LEFT=0, RIGHT=1, ...
    parameter LEFT_D = 1'b0, RIGHT_D = 1'b1;
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
            LEFT_D: next_state = (bump_left) ? RIGHT_D : LEFT_D;
            RIGHT_D: next_state = (bump_right) ? LEFT_D : RIGHT_D; 
            default: next_state = LEFT_D;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) begin
            state <= LEFT_D;
        end
        else begin
            state <= next_state;
        end
    end

    // Output logic
    // assign walk_left = (state == ...);
    // assign walk_right = (state == ...);
    always @(*) begin
        case (state)
            LEFT_D: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end 
            RIGHT_D: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left = 1'bx;
                walk_right = 1'bx;
            end
        endcase
    end

endmodule
