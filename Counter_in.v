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
    input clk,          // Clock signal
    input en,
    input reset,        // Reset signal
    output reg [2:0] inner_counter, // Inner counter (3 bits: 0 to 7)
    output reg [2:0] outer_counter  // Outer counter (3 bits: 0 to 7)
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset both counters to 0
            inner_counter <= 3'b000;
            outer_counter <= 3'b000;
        end else if(en) begin
            if (inner_counter == 3'b111) begin
                // If inner counter completes its cycle
                inner_counter <= 3'b000;  // Reset inner counter
                if (outer_counter == 3'b111) begin
                    // If outer counter completes its cycle
                    outer_counter <= 3'b000;  // Reset outer counter
                end else begin
                    // Increment outer counter
                    outer_counter <= outer_counter + 1;
                end
            end else begin
                // Increment inner counter
                inner_counter <= inner_counter + 1;
            end
        end
    end

endmodule
