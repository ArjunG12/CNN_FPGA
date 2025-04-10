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
    input clk_8_5,
    input rst,
    input num_block_change,
    input enable,
    input [47:0] pix,
    output [15:0] out_pix
);

    reg [47:0] pixel;
    wire [15:0] p1,p2,p3;
    
    always @(posedge clk or posedge rst) begin
        if (rst) 
        begin
            pixel <= 0;
        end 
        else if (num_block_change)pixel<=0;
        else if(enable) begin
                pixel[15:0] <= p1;
                pixel[31:16] <= p2;
                pixel[47:32] <= p3;
        end
    end
    assign out_pix=pixel[47:32];
    assign p1=pix[15:0];
    assign p2=pix[31:16] + pixel[15:0];
    assign p3=pix[47:32] + pixel[31:16];
    //c_addsub_0 a5(pix[33:17],pixel[16:0],clk,p2);
    //c_addsub_0 a8(pix[50:34],pixel[33:17],clk,p3);
    

    
endmodule
