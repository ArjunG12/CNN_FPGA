`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2024 04:45:50
// Design Name: 
// Module Name: padding
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//i/o:-
//count_i- the x coordinate
//count_j- the y coordinate
//pad_x- padding in x dir
//pad_y- padding in y dir
//pix- output pixel at count_i and count_j wrt after padding
//conv1_clk - clk with 1/3 freq
//c- 3 N counter
module padding(
    input clk,
    input rst,
    input [6:0] count_i,
    input [6:0] count_j,
    input [3:0] pad_x,
    input [3:0] pad_y,
    output reg [12:0] addr,
    output reg [1:0] c
);
    reg r;
    reg [6:0] i, j;

    // Main always block for state control and address calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 2'b00;
            addr <= 13'd0;
            r <= 1'b0;
            i <= 7'd0;
            j <= 7'd0;
        end else begin
            // Detect changes in `i` or `j`
            r <= |(i ^ count_i) | |(j ^ count_j);
            i <= count_i;
            j <= count_j;

            // Reset `c` and `r` when `r` is asserted
            if (r) begin
                c <= 2'b00;
            end else begin
                // Update `c` cyclically
                case (c)
                    2'b00: c <= 2'b01;
                    2'b01: c <= 2'b10;
                    2'b10: c <= 2'b00;
                    default: c <= 2'b00;
                endcase

                // Address calculation based on conditions
                if (count_i < pad_x) begin
                    addr <= 13'd0;
                end else if (pad_y > (2 + count_j)) begin
                    addr <= 13'd0;
                end else if (pad_y == (2 + count_j)) begin
                    case (c)
                        2'b00: addr <= 13'd0;
                        2'b01: addr <= 13'd0;
                        2'b10: addr <= count_i - pad_x + 64 * (count_j - pad_y + 2);
                        default: addr <= 13'd0;
                    endcase
                end else if (pad_y == (1 + count_j)) begin
                    case (c)
                        2'b00: addr <= 13'd0;
                        2'b01: addr <= count_i - pad_x + 64 * (count_j - pad_y + 1);
                        2'b10: addr <= count_i - pad_x + 64 * (count_j - pad_y + 2);
                        default: addr <= 13'd0;
                    endcase
                end else begin
                    case (c)
                        2'b00: addr <= count_i - pad_x + 64 * (count_j - pad_y);
                        2'b01: addr <= count_i - pad_x + 64 * (count_j - pad_y + 1);
                        2'b10: addr <= count_i - pad_x + 64 * (count_j - pad_y + 2);
                        default: addr <= 13'd0;
                    endcase
                end
            end
        end
    end
endmodule

