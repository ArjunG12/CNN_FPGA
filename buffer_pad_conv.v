`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2024 14:03:40
// Design Name: 
// Module Name: buffer_pad_conv
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


module buffer_pad_conv(
    input clk,input rst,input [1:0]c,input [7:0] pix, output reg [23:0] p
    );
    initial p=0;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            p<=0;
            c_1<=0;
        end
        else
        begin
            case (c_1)
                2'b00:p[7:0]=pix;
                2'b01:p[15:8]=pix;
                2'b10:p[23:16]=pix;
                2'b11:p=0;
            endcase
       end
    end
    reg [1:0] c_1;
    always @(posedge clk)
    begin
        c_1<=c;
    end
endmodule
