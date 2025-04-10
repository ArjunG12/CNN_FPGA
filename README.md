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

### Optimizing intermidatery storage elements:

**In a Standard CNN workflow:**
1. We first compute the full convolution output — e.g., a 64×64 feature map.
2. This is passed through a ReLU activation, resulting in another 64×64 matrix.
3. Then we apply max pooling (e.g., with an 8×8 window and stride 8), which reduces the output to an 8×8 matrix.
4. This means we need to store large intermediate matrices (64×64 for both convolution and ReLU outputs), which can be very memory-intensive.
   
    Also, note: each value in the 8×8 pooled output corresponds to a max value over an 8×8 region from the original 64×64 convolution output.
    For example, the pooling output at (0, 0) depends on all convolution values in the region from (0,0) to (7,7).
After pooling, this 8×8 matrix is usually flattened into a 64×1 vector and passed to a fully connected layer (e.g., producing a 10×1 output for classification).

**My Optimized Implementation:**

In my custom design, I avoid storing large intermediate matrices by fusing the convolution, ReLU, and pooling steps on the fly.

Here's how it works:

For each 8×8 block in the input image:
1. Compute the convolution outputs only for this block.
2. Immediately apply ReLU to these values.
3. Track the maximum value during this process (for pooling).
4. Once the entire block is processed, directly pass this max value as the corresponding input to the fully connected layer.

This way:
1. We don’t store the full 64×64 convolution or ReLU output.
2. We only keep temporary values while processing one 8×8 block at a time.
3. Memory usage is significantly reduced, and computation can be done in a streamed, block-wise manner.


### Pipelining the process
So far, the accelerated CNN algorithm works by:
1. Performing convolution on an 8×8 block,
2. Passing the result through ReLU,
3. Applying max pooling to extract a single value,
4. Feeding that directly into the fully connected (FC) layer.

This pipeline avoids storing intermediate 64×64 matrices, reducing memory usage significantly.

**The Performance Bottleneck**

However, there's a performance issue:
- Processing 3 pixel values (in the ALU + conv → ReLU → max pool) takes about 10 clock cycles (CC).
- But loading pixel values from memory takes around 6 CC.
  
This means the processor must stall between operations, waiting for data to be fetched before continuing — a clear inefficiency.
**The Solution: Pipelining with Interleaved Blocks**

To eliminate stalling, we pipeline the process across multiple 8×8 blocks:
- While Block A's data is being processed (conv, ReLU, etc.),
- We preload pixel values for Block B into another processing unit.
- Then, we go back to Block A, input the next set of pixels,
- And repeat this interleaved flow.
This allows one block to be in the compute stage while another is in the load stage, fully utilizing the available hardware at all times

**Scaling Up with Parallel ALUs**

We extend this by processing multiple 8×8 blocks in parallel, each with its own ALU pipeline:
- Each ALU handles one block at a time,
- All pipelines run concurrently without idle time,
- This ensures no stalling and maximizes throughput.
