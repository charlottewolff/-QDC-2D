function nodes = readJoints(matrix_joints)
    iD   = unique(matrix_joints(:,1));%get all ids 
    
    for i=1:length(iD)
        row        = find(matrix_joints(:,1)==iD(i)); %all lines of iD i
        nodes.iD{i}= iD(i);
        nodes.x{i} = matrix_joints(row,2);
        nodes.y{i} = matrix_joints(row,3);
        
        dx    = diff([nodes.x{i}]);% x-dimension of segment
       	dy    = diff([nodes.y{i}]);% y-dimension of segment
        [theta,rho]      = cart2pol(dx,dy);% polar representation of incremental segment
        
        theta(theta<0) = pi + theta(theta<0);
        theta(theta<=pi/2) = pi/2 - theta(theta<=pi/2);
        theta(theta>pi/2)  = 3*pi/2 - theta(theta>pi/2);
        
        nodes.nseg{i}    = length(dx);% number of segments
        nodes.norm{i}    = sum(rho);% norm of the sum of segments (trace length)
        
        nodes.theta{i}   = theta;% orientation of segments
        nodes.wi{i}      = rho./sum(rho);% weight for segments
        nodes.ori_w{i}   = theta .*  nodes.wi{i};
        nodes.ori_mean{i} = sum(nodes.ori_w{i})/sum(nodes.wi{i});
        nodes.ori_mean_deg{i} =  rad2deg(nodes.ori_mean{i});
        ori_mean_vector  = cell2mat(nodes.ori_mean_deg);
        [N,~] = histcounts(ori_mean_vector, (0:2:180));
        nodes.oriHisto   = N';      
    end
    clear row;
end 
