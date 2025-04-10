module buffer_pad_conv (
    input clk,
    input rst,
    input [1:0] c,
    input [7:0] pix,
    output reg [23:0] p,
    output reg buffer_done
);

    reg [1:0] c_buffer;

    // Latch `c` into `c_buffer` for synchronization
    always @(posedge clk or posedge rst) begin
        if (rst)
            c_buffer <= 2'b00;
        else
            c_buffer <= c;
    end

    // Update pixel buffer `p` and trigger `buffer_done` when last byte is received
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            p <= 24'd0;
            buffer_done <= 1'b0;
        end else begin
            buffer_done <= 1'b0; // Default to 0, unless triggered below

            case (c_buffer)
                2'b01: p[7:0]    <= pix;
                2'b10: p[15:8]   <= pix;
                2'b11: begin
                    p[23:16]    <= pix;
                    buffer_done <= 1'b1;
                end
                default: ; // No operation on 2'b00
            endcase
        end
    end

endmodule
