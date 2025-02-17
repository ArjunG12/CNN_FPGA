`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.12.2024 10:00:10
// Design Name: 
// Module Name: pooling
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


module pooling(
    input clk,
    input rst,
    input i_2,                   // Control signal
    input [15:0] pix,            // Incoming pixel value
    output reg [15:0] out_pix    // Stores the max pixel value
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            out_pix <= 16'b0;  // Ensure proper reset
        else if ((pix > out_pix) && i_2) // Use logical AND (&&)
            out_pix <= pix;
    end
endmodule
