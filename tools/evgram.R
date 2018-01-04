#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
fin  <- args[1]
fout <- args[2]

library("RandomFields")
RFoptions(seed=0, spConform=FALSE)

data = read.table(fin, header=TRUE)
x <- as.matrix(data[,c("x", "y")])
y <- as.matrix(data[,c("obs")])
emp.vario <- RFempiricalvariogram(x=x, data=y)
write(t(matrix(c(emp.vario$centers, emp.vario$emp.vario), ncol=2)), file=fout, ncolumns=2)