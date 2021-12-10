function  persistance = computePersistance(nodes, covering)
    %Check covering is [0 1]
    if nargin == 2
        if (covering > 1 ) || (covering < 0)
           error("Covering parameters should be [0 1]")
           return;  %#ok<UNRCH>
        end        
    end

    [nodes, id_x1x2y1y2_matrice] = polylines_to_lines(nodes);
    id_x1x2y1y2_matrice(:,1) = [];
    figure(1),clf
    plot_lines(nodes)
    title('I-- Persistence over the entire window')
    nodes.ori_mean_deg;
    MEAN_ori = mean(cell2mat(nodes.ori_mean_deg));
    fprintf('Mean joint orientation : %f deg\n', MEAN_ori)
    
    %% Observation window for synthetic joints
    if nodes.synthetic
        [~, window, ~] = selectExtends(nodes, 0.1);
        x_min = window.minX;
        x_max = window.maxX;
        y_min = window.minY;
        y_max = window.maxY;
        xlim([window.minX,window.maxX])
        ylim([window.minY,window.maxY])
    else
        C=nodes.x; 
        maxLengthCell=max(cellfun('size',nodes.x,1));  %finding the longest vector in the cell array
        for i = 1:size(nodes.x, 2)
            for j=cellfun('size',nodes.x(i),1)+1:maxLengthCell
                nodes.x{i}(j)=NaN;   %zeropad the elements in each cell array with a length shorter than the maxlength
                nodes.y{i}(j)=NaN;
            end
        end
        x_min = min(min(cell2mat(nodes.x)));
        x_max = max(max(cell2mat(nodes.x)));
        y_min = min(min(cell2mat(nodes.y)));
        y_max = max(max(cell2mat(nodes.y)));        
    end
     
    if nargin == 2
        disp('Input covering argument given')
        % Square side value - c    
        c  = covering*min([y_max-y_min x_max-x_min]);
        xw = mean([x_max x_min]);
        yw = mean([y_max y_min]);
        squares.x1 = xw-c/2;
        squares.x2 = xw+c/2;
        squares.y1 = yw-c/2;
        squares.y2 = yw+c/2;
        square.h   = c;
        square.L   = c; 
    else
        disp('No input covering argument. Draw rectangle to compute persistence.')
        rectangle = drawrectangle('Color','r', 'LineWidth', 0.3);
        squares.x1 = rectangle.Position(1);
        squares.x2 = rectangle.Position(1) + rectangle.Position(3);
        squares.y1 = rectangle.Position(2);
        squares.y2 = rectangle.Position(2) + rectangle.Position(4);
        square.h   = rectangle.Position(4);
        square.L   = rectangle.Position(3); 
        
        xw = mean([squares.x1 squares.x2]);
        yw = mean([squares.y1 squares.y2]);
    end
    
    %Plot middle of the square
    plot(xw,yw,'rx')    
    %Plot square
    x_Square = [squares.x1, squares.x1, squares.x2, squares.x2, squares.x1];
    y_Square= [squares.y1, squares.y2, squares.y2, squares.y1, squares.y1];
    plot(x_Square, y_Square, 'k-');
    
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

    if (n_tot_cc - n_trans_cc + n_inter_cc)>0
        persistance_cc = square.L*square.h/(square.h*sind(MEAN_ori) + square.L*cosd(MEAN_ori)) * (n_tot_cc + n_trans_cc - n_inter_cc)/(n_tot_cc - n_trans_cc + n_inter_cc);
        n_tot       = [n_tot, n_tot_cc]; 
        n_trans     = [n_trans, n_trans_cc];
        n_inter     = [n_inter, n_inter_cc];
        persistance = [persistance, persistance_cc]; 
    end
    


    %RESUME
    fprintf('Total joints : %d --- Inter joints : %d --- Transection joints : %d\n', n_tot, n_inter, n_trans)
    fprintf('Mean persistance : %f\n', mean(persistance))

end 
