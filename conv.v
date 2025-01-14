`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2024 16:51:13
// Design Name: 
// Module Name: conv1
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


module Conv1(
    input clk,
    input rst,
    input [23:0] pix,
    input [6:0] count_i,
    input [6:0] count_j,
    output [11:0] out_pix
);

    reg [35:0] pixel;
    wire [7:0] pix1, pix2, pix3;
    reg i_change, j_change;
    reg [6:0] i, j;

    parameter [2:0] filter1 = 3'd0, filter2 = 3'd1, filter3 = 3'd0,
                    filter4 = 3'd1, filter5 = 3'd2, filter6 = 3'd1,
                    filter7 = 3'd0, filter8 = 3'd1, filter9 = 3'd0;

    assign pix1 = pix[7:0];
    assign pix2 = pix[15:8];
    assign pix3 = pix[23:16];
    assign out_pix = pixel[35:24];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel <= 0;
            i <= 0;
            j <= 0;
            i_change <= 0;
            j_change <= 0;
        end else begin
            i_change <= |(i ^ count_i);
            j_change <= |(j ^ count_j);
            i <= count_i;
            j <= count_j;

            if (j_change || i_change) begin
                pixel[11:0] <= filter1 * pix1 + filter4 * pix2 + filter7 * pix3;
                pixel[23:12] <= filter2 * pix1 + filter5 * pix2 + filter8 * pix3 + pixel[11:0];
                pixel[35:24] <= filter3 * pix1 + filter6 * pix2 + filter9 * pix3 + pixel[23:12];
            end
        end
    end

endmodule


