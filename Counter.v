`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2025 12:41:52 AM
// Design Name: 
// Module Name: counter_
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


module counter_(input clk,input rst, input [6:0] num,output [6:0] i,output [6:0] j ,output reg [6:0] count_out, output  finish,output reg num_block_change, output 
    reg [6:0] num_block

    );
    reg [3:0] in_i,in_j;
    
    always@(posedge clk,posedge rst)begin
        if(rst) begin
            count_out<=0;
            in_i<=0;
            in_j<=0;
            num_block<=0;
            num_block_change<=0;
        end
        else begin
            if(~finish) begin
                
                if (count_out<num-1) begin 
                    count_out<=count_out+1;
                    num_block_change<=0;
                end
                else if((in_i==7)&& (in_j==7))begin
                    num_block<=num_block+1;
                    count_out<=0;
                    in_j<=0;
                    in_i<=0;
                    num_block_change<=1;
                end
                else begin
                    num_block_change<=0;
                    count_out<=0;
                    if(in_i<7)in_i<=in_i+1; 
                    else begin
                        in_j<=in_j+1;
                        in_i<=0;
                    end
                    
                      
                end
            end
        end
    end
    wire [6:0]count_out_=count_out + num_block* num;
    
    wire [5:0] out_i,out_j;
    assign out_i=(count_out_[2:0]) ;
    assign out_j=(count_out_>>3) ;
    
    assign i=(out_i<<3)+in_i;
    assign j= (out_j<<3)+in_j;
    assign finish= (i==63) && (j==63);
    
endmodule
