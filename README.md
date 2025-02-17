# CNN_FPGA
Implementation of simple CNN architecture on FPGA

## Padding layer

Inputs- clk, rst, count_i, count_j, pad_x, pad_y,
outputs- addr, c
Description- We input the x and y coordinates of an image in count_i and count_j and the padding values. In return we get the pixel value at that point and 2 points below it per clock cycle. 
![image](https://github.com/user-attachments/assets/8bccfbbd-d851-4987-a094-98bd06839569)
![image](https://github.com/user-attachments/assets/ecba0ba8-2e68-4364-85ce-1c2d96f7b840)
![image](https://github.com/user-attachments/assets/6e941870-2a4f-4d56-863f-b1f50b501ffb)
![image](https://github.com/user-attachments/assets/894830fc-fe63-46ff-9299-3c0f471a011a)

## Buffer_pad_to_conv 

Inputs-clk, rst, c, pix
Output-p 
Acts as a buffer from the padding layer to  the convolution layer. Inputs 1-pixel value at a time and outputs 3-pixel values. 
![image](https://github.com/user-attachments/assets/3cf5292c-fc4f-47e1-9323-89319afe813e)
(updated it such that each addr value matches with c value)

## Convolution layer

Inputs- clk, rst, [23:0]pix, [6:0]count_i, [6:0]count_j
Outputs- [11:0] out_pix

If count_i is given 3 values in ascending order then it will return the convolution value after the 3 values have been passed as seen in the figure.
![image](https://github.com/user-attachments/assets/dd5c956e-c18f-42d2-b856-d364950845ee)

## Counters
There are two counters counter_in and counter_out. The image is divided into 64 small blocks of pixels and in each block, the coordinate is controlled by counter_in while counter_out controls which block we are operating on.

Counter_in
![image](https://github.com/user-attachments/assets/24478612-b44b-43ab-a073-3fffafeddea0)
![image](https://github.com/user-attachments/assets/ac68f9e5-2709-421d-a6ae-2a5daf51b883)
Counter_out
![image](https://github.com/user-attachments/assets/4f4d75db-19aa-4348-93a8-2dc1c86aa1b9)
For final i,j:

final_i=outer_i*8+inner_i;

final_j=outer_j*+outer_j;

NOTE: For the current design, counter_in must be given clk with f/1024 and counter_out must be given with frequency f/16.
