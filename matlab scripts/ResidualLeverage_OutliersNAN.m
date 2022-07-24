% The function takes Z: original tensor, Z_bar: The modelled tensor
% For the missing values, it take W_nan, so that not to consider
% missing entries in residual computation
% type: a selector for modifying class of Z_bar to that of Z, 
% e.g. for cp_opt, it changes class of Z_bar from'ktensor' to 'tensor'

function [node_residual, node_leverage] = ResidualLeverage_OutliersNAN(Z,W_nan, Z_bar,type)

    Z=double(Z);
    [n , p] = size((Z_bar.U{1}));
    node_factor =Z_bar.U{1};
        % type =1 for cp_wopt/gcp
        % type =2 for parafac
        % type=3 for tucker and mean
        if type==1
            Z_bar =  full(Z_bar);
        end
            Z_bar = double(Z_bar);
            W_nan_2 = double(W_nan);

        % Create an array of zeros with length
        % equal to first mode of Z (i.e. node mode)
        node_residual=zeros(1,n);
        scaled_residuals=zeros(1,n);

        % Calculate residual for each node 
        for i=1:n
             node_residual(i) =  nansum((Z(i,:,:).*W_nan_2(i,:,:) - Z_bar(i,:,:).*W_nan_2(i,:,:)).^2,'all');
        end  
        scaled_residuals = node_residual/sum(node_residual);


        % Calculate leverage for each node 
        node_leverage =  diag(node_factor * inv(transpose(node_factor)*node_factor) * transpose(node_factor));
        leverage_cutoff_huber_relaxed= 0.5;
        
        % Cut-off
        residual_cutoff_3xSTD = std(scaled_residuals)*3;
        residuals_standard_deviation = std(scaled_residuals);
       

        % Create scatter plot from the node_residual and node leverage
        scatter(node_leverage,scaled_residuals,40,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
        set(gca, 'FontSize', 20);
        xlabel('Leverage score','FontSize',20); 
        ylabel('Normalized residual','FontSize',20); 
        yline(residual_cutoff_3xSTD,'-',{'Residual','Cut-off'},'LineWidth',2,'Color','red','LineStyle','--','FontSize',14)
        xline(leverage_cutoff_huber_relaxed,'-', {'Leverage','Cutoff'},'LineWidth',2,'Color','red','LineStyle','--','FontSize',14)
        
    
        % Note down the ids of the outlier nodes by adding text: nodeids
        % to the nodes
 
        for ii = 1:size(node_leverage)
            if(node_leverage(ii) > leverage_cutoff_huber_relaxed ||scaled_residuals(ii)> residual_cutoff_2xSTD)
            text( node_leverage(ii)+0.004,scaled_residuals(ii)+0.004,ii+"",'FontSize',16) 
            end
        end
   
end
