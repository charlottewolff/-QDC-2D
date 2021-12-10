function [scanline] = click_endPoints(nodes)
    figure(1);
    clf; %clear figure window 
    hold on    
    plot_nodes(nodes);
    %% Observation window for synthetic joints
    if nodes.synthetic
        [~, window, ~] = selectExtends(nodes, 0.1);
        xlim([window.minX,window.maxX])
        ylim([window.minY,window.maxY])
    end
    [x,y] = ginput(2);
    plot(x,y,'k.', 'MarkerSize',17)
    
    scanline.Xsl{1} = [x(1) x(2)]; %scanline extremities x
    scanline.Ysl{1} = [y(1) y(2)]; %scanline extremities y
    scanline.Xb{1}  = [scanline.Xsl{1}(1) scanline.Xsl{1}(2) scanline.Xsl{1}(2) scanline.Xsl{1}(1) scanline.Xsl{1}(1)]; %Rectangle around scanline x coor 
    scanline.Yb{1}  = [scanline.Ysl{1}(1) scanline.Ysl{1}(1) scanline.Ysl{1}(2) scanline.Ysl{1}(2) scanline.Ysl{1}(1)]; %Rectangle around scanline y coor
    
    dx                  = diff(x); % x-dimension of segment
    dy                  = diff(y); % y-dimension of segment
    [theta,~]           = cart2pol(dx,dy);% polar representation of incremental segment        
    theta(theta<0)      = pi + theta(theta<0);
    theta(theta<=pi/2)  = pi/2 - theta(theta<=pi/2);
    theta(theta>pi/2)   = 3*pi/2 - theta(theta>pi/2);
    scanline.theta_scanline = theta; 
    fprintf('Scanline orientation : %f \n', rad2deg(scanline.theta_scanline))
end