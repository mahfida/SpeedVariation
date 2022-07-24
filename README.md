### SpeedVariation ######
In this repository we have included some basis data files and scripts
regarding our study on download speed variation, in two mobile broadband operators.

### dataset ------------------
The "dataset" directory consists of raw download speed measurements (i.e., in raw_data folder)
collected from around 70-80 static nodes, served by two mobile broadband operators. 
It also consists of the download speed and metadata measurements in the form of 2D matrix. 

Additionally, it contains speed variation data of "original" and "adjusted" (imputed) download
measurements in 3-way tensors in mat_files folder. 

Further it stores the non-normalized loading files from the tensor factorization in the
loadin_files folder.


### matlab_scripts -----------
The "matlab_scripts" consists of scripts for running cpwopt() and cpopt() on the tensors to 
reveal loadings/patterns in 3 dimensions. It also has a script for outlier detection via 
residual and leverage scatter plot.

### Rcripts -----------------
The "R scripts" consists scripts for congruence check between two set of loadings from same 
tensor, a script to impute missing data via Kalman Smoothing and some other supporting methods.
