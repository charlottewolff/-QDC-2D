function scanline = createScanlines(nodes, scanline_info, theta)
    nb_scans = scanline_info.nb_scans;
    nb_lines = scanline_info.nb_lines;
    deltaX   = scanline_info.dX;    
    deltaY   = scanline_info.dY;
    if scanline_info.theta == -999 %No orientation given by user
        best_scanline = find_best_scanline(nodes, nb_scans);
    else

        [vector]  = nodes2vector(nodes);
        % get trace extents 
        [xminmax] = [min(vector.x) max(vector.x)];
        [yminmax] = [min(vector.y) max(vector.y)];
        best_scanline = create_scanline(xminmax, yminmax, scanline_info.theta);
    end
        
    Xsl = best_scanline.Xsl;
    Ysl = best_scanline.Ysl;
    Xb  = best_scanline.Xb;
    Yb  = best_scanline.Yb;
    
    figure(1);
    clf; %clear figure window 
    hold on
    
    %% -- Main scanline 
    P(1) = plot(Xsl{1},Ysl{1},'k--','LineWidth',1, 'DisplayName','Main scanline');%plot scanline 
    minX_scanline = min(Xsl{1});
    
    scanline.iD{1} = 0;
    scanline.dX{1} = 0;
    scanline.dY{1} = 0;
    X = [];
    Y = [];
    X_trans = [];
    for i=1:length(nodes.iD)
         [xi,yi]      = polyxpoly(nodes.x{i}, nodes.y{i}, Xsl{1},Ysl{1});% find intersection between polyline and scanline
         scanline.cross{1} = [xi,yi];
         X         = [X xi]; %#ok<AGROW>
         Y         = [Y yi]; %#ok<AGROW>
         X_trans   = [X_trans sqrt((xi-minX_scanline).^2 + (yi-min(Ysl{1})).^2)]; %#ok<AGROW>
         scanline.X{1}       = X;
         scanline.Y{1}       = Y;
         scanline.X_trans{1} = X_trans;
         scanline.minY{1}    = min(Ysl{1});
         scanline.maxY{1}    = max(Ysl{1});
         scanline.minX{1}    = min(Xsl{1});
         scanline.maxX{1}    = max(Xsl{1});         
    end
    
    %% Secondary scanline
    for line = 1:nb_lines
        scanline.iD{2*line+1} = line;
        scanline.dX{2*line+1} = -1*line*deltaX;
        scanline.dY{2*line+1} = line*deltaY;
        scanline.iD{2*line}   = -1*line;
        scanline.dX{2*line}   = line*deltaX;
        scanline.dY{2*line}   = -1*line*deltaY;

        %Y translate
        minY_scanline_up    = min(Ysl{1}) + line*deltaY;
        minY_scanline_down  = min(Ysl{1}) - line*deltaY;
        maxY_scanline_up    = max(Ysl{1}) + line*deltaY;
        maxY_scanline_down  = max(Ysl{1}) - line*deltaY;
        scanline.minY{2*line+1}    = minY_scanline_up;
        scanline.minY{2*line}      = minY_scanline_down;
        scanline.maxY{2*line+1}    = maxY_scanline_up;
        scanline.maxY{2*line}      = maxY_scanline_down;
        %X translate
        minX_scanline_up    = min(Xsl{1}) + line*deltaX;
        minX_scanline_down  = min(Xsl{1}) - line*deltaX;
        maxX_scanline_up    = max(Xsl{1}) + line*deltaX;
        maxX_scanline_down  = max(Xsl{1}) - line*deltaX;
        scanline.minX{2*line+1}    = minX_scanline_up;
        scanline.minX{2*line}      = minX_scanline_down;
        scanline.maxX{2*line+1}    = maxX_scanline_up;
        scanline.maxX{2*line}      = maxX_scanline_down;

        X_up = [];
        Y_up = [];
        X_trans_up = [];
        X_down = [];
        Y_down = [];
        X_trans_down = [];
        
        txt_up   = 'dX : -' + string(line*deltaX) + ' ---- dY:  ' + string(line*deltaY);
        txt_down = 'dX :  ' + string(line*deltaX) + ' ---- dY: -' + string(line*deltaY);
        P(2*line)   = plot(Xsl{1}-line*deltaX,Ysl{1}+line*deltaY,'--','LineWidth',0.3, 'DisplayName', txt_up);%plot scanlines
        P(2*line+1) = plot(Xsl{1}+line*deltaX,Ysl{1}-line*deltaY,'--','LineWidth',0.3, 'DisplayName', txt_down);%plot scanlines
        for i=1:length(nodes.iD)
            [xi,yi]      = polyxpoly(nodes.x{i}, nodes.y{i}, Xsl{1}-line*deltaX,(Ysl{1}+line*deltaY));% find intersection between polyline and scanline
            X_up         = [X_up xi]; %#ok<AGROW>
            Y_up         = [Y_up yi]; %#ok<AGROW>
            X_trans_up   = [X_trans_up sqrt((xi-minX_scanline).^2 + (yi-minY_scanline_up).^2)]; %#ok<AGROW>
            scanline.X{2*line+1}       = X_up;
            scanline.Y{2*line+1}       = Y_up;
            scanline.X_trans{2*line+1} = X_trans_up;

            [xi,yi]      = polyxpoly(nodes.x{i}, nodes.y{i}, Xsl{1}+line*deltaX,(Ysl{1}-line*deltaY));% find intersection between polyline and scanline
            X_down       = [X_down xi]; %#ok<AGROW>
            Y_down       = [Y_down yi]; %#ok<AGROW>
            X_trans_down = [X_trans_down sqrt((xi-minX_scanline).^2 + (yi-minY_scanline_down).^2)]; %#ok<AGROW>
            scanline.X{2*line}       = X_down;
            scanline.Y{2*line}       = Y_down;
            scanline.X_trans{2*line} = X_trans_down;
        end
    end
    legend('Location','bestoutside')
    h = plot(Xb{1},Yb{1},'g-.','LineWidth',1);%plot scanline extend 
    plot_nodes(nodes);
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    for scan=1:length(scanline.iD)
        if scanline.iD{scan}==0
            h = plot(scanline.X{scan},scanline.Y{scan},'rx') ; 
            set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        else
            h = plot(scanline.X{scan},scanline.Y{scan},'yx') ;     
            set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
    end   
    axis equal
    axis tight
    
end