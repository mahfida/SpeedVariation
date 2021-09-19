function [node_residual, node_leverage] = ResidualLeverage_Outliers(Z, Z_bar,type,x_cut,y_cut)

%% step 1 ------------------------
    % type value is different for different methods
    Z=double(Z);
    node_factor =Z_bar.U{1};
    size_Z = size(Z);
    % type =1 for cp_wopt/gcp
    % type =2 for parafac
    % type=3 for tucker and mean
    if type==1
            Z_bar =  full(Z_bar);
    end
            Z_bar = double(Z_bar);

    node_residual=zeros(1,size_Z(1));
    % for each node calculate residual
    for i=1:size_Z(1)
             node_residual(i) =  nansum((Z(i,:,:) - Z_bar(i,:,:)).^2,'all');
    end  
    node_leverage =  diag(node_factor * inv(transpose(node_factor)*node_factor) * transpose(node_factor));
    
 %% step 2 ----------------------
    % Draw scatter plot of leverage and residual
    scatter(node_leverage,node_residual,40,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
    set(gca, 'FontSize', 20)
    xlabel('Leverage','FontSize',20); 
    ylabel('Residual','FontSize',20); 
    % Add textCell
    for ii = 1:size(node_leverage)
        % You have to give a cut value so to visualize the index
        % of the outlier data points on the coordinate plane
        if(node_leverage(ii) > x_cut || node_residual(ii)> y_cut)
            text( node_leverage(ii)+0.004,node_residual(ii)+0.004,ii+"",'FontSize',16) 
        end
    end
   
end

