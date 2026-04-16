# aOPIT: A Robust Sparse Subspace Tracking Method Using Alpha Divergence With Non-Gaussian Noises
Subspace tracking is a fundamental problem in signal processing, where the goal is to estimate and track the underlying subspace that spans a sequence of data streams over time. In high-dimensional settings, data samples are often corrupted by non-Gaussian noises and may exhibit sparsity. This paper explores the alpha divergence for sparse subspace estimation and tracking, offering robustness to data corruption. 

The proposed algorithm, termed aOPIT, is a robust variant of our OPIT method [(Thanh et al., IEEE TSP 2024)](https://ieeexplore.ieee.org/document/10379829) using alpha divergence. aOPIT outperforms the state-of-the-art robust subspace tracking methods while achieving a low computational complexity and memory storage. 


## Demo
Please run 
+ `test_alpha_OPIT.m`: To illustrate the performance of aOPIT in comparsion with [aFAPI](https://ieeexplore.ieee.org/document/10094931) and [OPIT](https://ieeexplore.ieee.org/document/10379829).

## Reference
This code is free and open source for research purposes. If you use this code, please acknowledge the following paper.

[1] T.G.T. Loan#, N.H. Lan#, N.T.N. Lan#, D.H. Son, T.T.T. Quynh, K. Abed-Meraim, N.L. Trung, **L.T. Thanh**. "[*Robust Sparse Subspace Tracking from Corrupted Data Observations*](https://ieeexplore.ieee.org/document/11231466)". **Proc.  IEEE ISCIT**, 2025. 
