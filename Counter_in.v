`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.12.2024 16:01:59
// Design Name: 
// Module Name: counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Cascading counter with enable signals
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module counter_in (
    input clk, 
    input en,
    input rst, 
    output reg [6:0] i, 
    output reg [6:0] j,
    output reg done
);
    
    always @(posedge clk or posedge rst)begin
        if (en) begin
            if(rst)begin
                i<=0;
                j<=0;
                done<=0;
            end
            else if(i<9) i<=i+1;
            else if(j<7)begin 
                i<=0;
                j<=j+1;
            end
            else done<=1;
        end
    end
endmodule
