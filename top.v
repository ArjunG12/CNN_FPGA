module top(
    input clk__,
    input rst,
    output [15:0] output_fl0,output_fl1,output_fl2,output_fl3,output_fl4,output_fl5,output_fl6,output_fl7,output_fl8,output_fl9,
    output reg enable_counter
);

    // Constants
    parameter [3:0] pad_x = 2, pad_y = 2;
    parameter [6:0] num = 8;
    parameter en = 1;

    // Internal signals
    wire [15:0] res_pix [num-1:0];
    reg  [15:0] pix_FL [num-1:0];
    reg  [num-1:0] enable;
    wire [23:0] pix1;
    wire [15:0] output_FL[9:0];
    wire [1:0]  c;
    wire [7:0]  mem_pix_pad;
    wire [6:0]  i, j;
    wire [12:0] addr;
    wire [47:0] pix_ALU;
    wire        i_2;
    wire [5:0]  ind;
    wire        counter_done, counter_done_changed;
    wire [15:0] mul;
    wire        dn;
    wire [6:0]  num_block, count_out;
    wire        num_block_change;
    reg         num_block_change_buffer;
    reg         FL_start;
    reg         counter_done_buff;
    reg  [23:0] buff_ALU;
     
    // Clock division logic
    reg [2:0] clk_t;
    wire clk;
    always @(posedge clk__ or posedge rst)
        if (rst) clk_t <= 0;
        else clk_t <= clk_t + 1;
    assign clk = clk_t[2];

    reg [10:0] counter_clk;
    always @(posedge clk or posedge rst)
        if (rst) counter_clk <= 11'b111_1111_1111;
        else counter_clk <= counter_clk - 1;

    wire clk_4 = counter_clk[2];
    wire clk_256 = counter_clk[8];

    // Generate multi-stage delayed clock for pipelining
    reg [6:0] clk_4_7;
    always @(posedge clk) begin
        if (rst) clk_4_7 <= 0;
        else clk_4_7 <= {clk_4_7[5:0], clk_4};
    end
    wire clk_44 = clk_4_7[6];

    // Memory instantiation
    blk_mem_gen_0 img(clk, en, addr, mem_pix_pad);

    // Buffer for block change detection
    always @(posedge clk_4 or posedge rst)
        if (rst) num_block_change_buffer <= 0;
        else num_block_change_buffer <= num_block_change;

    // Track counter_done edge
    always @(posedge clk or posedge rst)
        if (rst) counter_done_buff <= 0;
        else counter_done_buff <= counter_done;
    assign counter_done_changed = counter_done ^ counter_done_buff;

    // FL and counter enable logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            FL_start <= 0;
            enable_counter <= 1;
        end else begin
            if (num_block_change_buffer || counter_done_changed)
                FL_start <= 1;
            else if (dn)
                FL_start <= 0;

            if (counter_done)
                enable_counter <= 0;
        end
    end

    // Counter and CNN unit control
    counter_ cc(clk_4, rst, num, i, j, count_out, counter_done, num_block_change, num_block);

    // Padding and convolution
    padding pad1(clk, counter_clk[1], rst, i, j, pad_x, pad_y, addr, c);
    buffer_pad_conv buf1(clk, rst, c, mem_pix_pad, pix1, /* unused */);
    always @(posedge clk_256 or posedge rst)
        if (rst) buff_ALU <= 0;
        else buff_ALU <= pix1;

    ALU a1(clk, buff_ALU, pix_ALU);

    assign i_2 = i[2:0] > 1;

    // CNN units
    genvar g;
    generate
        for (g = 0; g < num; g = g + 1) begin : CNN_UNITS
            unit u1(clk, clk_44, rst, num_block_change_buffer, enable[g], i_2, pix_ALU, res_pix[g]);
            always @(posedge clk or posedge rst)
                if (rst) pix_FL[g] <= 0;
                else if (num_block_change) pix_FL[g] <= res_pix[g];
        end
    endgenerate

    // Enable one CNN unit at a time
    always @(posedge clk_4 or posedge rst) begin
        if (rst) enable <= 1;
        else if (enable_counter) begin
            enable <= 0;
            enable[count_out == 0 ? num - 1 : count_out - 1] <= 1;
        end
    end

    // Fully Connected Layer
    FL f1(clk, rst, FL_start, mul, ind, dn, num, num_block,
        output_FL[0], output_FL[1], output_FL[2], output_FL[3], output_FL[4],
        output_FL[5], output_FL[6], output_FL[7], output_FL[8], output_FL[9]);

    assign mul = pix_FL[ind];
    
    assign output_fl0=output_FL[0];
    assign output_fl1=output_FL[1];
    assign output_fl2=output_FL[2];
    assign output_fl3=output_FL[3];
    assign output_fl4=output_FL[4];
    assign output_fl5=output_FL[5];
    assign output_fl6=output_FL[6];
    assign output_fl7=output_FL[7];
    assign output_fl8=output_FL[8];
    assign output_fl9=output_FL[9];
