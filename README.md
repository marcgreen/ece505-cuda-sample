ece505-cuda-sample
==================

An example of CUDA C/C++ programming.

The source code "sample.cu" is a sample CUDA C/C++ program with performance comparison to single-core CPU.

To compile on the compute servers:
/usr/local/cuda/bin/nvcc sample.cu -o sample -I/usr/local/cuda/includes -L/usr/local/cuda/lib64

Reference:
- Website:

  http://developer.nvidia.com/cuda-zone
- CUDA C Programming Guide

  http://docs.nvidia.com/cuda/cuda-c-programming-guide
- NVIDIA CUDA Library Documentation

  http://developer.download.nvidia.com/compute/cuda/4_1/rel/toolkit/docs/online/index.html
- CUDA by Example

  http://www.physics.drexel.edu/~valliere/PHYS405/GPU_Story/CUDA_by_Example_Addison_Wesley_Jul_2010.pdf
- SSH From Windows: Graphical Programs (X11 Forwarding)

  http://docs.math.osu.edu/windows/how-tos/ssh-from-windows-graphical-linux-programs-x11-forwarding
- SSH From Mac: Graphical Programs (X11 Forwarding)

  http://docs.math.osu.edu/mac/how-tos/ssh-from-mac-graphical-programs-x11-forwarding

Good luck and have fun!

Created by Wei Dai, modified by Marc Green
