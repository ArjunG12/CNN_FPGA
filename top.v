    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 26.11.2024 15:47:25
    // Design Name: 
    // Module Name: top
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // Dependencies: 
    // 
    //////////////////////////////////////////////////////////////////////////////////
    
    
    module top( input clk,input rst, output  [6:0] i ,output [6:0] j,output [7:0] pix1,
                output [12:0]addr,
                output [1:0]c,output [23:0] pix,
                output [11:0] out_pix,output [11:0] out_pix2
        );
        parameter en=1;
        blk_mem_gen_0 img(clk,en,addr,pix1);
        parameter [3:0] pad_x=0,pad_y=0,pool=8;
        parameter [3:0]num_conv_pool=64/pool;
        reg [1:0] counter_clk;
        
        always @(posedge clk, posedge rst)
        begin
            if(rst)counter_clk<=0;
            else counter_clk<=counter_clk+1;
        end
        wire clk1=counter_clk[1];
        counter c1(clk1,rst,i,j);
        padding pad1(clk1,rst,i,j,pad_x,pad_y,addr,c);
        buffer_pad_conv buf1(clk1,rst,c,pix1,pix);
        Conv1 conv1(clk1,rst,pix,i,j,out_pix);
        pooling pool1(clk1,rst,rst,out_pix,out_pix2);
    endmodule
