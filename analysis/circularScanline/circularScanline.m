function [intensity_estimator, density_estimator, traceLength_estimator] = circularScanline(nodes, nbCircles)
    [~, id_x1x2y1y2_matrice] = polylines_to_lines(nodes);
    
    id_x1x2y1y2_matrice(:,1) = [];
    x=[id_x1x2y1y2_matrice(:,1) id_x1x2y1y2_matrice(:,2)];
    dx = x(:,1)-x(:,2);
    y=[id_x1x2y1y2_matrice(:,3) id_x1x2y1y2_matrice(:,4)];
    dy = y(:,1)-y(:,2);
    lT=sqrt(dx.^2+dy.^2); %length of trace
    x1 = x(:,1);
    x2 = x(:,2);
    y1 = y(:,1);
    y2 = y(:,2);
    
    d       = max((max([x1;x2])-min([x1;x2])),...
              (max([y1;y2])-min([y1;y2]))       ); %max distance in x and y direction
   
     %% Extend of the drawing circles
     [extends, window, ~] = selectExtends(nodes, 0.01);
     xmin = window.minX;
     xmax = window.maxX;
     ymin = window.minY;
     ymax = window.maxY;    
         
    %create circles
    dx      = max((xmax-xmin),(ymax-ymin))/(nbCircles-1); % interval/diameter of circles
    [xw,yw] = meshgrid((xmin+dx/2):dx/2:(xmax),(ymin+dx/2):dx/2:(ymax));% mesh of circles
    R       = dx/2                                   ; % radius of circles
    xw      = xw(:)                                  ; % x coordinate of circles
    yw      = yw(:)                                  ; % y coordinate of circles

    for nc = 1:length(xw) %Analysis for each circle
        % CIRCLE INTERSECT
        %circle coor
        xc          = xw(nc);
        yc          = yw(nc);
        %translate to the origin
        x_1         = x1-xc;
        x_2         = x2-xc;
        y_1         = y1-yc;
        y_2         = y2-yc;
    
        % Points intersecting the circle
        [xTC,yTC,k] = intersectCT(x_1,x_2,y_1,y_2,R,lT,[],[],1,1);
        [xTC,yTC,~] = intersectCT(x_1,x_2,y_1,y_2,R,lT,xTC,yTC,k,-1);

        % ENDPOINT WITHIN CIRCLE
        d           = [sqrt(x_1.^2+y_1.^2);sqrt(x_2.^2+y_2.^2)];
        [endpoints] = find(d<R); %points within the circle
        xendpoint   = [x_1;x_2];
        yendpoint   = [y_1;y_2];
        %keep points within the circle
        xendpoint   = xendpoint(endpoints)+xc;
        yendpoint   = yendpoint(endpoints)+yc;

        % SAVE --> for plotting
        s.xC{nc}    = xc+R*cos(0:2*pi/100:2*pi); %points of the circle (for plotting)
        s.yC{nc}    = yc+R*sin(0:2*pi/100:2*pi);
        s.xT{nc}    = [x_1 x_2]+xc;
        s.yT{nc}    = [y_1 y_2]+yc;
        s.xTC{nc}   = xTC+xc; %Points intersection circle/joint
        s.yTC{nc}   = yTC+yc;
        s.m{nc}     = [xendpoint yendpoint]; %points within circle    
    end

    n = 0;
    m = 0;
    density_vect   = zeros(1,length(xw));
    intensity_vect = zeros(1,length(xw));
    figure(1),clf
    hold on
    for c=1:length(xw) %for each circle
        if(length(s.xTC{c})>0) %if points within/intersect the circle 
            x = s.m{c}; %points within 
            n = n+length(s.xTC{c}); %nb of intersections joint/circles
            m = m+size(x,1); %nb of points within the circle 
            density_vect(c)   = size(x,1);
            intensity_vect(c)    = length(s.xTC{c});
            if mod(c,2)==0
                plot(s.xC{c},s.yC{c},'y--', 'LineWidth',0.5); 
                plot(xw(c),yw(c),'yx'); %plot circle center%plot circles 
            elseif  mod(c,2)
                plot(s.xC{c},s.yC{c},'k-'); 
                plot(xw(c),yw(c),'kx'); %plot circle center
            end
            plot(s.xT{c}',s.yT{c}','b-','LineWidth',1.5);   %plot joints
            plot(s.xTC{c},s.yTC{c},'rx','LineWidth',2);     %plot intersections    
            plot(x(:,1),x(:,2),'go','LineWidth',2);         %plot points within circles 
        end
    end
        
    %% Window selection
    xlim([extends.minX,extends.maxX])
    ylim([extends.minY,extends.maxY])
    
    m
    m = m/c; %mean points within circles
    n = n/c; %mean intersections 



    %% -- Estimator calculation
    intensity_estimator   = n/(4*R);  %n/4r
    density_estimator     = m/(2*pi*R);  %m/2pr
    traceLength_estimator = (n/m)*pi*R/2;  %(n/m)pr/2
    disp('-----------------------')
    fprintf('Mean intensity estimator : %f\n', intensity_estimator);
    fprintf('Mean density estimator : %f\n', density_estimator);
    fprintf('Mean trace length estimator : %f\n', traceLength_estimator);
    disp('-----------------------')
    fprintf('Mean/std intensity : %f / %f\n', mean(intensity_vect), std(intensity_vect))
    fprintf('Mean/std density : %f / %f\n', mean(density_vect), std(density_vect))
    
    plot_Map_densityIntensity(xw,yw,intensity_vect,density_vect,dx)

end