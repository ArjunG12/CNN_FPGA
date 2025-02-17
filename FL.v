`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2025 01:02:03
// Design Name: 
// Module Name: FL
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


module FL(
    input clk,input rst,input start, input [15:0] in_pix,output reg [5:0] ind_inp, output reg done,
    output reg [15:0] output_FL0,
    output reg [15:0] output_FL1,
    output reg [15:0] output_FL2,
    output reg [15:0] output_FL3,
    output reg [15:0] output_FL4,
    output reg [15:0] output_FL5,
    output reg [15:0] output_FL6,
    output reg [15:0] output_FL7,
    output reg [15:0] output_FL8,
    output reg [15:0] output_FL9
    );
    
    reg [4:0]j;
    wire [9:0]addr;
    wire [31:0] temp1,temp2,temp3;
    reg [15:0] temp;
    reg [15:0]weight1,weight2,weight3;
    
    wire [15:0]weight;
    assign addr = j + (ind_inp << 3) + (ind_inp << 1);
    
    blk_mem_gen_1 w(clk,start,addr,weight);
    mult_gen_1 m1(clk,weight1,in_pix,start,temp1);
    mult_gen_1 m2(clk,weight2,in_pix,start,temp2);
    mult_gen_1 m3(clk,weight3,in_pix,start,temp3);
    
    
        
   always @(posedge clk or posedge rst)begin
        if(rst)begin
            j<=5'd0;
            ind_inp<=0;
             done<=0;
        end
        else if (start)begin
            if (ind_inp==6'd63)begin
                done<=1;
                ind_inp<=0;
            end
            else if(j>5'd25)
            begin
                ind_inp<=ind_inp+1;
                j<=0;
            end
            else j<=j+1;
        end
   end
   wire real_j;
   assign real_j=j[4:1];
   always @(posedge clk or posedge rst)
   begin
        if(rst)
        begin
            output_FL0<=0;
            output_FL1<=0;
            output_FL2<=0;
            output_FL3<=0;
            output_FL4<=0;
            output_FL5<=0;
            output_FL6<=0;
            output_FL7<=0;
            output_FL8<=0;
            output_FL9<=0;      
            
        end
        else begin
            case(j)
                5'd8:output_FL0<=output_FL0+temp;
                5'd10:output_FL1<=output_FL1+temp;
                5'd12:output_FL2<=output_FL2+temp;
                5'd14:output_FL3<=output_FL3+temp;
                5'd16:output_FL4<=output_FL4+temp;
                5'd18:output_FL5<=output_FL5+temp;
                5'd20:output_FL6<=output_FL6+temp;
                5'd22:output_FL7<=output_FL7+temp;
                5'd24:output_FL8<=output_FL8+temp;
                5'd26:output_FL9<=output_FL9+temp;
            endcase
        end
   end
   
   always @(posedge clk or posedge rst)
   begin
        if(rst)begin
            temp<=0;
            weight1<=0;
            weight2<=0;
            weight3<=0;
        end
        else if(start) begin
            case(j)
                5'd1:
                begin
                    weight1<=weight;
                end
                5'd3:
                begin
                    weight2<=weight;
                end
                5'd5:
                begin
                    weight3<=weight;
                end
                5'd7:
                begin 
                    temp<=temp1[31:16];
                    weight1<=weight;
                end
                5'd9:
                begin
                    temp<=temp2[31:16];
                    weight2<=weight;
                end
                5'd11:
                begin 
                    temp<=temp3[31:16];
                    weight3<=weight;
                end
                5'd13:
                begin 
                    temp<=temp1[31:16];
                    weight1<=weight;
                end
                5'd15:begin 
                    temp<=temp2[31:16];
                    weight2<=weight;
                end
                5'd17:begin 
                    temp<=temp3[31:16];
                    weight3<=weight;
                end
                5'd19:begin 
                    temp<=temp1[31:16];
                    weight1<=weight;
                end
                5'd21:begin 
                    temp<=temp2[31:16];
                end
                5'd23:begin
                    temp<=temp3[31:16];
                end
                5'd25:
                begin 
                    temp<=temp1[31:16];
                end
            endcase
        end 
   end
   
   
   always @(posedge dn or posedge rst)begin
        
   end
endmodule
