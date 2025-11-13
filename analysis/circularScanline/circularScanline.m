function [intensity_estimator, density_estimator, traceLength_estimator] = circularScanline(nodes, nbCircles, mask)
    [~, id_x1x2y1y2_matrice] = polylines_to_lines(nodes); %plot polylines
    
    %% Trace length
    id_x1x2y1y2_matrice(:,1) = [];
    x  = [id_x1x2y1y2_matrice(:,1) id_x1x2y1y2_matrice(:,2)];
    dx = x(:,1)-x(:,2);
    y  = [id_x1x2y1y2_matrice(:,3) id_x1x2y1y2_matrice(:,4)];
    dy = y(:,1)-y(:,2);
    lT = sqrt(dx.^2+dy.^2); %length of trace
    x1 = x(:,1);
    x2 = x(:,2);
    y1 = y(:,1);
    y2 = y(:,2);
    
     %% Extend of the drawing window
     xmin = min(cellfun(@(v) min(v(:)), nodes.x));
     xmax = max(cellfun(@(v) max(v(:)), nodes.x));
     ymin = min(cellfun(@(v) min(v(:)), nodes.y));
     ymax = max(cellfun(@(v) max(v(:)), nodes.y));
           
     %% Create circles
     dx      = max((xmax-xmin),(ymax-ymin))/(nbCircles-1); % interval/diameter of circles
     [xw,yw] = meshgrid((xmin+dx/2):dx/2:(xmax),(ymin+dx/2):dx/2:(ymax));% mesh of circles
     R       = dx/2                                    ; % radius of circles
     xw      = xw(:)                                   ;% x coordinate of circles
     yw      = yw(:)                                   ;% y coordinate of circles
    
    %% Mask selection and filtering
    switch mask.bool
        case 0
            isInside = ones(1,length(xw));
        case 1 %draw polygon
            disp('Create the mask where to apply circular scanline (double click to stop).')
            h = drawpolygon();
            %         mask = createMask(h);
            mask.X_mask  = h.Position(:,1);
            mask.Y_mask  = h.Position(:,2);
            %         delete(h)
            disp('Mask created.')
            %       circles filtering
            isInside = inpolygon(xw, yw, mask.X_mask, mask.Y_mask);
        case 2 %polygon given by user
            h = drawpolygon('Position',[mask.X_mask(:), mask.Y_mask(:)]);
            isInside = inpolygon(xw, yw, mask.X_mask, mask.Y_mask);
    end
    nb_circles = sum(isInside);  
    %% Analysis
    for nc = 1:length(xw) %Analysis for each circle
        if isInside(nc)
            % CIRCLE INTERSECT
            %circle coor
            xc          = xw(nc);
            yc          = yw(nc);
            %translate to the origin
            x_1         = x1-xc;
            x_2         = x2-xc;
            y_1         = y1-yc;
            y_2         = y2-yc;
            
            result = circleAnalysis(x_1, x_2, y_1, y_2, R);
            
            %% Plotting coordinates
            %1- Circles
            s.xC{nc}    = xc+R*cos(0:2*pi/100:2*pi); 
            s.yC{nc}    = yc+R*sin(0:2*pi/100:2*pi);
            %2- Segments
            s.xT{nc}    = [x_1 x_2]+xc;
            s.yT{nc}    = [y_1 y_2]+yc;
            %3- Intersections
            
            if size(result.intersections,2)==2
                s.n{nc} = result.intersections + [xc yc];
            end
            %4- Within circle
            if size(result.inside_points,2)==2
                s.m{nc} = result.inside_points + [xc yc];
            end
            %5- Counts
            s.count{nc} = [result.n_intersections, result.n_inside_points, result.total_length];
            %6- Tracelength
            s.total_length{nc} = result.total_length;     
        end
    end

    n = 0;
    m = 0;
    intersectedCount    = 0;
    nonIntersectedCount = 0;
    intensity_vect      = NaN(1,length(xw));
    density_vect        = NaN(1,length(xw));
    total_length_vect   = NaN(1,length(xw));
    figure(1),clf
%     axis equal
    hold on

    for c=1:length(xw) %for each circle
        if isInside(c)
            n                   = n + s.count{c}(1);
            m                   = m + s.count{c}(2);
            intensity_vect(c)   = s.count{c}(1);
            density_vect(c)     = s.count{c}(2);
            total_length_vect(c)     = s.total_length{c}; 
            
            plot(xw(c),yw(c),'kx');                                         %plot circle center
            if(intensity_vect(c)+density_vect(c)>0)                         %if points within/intersect the circle
                plot(s.xC{c},s.yC{c},'g-');                                 %plot circle in green
                plot(s.xT{c}',s.yT{c}','b-','LineWidth',1.5);               %plot joints
                if size(s.n{c},2)>0
                    plot(s.n{c}(:,1), s.n{c}(:,2), 'rx', 'LineWidth', 2);   %plot intersections
                end
                if size(s.m{c},2)>0
                    plot(s.m{c}(:,1), s.m{c}(:,2),'go','LineWidth',2);      %plot points within circles
                end
                intersectedCount = intersectedCount + 1;
            else
                plot(s.xC{c},s.yC{c},'r-');                                 %plot circle in red
                nonIntersectedCount = nonIntersectedCount + 1;
            end
        end
    end
        
    %% Window selection
    m = m/nb_circles; %mean points within circles
    n = n/nb_circles; %mean intersections 
 
    %% -- Estimator calculation
    intensity_estimator   = n/(4*R);  %n/4r
    density_estimator     = m/(2*pi*R^2);  %m/2pr
    traceLength_estimator = (n/m)*pi*R/2;  %(n/m)pr/2
    
    disp('-----------------------')
    fprintf('Number of intersected circles: %d\n', intersectedCount);
    fprintf('Number of non-intersected circles: %d\n', nonIntersectedCount);
    fprintf('Total circles analyzed: %d\n', intersectedCount + nonIntersectedCount);
    disp('-----------------------')
    fprintf('Mean intensity estimator : %f\n', intensity_estimator);
    fprintf('Mean density estimator : %f\n', density_estimator);
    fprintf('Mean trace length estimator : %f\n', traceLength_estimator);
    disp('-----------------------')
    fprintf('Mean/std intensity : %f / %f\n', mean((intensity_vect / (4*R)),'omitnan'), std((intensity_vect / (4*R)),'omitnan'))
    fprintf('Mean/std density : %f / %f\n', mean((density_vect / (2*pi*(R^2))),'omitnan'), std((density_vect / (2*pi*(R^2))),'omitnan'))
    
    plot_Map_densityIntensity(xw,yw,intensity_vect,density_vect,total_length_vect,dx,R)

end