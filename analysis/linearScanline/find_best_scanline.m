function best_scanline = find_best_scanline(nodes, scanline_iterations)
    [vector]  = nodes2vector(nodes);
    x_joint = vector.x;
    y_joint = vector.y;
    % get trace extents 
    [xminmax] = [min(vector.x) max(vector.x)];
    [yminmax] = [min(vector.y) max(vector.y)];
    
    nb_cross = 0;
    best_scanline = 0;
    
    for scan = 1:scanline_iterations
        %create random scanline
        theta_scanline  = rand()*0.99*pi;
        random_scanline = create_scanline(xminmax, yminmax, theta_scanline);

        [xi,yi]    = polyxpoly(x_joint,y_joint,random_scanline.Xsl{1},random_scanline.Ysl{1});% find intersection between polyline and scanline   
        if size([xi,yi],1)>nb_cross
           nb_cross =  size([xi,yi],1); 
           best_scanline = random_scanline;
        end   
    end
end