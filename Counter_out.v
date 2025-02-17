`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2025 01:58:14
// Design Name: 
// Module Name: counter_out
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


module counter_out(
    input clk, 
    input en,
    input rst, 
    output reg [6:0] i, 
    output reg [6:0] j
);
    
    always @(posedge clk or posedge rst)begin
        if (en) begin
            if(rst)begin
                i<=0;
                j<=0;
            end
            else if(i<7) i<=i+1;
            else if(j<7)begin 
                i<=0;
                j<=j+1;
            end
            else begin 
            j<=0;
            i<=0;
            end
        end
    end
endmodule
