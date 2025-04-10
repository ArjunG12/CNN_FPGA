module FL (
    input clk,
    input rst,
    input start,
    input [15:0] in_pix,
    output reg [5:0] ind_inp,
    output reg done,
    input [6:0] num,
    input [6:0] num_block,
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

    reg [4:0] j;
    wire [9:0] addr;
    wire [31:0] temp1, temp2, temp3;
    reg [15:0] temp;
    reg [15:0] weight1, weight2, weight3;
    wire [15:0] weight;

    assign addr = j + ((ind_inp << 3) + (ind_inp << 1) + (num_block << 3));

    // Memory and multiplier blocks
    blk_mem_gen_1 w(clk, start, addr, weight);
    mult_gen_1 m1(clk, weight1, in_pix, start, temp1);
    mult_gen_1 m2(clk, weight2, in_pix, start, temp2);
    mult_gen_1 m3(clk, weight3, in_pix, start, temp3);

    // j and ind_inp logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            j <= 5'd0;
            ind_inp <= 6'd0;
            done <= 1'b0;
        end else if (start) begin
            if (ind_inp == num) begin
                done <= 1'b1;
                ind_inp <= 6'd0;
            end else if (j > 5'd25) begin
                ind_inp <= ind_inp + 1;
                j <= 5'd0;
            end else begin
                j <= j + 1;
            end
        end else begin
            done <= 1'b0;
        end
    end

    wire real_j = j[4:1]; // Unused wire (for debug?)

    // Output feature line updates
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_FL0 <= 16'd0;
            output_FL1 <= 16'd0;
            output_FL2 <= 16'd0;
            output_FL3 <= 16'd0;
            output_FL4 <= 16'd0;
            output_FL5 <= 16'd0;
            output_FL6 <= 16'd0;
            output_FL7 <= 16'd0;
            output_FL8 <= 16'd0;
            output_FL9 <= 16'd0;
        end else if (start && ~done) begin
            case (j)
                5'd8:  output_FL0 <= output_FL0 + temp;
                5'd10: output_FL1 <= output_FL1 + temp;
                5'd12: output_FL2 <= output_FL2 + temp;
                5'd14: output_FL3 <= output_FL3 + temp;
                5'd16: output_FL4 <= output_FL4 + temp;
                5'd18: output_FL5 <= output_FL5 + temp;
                5'd20: output_FL6 <= output_FL6 + temp;
                5'd22: output_FL7 <= output_FL7 + temp;
                5'd24: output_FL8 <= output_FL8 + temp;
                5'd26: output_FL9 <= output_FL9 + temp;
            endcase
        end
    end

    // Weight and temp update logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp <= 16'd0;
            weight1 <= 16'd0;
            weight2 <= 16'd0;
            weight3 <= 16'd0;
        end else if (start && ~done) begin
            case (j)
                5'd1:  weight1 <= weight;
                5'd3:  weight2 <= weight;
                5'd5:  weight3 <= weight;
                5'd7:  begin temp <= temp1[31:16]; weight1 <= weight; end
                5'd9:  begin temp <= temp2[31:16]; weight2 <= weight; end
                5'd11: begin temp <= temp3[31:16]; weight3 <= weight; end
                5'd13: begin temp <= temp1[31:16]; weight1 <= weight; end
                5'd15: begin temp <= temp2[31:16]; weight2 <= weight; end
                5'd17: begin temp <= temp3[31:16]; weight3 <= weight; end
                5'd19: begin temp <= temp1[31:16]; weight1 <= weight; end
                5'd21: temp <= temp2[31:16];
                5'd23: temp <= temp3[31:16];
                5'd25: temp <= temp1[31:16];
            endcase
        end
    end

endmodule
