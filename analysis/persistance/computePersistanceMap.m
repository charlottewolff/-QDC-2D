function computePersistanceMap(nodes, nbRectangles)
    [~, id_x1x2y1y2_matrice] = polylines_to_lines(nodes);
    
    id_x1x2y1y2_matrice(:,1) = [];
    MEAN_ori = mean(cell2mat(nodes.ori_mean_deg));
    x=[id_x1x2y1y2_matrice(:,1) id_x1x2y1y2_matrice(:,2)];
    y=[id_x1x2y1y2_matrice(:,3) id_x1x2y1y2_matrice(:,4)];

    x1 = x(:,1);
    x2 = x(:,2);
    y1 = y(:,1);
    y2 = y(:,2);
       
    d       = max((max([x1;x2])-min([x1;x2])),...
              (max([y1;y2])-min([y1;y2]))       ); %max distance in x and y direction
    
    %% Window selection
    [~, window, ~] = selectExtends(nodes, 0.1);
    xmin = window.minX;
    xmax = window.maxX;
    ymin = window.minY;
    ymax = window.maxY;
    xlim([window.minX,window.maxX])
    ylim([window.minY,window.maxY])
       
    %create rectangles
    dx      = min((xmax-xmin),(ymax-ymin))/(nbRectangles-1)           ; % interval between 2squares 
    [xw,yw] = meshgrid((xmin+dx/2):dx/2:(xmax-dx/2),(ymin+dx/2):dx/2:(ymax-dx/2)); % mesh of squares
    xw      = xw(:)                                  ; % x coordinate of middle square
    yw      = yw(:)                                  ; % y coordinate of middle square
    
    %analysis for each square
    persistence_vect   = zeros(1,length(xw));
    for i = 1:length(xw)
        x1 = xw(i)-dx/2;
        x2 = xw(i)+dx/2;
        y1 = yw(i)-dx/2;
        y2 = yw(i)+dx/2;
        h   = dx;
        L   = dx;
        %Plot middle of the square
        plot(xw(i),yw(i),'rx')
        %Plot square
        x_Square = [x1, x1, x2, x2, x1];
        y_Square= [y1, y2, y2, y1, y1];
        if mod(i,2)==0
            plot(x_Square, y_Square, 'y--', 'LineWidth',0.5);
        else
            plot(x_Square, y_Square, 'k-');
        end
        n_tot       = [];
        n_trans     = [];
        n_inter     = [];
        persistance = [];
        %Analysis intersection
        n_tot_cc   = 0;
        n_trans_cc = 0;
        n_inter_cc = 0;       
        
        for j=1:size(id_x1x2y1y2_matrice,1)
            poly_X = id_x1x2y1y2_matrice(j,1:2);
            poly_Y = id_x1x2y1y2_matrice(j,3:4);
            [xT,yT] = polyxpoly(poly_X',poly_Y',x_Square,y_Square);
            plot(xT,yT, 'go')
            
            if size(xT, 1) == 1
                n_tot_cc = n_tot_cc+1;
            elseif size(xT, 1) == 2
                n_trans_cc = n_trans_cc+1;
                n_tot_cc = n_tot_cc+1;
            else %no intersection - check if joint is within
                x_min = min(poly_X);
                x_max = max(poly_X);
                y_min = min(poly_Y);
                y_max = max(poly_Y);
                
                if x_min>min(x_Square) && x_max<max(x_Square) && y_min>min(y_Square) && y_max<max(y_Square)
                    n_tot_cc   = n_tot_cc+1;
                    n_inter_cc = n_inter_cc+1;
                end
            end
        end
        
        if (n_tot_cc - n_trans_cc + n_inter_cc)>=0
            persistance = L*h/(h*sind(MEAN_ori) + L*cosd(MEAN_ori)) * (n_tot_cc + n_trans_cc - n_inter_cc)/(n_tot_cc - n_trans_cc + n_inter_cc);
            n_tot       = n_tot_cc;
            n_trans     = n_trans_cc;
            n_inter     = n_inter_cc;
            persistence_vect(i) = persistance;
        end       
    end   
    mean_persistence = mean(persistence_vect);
    std_persistence  = std(persistence_vect);
    
    % Density map plot
    figure() 
    image(flipud(xw),flipud(yw),reshape(persistence_vect,[length(unique(xw)), length(unique(yw))])','CDataMapping','scaled')
    colorbar
    axis equal
    str_titleMap = sprintf('Persistence map\nMean persistence : %f\nStd persistence : %f', mean_persistence,std_persistence);
    title(str_titleMap)
    
    set(gca,'YDir','normal')    
end