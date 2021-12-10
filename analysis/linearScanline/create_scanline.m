function scanline = create_scanline(extendX, extendY, theta_scanline)
    scanline.xc     = extendX(1)+0.5*diff((extendX)); %mid x
    scanline.yc     = extendY(1)+0.5*diff((extendY)); %mid y
    scanline.r      = sqrt((0.5*diff((extendX))).^2+(0.5*diff((extendY))).^2); %scanlin length
    scanline.theta_scanline  = theta_scanline; %scanline angle
    xc = scanline.xc;
    yc = scanline.yc; 
    r  = scanline.r;

    scanline.Xsl{1} = [xc+r*cos(theta_scanline) xc+r*cos(theta_scanline+pi)]; %scanline extremities x
    scanline.Ysl{1} = [yc+r*sin(theta_scanline) yc+r*sin(theta_scanline+pi)]; %scanline extremities y
    scanline.Xb{1}  = [scanline.Xsl{1}(1) scanline.Xsl{1}(2) scanline.Xsl{1}(2) scanline.Xsl{1}(1) scanline.Xsl{1}(1)]; %Rectangle around scanline x coor 
    scanline.Yb{1}  = [scanline.Ysl{1}(1) scanline.Ysl{1}(1) scanline.Ysl{1}(2) scanline.Ysl{1}(2) scanline.Ysl{1}(1)]; %Rectangle around scanline y coor
end