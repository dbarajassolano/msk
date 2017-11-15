clear all;

L       = [2.0, 1.0];
N       = [256, 128];
geom    = geom_2d(L, N);
pad     = 8;
cor_len = 0.05;
seed    = 0;

filename_fine   = 'ref_256x128_fine.txt';
filename_coarse = 'ref_256x128_coarse.txt';

[y_fine, y_coarse, y_padded] = refgen(L, N, pad, cor_len, filename_fine, filename_coarse, seed);
