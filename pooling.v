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


module pooling(input clk,input rst,input dn,input [11:0] pix,  output reg [11:0] out_pix
    );
    always @(posedge clk or posedge rst or posedge dn)
    begin
        if (rst)out_pix<=0;
        else if (dn) out_pix<=0;
        else if(pix>out_pix)out_pix<=pix;
    end
endmodule
