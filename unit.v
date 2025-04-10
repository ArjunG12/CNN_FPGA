`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2025 00:55:26
// Design Name: 
// Module Name: unit
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


module unit( input clk ,input clk_8_5,input rst ,input num_block_change,input enable,input i_2,input [47:0] in_pix,output [15:0] out_pix
        );
        
        wire [15:0] pix_conv;
        wire [15:0] out_relu;
        Conv1 conv1(clk,clk_8_5,rst,num_block_change,enable,in_pix,pix_conv);
        relu r1(pix_conv,out_relu);
        //assign out_relu=pix_conv;
        pooling pool1(clk,rst,num_block_change,i_2,out_relu,out_pix);
    endmodule
