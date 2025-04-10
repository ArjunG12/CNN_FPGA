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

## ALU layer

Used for filter multiplication with pixel values.
Inputs- clk, [23:0] pix
Outputs- [47:0] out_pix

Takes 3 filter values from Buffer and then multiply it with filter values according to the convolution logic.
![image](https://github.com/user-attachments/assets/ae6e37d8-9cea-4368-8650-7f4f0412829c)



