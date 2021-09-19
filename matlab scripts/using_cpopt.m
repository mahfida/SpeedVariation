clear

%% step 1  ----------------------------------  
% Read the tensor file
% load '<file path goes here>' e.g
load '../datasets/mat_files/op1_dl_78_mode3_NHM_imputed.mat'

% Reshape the file loaded in variable A to correct format
% e.g. shape modes for < nodes, hours, week days > is ['number of nodes' 'number of hours' 'number of week days'] 
    X = reshape((A),[78 3 11]); 

%% step 2  ----------------------------------  
% Load data into different variables
    C_opt = X;
    C_parafac= X;
% Convert double matrices to tensors
    C_opt = tensor(C_opt);
    W_nan = ~isnan(X);
    W_nan = tensor(W_nan);

    
%% step 3  ----------------------------------   
% With 2 components, find best initialization aamong 100
    R=2
    max_ff=0
    max_index=0
    BestU=0
    for(j = 1:100)
            [F{j}, U{j}, out{j}]  = cp_opt(C_opt,  R, 'opt','lbfgsb','lower',0); 
            ff(j) = out{j}.Fit;
            if(max_ff < ff(j))
                BestU=U{j};
                max_ff = ff(j);
                max_index = j;
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
    [F2, it,err,corcondia, fit_parafac] = parafac(C_parafac,R,Opt,const,BestU);
    % display corcondia and model fit
    corcondia
    fit_parafac

%% stp 4 ----------------------------------  
  % Run visual residual and leverage graph t see if there are any outliers
  % If there are at least a single outlier e..g. 'n', 
  % filter out that node 'n' by running X([n],:,:)=[]; and going back too
  % step 2
    [node_residual, node_leverage] = ResidualLeverage_Outliers(C_wopt, F_1,1,0,0);
   
%% step 5 ---------------------------------- 
    % Save the two sets of loadings for cngruence check
    % For example for op1 < nodes, hours, months >   
     csvwrite('op1_i_nhm_node_mode3_3_1.csv',F_1.U{1});
     csvwrite('op1_i_nhm_hour_mode3_3_1.csv',F_1.U{2});  
     csvwrite('op1_i_nhm_week_mode3_3_1.csv',F_1.U{3});   
     csvwrite('op1_i_nhm_node_mode3_3_2.csv',F_2.U{1});
     csvwrite('op1_i_nhm_hour_mode3_3_2.csv',F_2.U{2});  
     csvwrite('op1_i_nhm_week_mode3_3_2.csv',F_2.U{3});
  