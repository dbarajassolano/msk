#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
fout    <- args[1]
Lx      <- as.double(args[2])
Ly      <- as.double(args[3])
Nx      <- as.integer(args[4])
Ny      <- as.integer(args[5])
pad     <- as.integer(args[6])
cor_len <- as.double(args[7])
seed    <- as.integer(args[8])
Nf      <- as.integer(args[9])

library("RandomFields")

dx  <- Lx / Nx
dy  <- Ly / Ny
Lpx <- Lx + pad * dx
Lpy <- Ly + pad * dy
Npx <- Nx + pad
Npy <- Ny + pad

x <- seq(0.5 * dx, 0.5 * (Lpx - dx), length=Npx)
y <- seq(0.5 * dy, 0.5 * (Lpy - dy), length=Npy)

RFoptions(seed=seed, spConform=FALSE)

model <- RMexp(var=1.0, scale=cor_len)
simu  <- RFsimulate(model, x=x, y=y, n=Nf)
write(simu, file=fout, ncolumns=Npx*Npy)

