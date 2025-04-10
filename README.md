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

### Normal Convolution Logic
In a Convolutional Neural Network (CNN), the convolution layer extracts features from the input by sliding a small filter (kernel) over it.
Assuming a 3×3 filter and stride of 1:
1. At each position, a 3×3 patch of the input is selected.
2. This patch is element-wise multiplied with the filter.
3. The sum of these values gives one number, placed in the output feature map.
4. The filter then moves to the next position and repeats the process.
    
This creates a new 2D output (feature map) that highlights specific features, depending on the filter's values.

### Relu layer
The ReLU layer applies an element-wise activation function that introduces non-linearity into the model. It’s simple and fast, and helps CNNs learn complex patterns.

For each value xx in the input:

**ReLU(x) = max(0, x)**

In other words:
1. If the value is positive, keep it.
2. If it’s negative, set it to 0.

This doesn't change the size of the feature map — only its values.

### Pooling layer
The pooling layer reduces the spatial size of the input feature map, helping to:

1. Reduce computation
2. Make the model more robust to small translations
3. Prevent overfitting

The most common types are:

1. Max Pooling: Takes the maximum value in a region.
2. Average Pooling: Takes the average value.
    
We are using MaxPooling in my implementation.

Assuming a 2×2 max pooling with stride 2:

1. A 2×2 patch is selected from the input.
2. The maximum value in that patch is selected.
3. That value is placed in the output.
4. The window moves 2 steps and repeats.

This cuts the width and height of the feature map in half.


## My optimized and accelerated implementation

So in my implementation I have implemented the following things:
### Acceralted conv logic:

In a standard convolution operation with a 3×3 filter, we need to access a 3×3 patch of pixels at each position — that is, 9 pixel values — multiply each with the corresponding filter weight, sum the results, and store the output.

However, in my custom implementation, I’ve optimized this by only requiring a subset of those 9 pixel values at each step.

Specifically:

At any given position (say a34), I only use the pixel values at:

1. a34 (current position),
2. a44 (one row below),
3. a54 (two rows below).

Using these three vertically-aligned pixels, I compute the partial convolution result for that position.

Then, I slide the filter to the right (e.g., to a35) and repeat the same process using the corresponding vertically-aligned pixels there (a35, a45, a55), and so on.

This approach allows for a more memory-efficient and potentially faster implementation, especially when data is streamed row-by-row or when full patches are not readily available.

### Optimizing intermidatery storage elements

In stardard flow, we compute the output of the conv layer (output is 64*64 matrix), then we pass it through Relu(output is 64*64 matrix) and then finally through MaxPool layer(output is 8*8 matrix). If we store the itermidatery matrixes then it will be too memory expensive. Thing to note here is that one output of the pooling layer depends on 8*8 subsection on the orignal image. For example output at the first index of 
