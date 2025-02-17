`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2025 19:30:42
// Design Name: 
// Module Name: ALU
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


module ALU(input clk, input [23:0] pix, output [47:0] out_pix

    );
    wire [23:0] F1,F2,F3,F4,F5,F6,F7,F8,F9,A1,A2,A4;
    wire [15:0] p1,p2,p3;
    wire [7:0] pix1, pix2, pix3;
    assign pix1 = pix[7:0];
    assign pix2 = pix[15:8];
    assign pix3 = pix[23:16];
    parameter [15:0] filter1 = 16'b0011011100111101, filter2 = 16'b0011100010110111, filter3 = 16'b0101100100011101,
                     filter4 = 16'b0000001000100101, filter5 = 16'b0001001001101110, filter6 = 16'b0001010111000011,
                     filter7 = 16'b1010100010100011, filter8 = 16'b1101111000100010, filter9 = 16'b1101100000011100;
                    
    mult_gen_0 m1(clk,pix1,filter1,F1);
    mult_gen_0 m2(clk,pix1,filter2,F2);
    mult_gen_0 m3(clk,pix1,filter3,F3);
    mult_gen_0 m4(clk,pix2,filter4,F4);
    mult_gen_0 m5(clk,pix2,filter5,F5);
    mult_gen_0 m6(clk,pix2,filter6,F6);
    mult_gen_0 m7(clk,pix3,filter7,F7);
    mult_gen_0 m8(clk,pix3,filter8,F8);
    mult_gen_0 m9(clk,pix3,filter9,F9);
    wire [15:0] f1,f2,f3,f4,f5,f5,f6,f7,f8,f9;
    assign f1=F1[23:8];
    assign f2=F2[23:8];
    assign f3=F3[23:8];
    assign f4=F4[23:8];
    assign f5=F5[23:8];
    assign f6=F6[23:8];
    assign f7=F7[23:8];
    assign f8=F8[23:8];
    assign f9=F9[23:8];
    
    c_addsub_0 a1(f1,f4,clk,A1);
    c_addsub_0 a2(A1,f7,clk,p1);
    c_addsub_0 a3(f2,f5,clk,A2);
    c_addsub_0 a4(A2,f8,clk,p2);
    c_addsub_0 a6(f3,f6,clk,A4);
    c_addsub_0 a7(A4,f9,clk,p3);
    
    assign out_pix={p1,p2,p3};
endmodule
