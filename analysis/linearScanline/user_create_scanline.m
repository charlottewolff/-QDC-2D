function scanline = user_create_scanline(point, theta_scanline, nodes)
    [vector]  = nodes2vector(nodes);
    x_joint = vector.x;
    y_joint = vector.y;
    % get trace extents 
    [xminmax] = [min(vector.x) max(vector.x)];
    [yminmax] = [min(vector.y) max(vector.y)];
    
    scanline.xc     = point.x; %mid x
    scanline.yc     = point.y; %mid y
    r_down          = sqrt((scanline.xc-min(vector.x))^2 + (scanline.yc-min(vector.y))^2);
    r_up            = sqrt((scanline.xc-max(vector.x))^2 + (scanline.yc-max(vector.y))^2);
    
    scanline.Xsl{1} = [scanline.xc+r_up*cos(theta_scanline) scanline.xc+r_down*cos(theta_scanline+pi)]; %scanline extremities x
    scanline.Ysl{1} = [scanline.yc+r_up*sin(theta_scanline) scanline.yc+r_down*sin(theta_scanline+pi)]; %scanline extremities y
    scanline.Xb{1}  = [scanline.Xsl{1}(1) scanline.Xsl{1}(2) scanline.Xsl{1}(2) scanline.Xsl{1}(1) scanline.Xsl{1}(1)]; %Rectangle around scanline x coor 
    scanline.Yb{1}  = [scanline.Ysl{1}(1) scanline.Ysl{1}(1) scanline.Ysl{1}(2) scanline.Ysl{1}(2) scanline.Ysl{1}(1)]; %Rectangle around scanline y coor
    scanline.theta_scanline = theta_scanline;
end 