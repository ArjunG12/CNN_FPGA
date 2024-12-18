`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2024 04:45:50
// Design Name: 
// Module Name: padding
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

//i/o:-
//count_i- the x coordinate
//count_j- the y coordinate
//pad_x- padding in x dir
//pad_y- padding in y dir
//pix- output pixel at count_i and count_j wrt after padding
//conv1_clk - clk with 1/3 freq
//c- 3 N counter
module padding( input clk,input rst,input [6:0] count_i,input [6:0] count_j,input [3:0] pad_x,input [3:0] pad_y, output reg [12:0] addr, output reg [1:0] c

    );
    reg r;
    always@(posedge clk or posedge rst or posedge r)
    begin
        if (rst ) begin
            c<=0;
            addr<=0;
            r<=0;
           
        end
        else if (r)
        begin
            c<=0;
            r<=0;
        end
        else
        begin
            case (c)
                2'b00:c<=2'b01;
                2'b01:c<=2'b10;
                2'b10:c<=2'b00;
                2'b11:c<=2'b00;
            endcase
        
            if(count_i<pad_x)
            begin
                addr<=13'd0;
            end
            else if(pad_y>(2+count_j)) 
            begin
                addr<=13'd0;
            end
            else if (pad_y==(2+count_j))
            begin
                
                case (c)
                    2'd2:addr<=13'd0;
                    2'd0:addr<=13'd0;
                    2'd1:addr<=count_i-pad_x+64*(count_j-pad_y+2);//read from count_i-pad_x,count_j-pad_y+2 pos
                endcase
                
            end
            else if (pad_y==(1+count_j))
            begin
                
                case (c)
                    2'd2:addr<=13'd0;
                    2'd0:addr<=count_i-pad_x+64*(count_j-pad_y+1);//read from count_i-pad_x,count_j+1-pad_y pos
                    2'd1:addr<=count_i-pad_x+64*(count_j-pad_y+2);//read from count_i-pad_x,count_j+2-pad_y pos
                endcase
            end
            else 
            begin 
                case (c)
                    2'd2:addr<=count_i-pad_x+64*(count_j-pad_y);//read from count_i-pad_X,count_j-pad_y pos
                    2'd0:addr<=count_i-pad_x+64*(count_j-pad_y+1);//read from count_i-pad_x,count_j-pad_y+1 pos
                    2'd1:addr<=count_i-pad_x+64*(count_j-pad_y+2);//read from count_i-pad_x,count_j-pad_y+2 pos
                endcase
            end
        end
        
    end
    reg [6:0] i,j;
    
    always @(posedge clk)
    begin
        r=|(i^count_i) | |(j^count_j);
        i=count_i;
        j=count_j;
    end
    
endmodule
