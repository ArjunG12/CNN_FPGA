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
    output reg [6:0] j
);
    
    reg [1:0] c;
    reg j_change;
    reg c_change;
    // Increment buff
    //reg j_change,c_change;
    //reg 
    // Increment i
    always @(posedge clk or posedge rst) begin
        if (rst)
        begin
            j_change<=0;
            i <= 7'd0; // Ensure 7 bits for 'i' to match the output definition
        end
        else if(en) begin
            if (finish)
            begin
                case(c)
                    2'd0:i<=7'd8;
                    2'd1:i<=7'd0;
                    2'd2:i<=7'd8;
                    2'd3:i<=7'd0;
                endcase
            end
            else if (j_change & ~c_change)
            begin
                case(c)
                    2'd0:i<=7'd0;
                    2'd1:i<=7'd8;
                    2'd2:i<=7'd0;
                    2'd3:i<=7'd8;
                endcase
            end
            else 
            begin
                if((c==2'd0) | (c==2'd2))
                    case(i)
                        7'd0:i<=7'd1;
                        7'd1:i<=7'd2;
                        7'd2:i<=7'd3;
                        7'd3:i<=7'd4;
                        7'd4:i<=7'd5;
                        7'd5:i<=7'd6;
                        7'd6:i<=7'd7;
                        7'd7:i<=7'd8;
                        7'd8:i<=7'd9;
                        7'd9: i<=7'd0;
                    endcase
                else 
                    case(i)
                        7'd8:i<=7'd9;
                        7'd9:i<=7'd10;
                        7'd10:i<=7'd11;
                        7'd11:i<=7'd12;
                        7'd12:i<=7'd13;
                        7'd13:i<=7'd14;
                        7'd14:i<=7'd15;
                        7'd15:i<=7'd16;
                        7'd16:i<=7'd17;
                        7'd17:i<=7'd0; 
                    endcase
             end
                case (c)
                    2'd0:j_change<= ~i[0]&i[3];
                    2'd1:j_change<= ~i[0]&i[4];
                    2'd2:j_change<= ~i[0]&i[3];
                    2'd3:j_change<= ~i[0]&i[4];
                endcase
         end
    end



    // Increment j
    always @(posedge clk or posedge rst) begin
        if (rst)
        begin
            j <= 7'b0; // Ensure 7 bits for 'j' to match the output definition
            
            c_change<=0;
        end
        else if (en)begin
            if (finish)
            begin
                case(c)
                    2'd0:j<=0;
                    2'd1:j<=7'd8;
                    2'd2:j<=7'd8;
                    2'd3:j<=7'd0;
                endcase
            end
            else if(j_change & ~c_change)
            begin
                if((c==2'd0) | (c==2'd1))
                    case(j)
                        7'd0:j<=7'd1;
                        7'd1:j<=7'd2;
                        7'd2:j<=7'd3;
                        7'd3:j<=7'd4;
                        7'd4:j<=7'd5;
                        7'd5:j<=7'd6;
                        7'd6:j<=7'd7;
                        7'd7:j<=7'd0;
                    endcase
                else 
                    case(j)
                        7'd8:j<=7'd9;
                        7'd9:j<=7'd10;
                        7'd10:j<=7'd11;
                        7'd11:j<=7'd12;
                        7'd12:j<=7'd13;
                        7'd13:j<=7'd14;
                        7'd14:j<=7'd15;
                        7'd15:j<=7'd0;
                    endcase
              end
              case (c)
                    2'd0:c_change<=j[0] & j[1] & j[2];
                    2'd1:c_change<=j[0] & j[1] & j[2];
                    2'd2:c_change<=j[0] &j[1] & j[3] & j[2];
                    2'd3:c_change<=j[0] &j[1] & j[3] & j[2];
              endcase
        end
    end
    wire finish =j_change & c_change;
    always @(posedge clk,posedge rst)
    begin
        if(rst)
            c<=0;
        else if (finish & en)
            c<=c+1; 
    end
endmodule

