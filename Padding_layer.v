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
    input clk_2,
    input rst,
    input [6:0] count_i,
    input [6:0] count_j,
    input [3:0] pad_x,
    input [3:0] pad_y,
    output [12:0] addr,
    output reg [1:0] c
);

    // Internal registers to detect changes in count_i and count_j
    reg [6:0] i, j;

    wire coords_changed = (i != count_i) || (j != count_j);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            i <= 7'd0;
            j <= 7'd0;
        end else begin
            i <= count_i;
            j <= count_j;
        end
    end

    // Cycle `c` across 0 → 1 → 2 → 3 → 0 on no change in i/j
    always @(posedge clk or posedge rst) begin
        if (rst)
            c <= 2'b00;
        else if (coords_changed)
            c <= 2'b00;
        else
            c <= c + 1;
    end

    // Padding logic for 3x3 kernel window access
    wire in_padding = (count_i < pad_x || count_j < pad_y);
    wire is_top = (count_j == pad_y);
    wire is_mid = (count_j == pad_y + 1);

    wire [12:0] base_addr_0 = (count_i - pad_x) + 64 * (count_j - pad_y);
    wire [12:0] base_addr_1 = (count_i - pad_x) + 64 * (count_j - pad_y + 1);
    wire [12:0] base_addr_2 = (count_i - pad_x) + 64 * (count_j - pad_y + 2);

    assign addr = (c < 3) ? (
        in_padding                        ? 13'd0 :
        is_top && c == 2                 ? base_addr_2 :
        is_mid ? (
            (c == 0)                     ? 13'd0 :
            (c == 1)                     ? base_addr_1 :
            (c == 2)                     ? base_addr_2 : 13'd0
        ) :
        (c == 0)                         ? base_addr_0 :
        (c == 1)                         ? base_addr_1 :
        (c == 2)                         ? base_addr_2 : 13'd0
    ) : 13'd0;

endmodule
