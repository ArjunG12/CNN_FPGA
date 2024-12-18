# CNN_FPGA
Implementation of simple CNN architecture on FPGA

Padding layer-
Inputs- clk, rst, count_i, count_j, pad_x, pad_y,
outputs- addr, c
Description- We input the x and y coordinates of an image in count_i and count_j and the padding values. In return we get the pixel value at that point and 2 points below it per clock cycle. 
![image](https://github.com/user-attachments/assets/8bccfbbd-d851-4987-a094-98bd06839569)
![image](https://github.com/user-attachments/assets/ecba0ba8-2e68-4364-85ce-1c2d96f7b840)
![image](https://github.com/user-attachments/assets/6e941870-2a4f-4d56-863f-b1f50b501ffb)
![image](https://github.com/user-attachments/assets/894830fc-fe63-46ff-9299-3c0f471a011a)
It is synthesized and the following circuit is obtained:
![image](https://github.com/user-attachments/assets/6a586dee-a8b8-4194-b6ee-33ba6a03fe9e)
