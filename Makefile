sample: sample.cu
	/usr/local/cuda/bin/nvcc sample.cu -o sample -I/usr/local/cuda/includes -L/usr/local/cuda/lib64
clean:
	rm sample