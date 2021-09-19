library(imputeTS)
library(R.matlab)
library(tensorA)
library(pracma)

# Read data file
# op1 data file--------------------------
    op1.dl<-read.table("/Users/mahrukh/SpeedVariation/datasets/raw_data/matrix_form/op1_matrix_dl.csv",sep=",", header=TRUE)
    ZZ=t(as.matrix(op1.dl))

#OR 
# op2 data file--------------------------
    # op2.dl<-read.table("/Users/mahrukh/SpeedVariation/datasets/raw_data/matrix_form/op2_matrix_dl.csv",sep=",", header=TRUE)
    # ZZ=t(as.matrix(op2.dl))

# Convert into 3 dim matrix--------------------------
    days = c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    total_days = sum(days)-30-31+13
    CT1<-SplitTime(ZZ)

# Remove already noted down outlier nodes from the---
#  ---leverage and residual graph-----------
    # for op 1 week----------
      CD2=CT1[-c(5,36),,]
    # op 2 month
      # CD2=CT1[-c(5),,]
    # for op2 week------------
      #CD2=CT1[-c(1  ,5 ,17, 23, 37 ,69),,]
    # for op2 month------------
      #CD2=CT1[-c(5,17,23,69),,]

# Perform Imputation----------
    nn = dim(CD2)[1]
    u<-seq(1,nn)
    X<-3
    Y<-317
    K<- matrix(CD2, nrow = length(u), ncol = X*Y, byrow = FALSE,
               dimnames = list(u, seq(1,X*Y,1)))
    B=(K)
    for(i in 1:dim(K)[1]){
    K[i,]<-na_kalman(B[i,], model = "StructTS", smooth = TRUE, type = 'level')
    }


# Save imputed data in tensor form----------------
CT1<-SplitTime(K)

# For <nodes, hours, months> tensor
result<-CollapseWeek(CT1)
# For <nodes, hours, months> tensor
  # result<-CollapseDays(CT1) 

CD2= result$a
nn = dim(CD2)[1]
u<-seq(1,nn)
X<-3
Y<-7
A<- matrix(CD2, nrow = length(u), ncol = X*Y, byrow = TRUE,
           dimnames = list(u, seq(1,X*Y,1)))

library(R.matlab)
filename <- paste("op1_dl_74_mode3_NHW_imputed", ".mat", sep = "")
writeMat(filename, A = t(A))
# 4 D data-----------


