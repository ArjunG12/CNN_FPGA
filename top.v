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
    
    
        module top( input clk,input rst,input [3:0] temp_ind,
            //output [1:0] c,output [7:0] mem_pix_pad,output [6:0] i, output [6:0] j,output [12:0] addr, output [23:0] pix1, output [50:0] pix_ALU,
            output reg [15:0] out_pix,
            output dn
        );
        
        wire  [15:0] output_FL0, output_FL1, output_FL2,output_FL3, output_FL4,output_FL5, output_FL6,output_FL7, output_FL8,output_FL9;
        parameter [3:0] pad_x=2,pad_y=2,pool=8;
        parameter [3:0]num_conv_pool=64/pool;
        parameter [5:0]num_units=16;
        parameter [5:0] num_blocks_one_unit=64/num_units;
        parameter en=1;
        
        wire [1:0]c;
        wire[7:0] mem_pix_pad;
        wire [6:0] i,j;
        wire[12:0] addr;
        wire[47:0] pix_ALU;
        
        blk_mem_gen_0 img(clk,en,addr,mem_pix_pad);
        
        wire [4:0] in_i,in_j;
        wire [2:0] out_i,out_j;
        //wire [6:0] i,j;
        wire clk_2=counter_clk[1];
        wire clk_4=counter_clk[2];
        wire clk_8=counter_clk[3];
        wire clk_16=counter_clk[4];
        wire clk_32= counter_clk[5];
        wire clk_64=counter_clk[6];
        wire clk_128=counter_clk[7];
        wire clk_256=counter_clk[8];
        wire clk_512=counter_clk[9];
        wire clk_1024=counter_clk[10];
        
        reg clk_16_1;
        always @(posedge clk)begin
            if(rst) clk_16_1=0;
            else clk_16_1=clk_16;
        end
        
        
        //wire [7:0] mem_pix_pad;
        //wire [12:0] addr;
        //wire [1:0] c;
        wire [23:0] pix1;
        reg [10:0] counter_clk;
        //assign pix1=0;
        always @(posedge clk, posedge rst)
        begin
            if(rst)counter_clk<=0;
            else counter_clk<=counter_clk+1;
        end
        reg FL_activate;
        assign i=out_i*8+in_i;
        assign j= out_j*8+in_j;
        reg enable_counter;
        counter_out c2(clk_16_1,enable_counter,rst,out_i,out_j);
        counter_in c1(clk_1024,enable_counter,rst,in_i,in_j);
        padding pad1(clk,clk_4,rst,i,j,pad_x,pad_y,addr,c);
        buffer_pad_conv buf1(clk_2,rst,c,mem_pix_pad,pix1);
        ALU a1(clk,pix1,pix_ALU);
        reg [63:0] enable;
        wire [15:0] res_pix [63:0];
        wire i_2;
        assign i_2=i>2;
        genvar g;
        
        generate
            for(g=0;g<64;g=g+1)
            begin
                unit u1(clk,clk_16,rst,enable[g],i_2,pix_ALU,res_pix[g]);
            end
        endgenerate
        
        
        
        always @(posedge clk_16 or posedge rst) begin
        if (rst)
            enable <= 64'd1;  // Reset enable to 1
        else 
            enable <= enable << 1;  // Left shift enable
        end
        reg FL_start;
        
        always@(posedge clk or posedge rst)begin
            if (rst)begin
                FL_start=0;
                enable_counter=1;
            end
            else if((i==7'd63) && (j==7'd64))
            begin
                FL_start=1;
                enable_counter=0;
            end
        end
        
        wire [5:0] ind;
        assign mul=res_pix[ind];
        
        FL f1(clk,rst,FL_start,mul,ind,dn,output_FL0,output_FL1,output_FL2,output_FL3,output_FL4,output_FL5,output_FL6,output_FL7,output_FL8,output_FL9);
        
        always @(posedge dn or posedge rst)
        begin
            if(rst)out_pix<=0;
            else begin
                case(temp_ind)
                    4'd0:out_pix<=output_FL0;
                    4'd1:out_pix<=output_FL1;
                    4'd2:out_pix<=output_FL2;
                    4'd3:out_pix<=output_FL3;
                    4'd4:out_pix<=output_FL4;
                    4'd5:out_pix<=output_FL5;
                    4'd6:out_pix<=output_FL6;
                    4'd7:out_pix<=output_FL7;
                    4'd8:out_pix<=output_FL8;
                    4'd9:out_pix<=output_FL9;
                    
                endcase
            end
        end
    endmodule
