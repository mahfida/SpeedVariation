%% The tensors in this script
%  are non-imputed tensors
%  and the model is cp_wopt()
clear

%% step 1  ----------------------------------  
% Read the tensor file
% load '<file path goes here>' e.g
load '../datasets/mat_files/op1_dl_78_mode3_NHM.mat'

% Reshape the file loaded in variable A to correct format
% e.g. shape modes for < nodes, hours, months > is 
% ['number of nodes' 'number of hours' 'number of months'] 
    X = reshape((A),[78 3 11]); 

%% step 2  ----------------------------------  
% When removin outlier node N from tensor X, uncomment following instruction
% and define N= list of outlier nodes id
    %X([N],:,:)=[]
% Load data into different variables
    C_wopt = X;
    C_parafac= X;
    % C_wopt has zero values only at the NaN locations
    C_wopt(isnan(C_wopt))=0; 

% Convert double matrices to tensors
    C_wopt = tensor(C_wopt);
    W_nan = ~isnan(X);
    W_nan = tensor(W_nan);
        
% Set up optimization parameters
        % number of limited memory vectors
        lbfgsb_options.m = 5 % default 5
        % a tolerance setting
        lbfgsb_options.factr = 1e7 % default 1e7
        lbfgsb_options.maxIts = 10000; % default 100
        lbfgsb_options.maxTotalIts = 50000; % default 500
        lbfgsb_options.pgtol = 1e-7; % tolerance related to gradient, default 1e-5

%% step 3  ----------------------------------   
% With 2 components, find best initialization among 100.
    R=2
    min_ff=100000
    min_index=0
    BestU=0
    for(j = 1:100)
            [F{j}, U{j}, out{j}]  = cp_wopt(C_wopt, W_nan, R, ...
                'skip_zeroing',true,'opt','lbfgsb','opt_options', ...
                lbfgsb_options,'lower', 0); 
            ff(j) = out{j}.f;
            if(min_ff > ff(j))
                min_ff = ff(j);
                BestU=U{j};
                min_index = j;
            end
    end
 
% Check to have at least 2 initializations with almost same fit
 % this is to perform congruence check
    index = find( (ff-min_ff) < 1e-4)
    F_1 = F{index(1)};
    F_2 = F{index(2)}; 
 
 % Using N-way parafac method to find corcondia
    Opt =[1e-9 2 0 2 10 25000];
    const=[2 2];% (nonnegativitiy)
    [F2, it,err,corcondia] = parafac(C_parafac,R,Opt,const,BestU);
    % display corcondia
    corcondia
    %the model fit/explained variance is shown by the
    % output of the parafac

%% stp 4 ----------------------------------  
  % Run residual and leverage graph to see if there are any outliers
  % If there are at least a single outlier e.g. 'N', 
  % filter out that node 'N' by running X([N],:,:)=[]; and going back to
  % step 2
    [node_residual, node_leverage] = ResidualLeverage_Outliers_NAN(C_wopt,W_nan, F_1,1);
   
%% step 5 ---------------------------------- 
    % Save the two sets of loadings for congruence check
    % For example for op1 < nodes, hours, months >   
    % These two sets are then input to the Rscripts/CongruenceCheck.R
    % to check uniqueness of the factor
    % set 1
     csvwrite('op1_ni_nhm_node_mode3_3_1.csv',F_1.U{1});
     csvwrite('op1_ni_nhm_hour_mode3_3_1.csv',F_1.U{2});  
     csvwrite('op1_ni_nhm_week_mode3_3_1.csv',F_1.U{3});
    % set 2   
     csvwrite('op1_ni_nhm_node_mode3_3_2.csv',F_2.U{1});
     csvwrite('op1_ni_nhm_hour_mode3_3_2.csv',F_2.U{2});  
     csvwrite('op1_ni_nhm_week_mode3_3_2.csv',F_2.U{3});
  
