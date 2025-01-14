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

module counter (
    input clk, 
    input rst, 
    output reg [6:0] i, 
    output reg [6:0] j
);
    reg [2:0] buff;
    wire r, a;

    // Increment buff
    always @(posedge clk or posedge rst) begin
        if (rst)
            buff <= 3'b0;
        else
            buff <= buff + 1'b1;
    end

    assign r = &buff; // Generate enable signal for 'i'

    // Increment i
    always @(posedge clk or posedge rst) begin
        if (rst)
            i <= 7'b0; // Ensure 7 bits for 'i' to match the output definition
        else if (r)
            i <= i + 1'b1;
    end

    assign a = i[3]; // Generate enable signal for 'j'

    // Increment j
    always @(posedge clk or posedge rst) begin
        if (rst)
            j <= 7'b0; // Ensure 7 bits for 'j' to match the output definition
        else if (a)
            j <= j + 1'b1;
    end
endmodule

