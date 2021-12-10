function [frequency, spacing_real, THETA] = parallelLinearScanline(nodes, info_scanline)
    [vector]  = nodes2vector(nodes);
    
    %% User info
    prompt = 'Automatic scanline estimation? \n -- 0:automatic \n -- 1:click 2 points  \n -- 2:1point and 1 orientation \n';
    autoScanline_bool = input(prompt);   
    [best_scanline] = scanlineSelection(autoScanline_bool, nodes, info_scanline.nbScan);     
        
    Xsl = best_scanline.Xsl;
    Ysl = best_scanline.Ysl;
    Xb  = best_scanline.Xb;
    Yb  = best_scanline.Yb;
    
    %% Ask for scanlines infos
    prompt_dX   = 'Shift dX ? :\n';
    scanline_info.dX          = input(prompt_dX);
    prompt_dY   = 'Shift dY ? :\n';
    scanline_info.dY    = input(prompt_dY);
    prompt_shift   = 'Number of parallel scanlines ? :\n';
    scanline_info.shift_nb    = input(prompt_shift);
    
    deltaX = scanline_info.dX;
    deltaY = scanline_info.dY;
    

    %% Plot scanlines
    figure(1);
    clf; %clear figure window 
    hold on    
    plot_nodes(nodes);
    plot(Xsl{1},Ysl{1},'k--','LineWidth',1)%plot scanline
    minX_scanline = min(Xsl{1});
    
    XYi = [];
    for i=1:length(nodes.iD)
        [xi,yi]    = polyxpoly(nodes.x{i}, nodes.y{i}, Xsl{1},Ysl{1});% find intersection between polyline and scanline
        plot(xi,yi,'rx')%plot intersection scanline and joints
        XYi = [XYi; xi yi]; %#ok<AGROW>
    end
    %% Analysis main scanline
    %-- joint tracelength and spacing
    THETA = vector.ori;
    coord_cross     = sortrows([XYi;[Xsl{1}' Ysl{1}']],1);
    spacing_app     = sqrt(diff(coord_cross(:,1)).^2+diff(coord_cross(:,2)).^2);
    spacing_real    = spacing_app .* abs(sin(pi/2 - mean(THETA) - best_scanline.theta_scanline));
    frequency       = 1/mean(spacing_real);
    fprintf('Spacing frequency for MAIN SCANLINE: %f\n', frequency);
    
    for line = 1:scanline_info.shift_nb
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
        X_down = [];
        Y_down = [];   
    
        txt_up   = 'dX -' + string(line*deltaX) + ' ---- dY ' + string(line*deltaY);
        txt_down = 'dX  ' + string(line*deltaX) + ' ---- dY -' + string(line*deltaY);
        P(2*line)   = plot(Xsl{1}-line*deltaX,Ysl{1}+line*deltaY,'--','LineWidth',0.3, 'DisplayName', txt_up); %#ok<AGROW> %plot scanlines
        P(2*line+1) = plot(Xsl{1}+line*deltaX,Ysl{1}-line*deltaY,'--','LineWidth',0.3, 'DisplayName', txt_down); %#ok<AGROW> %plot scanlines
        
        
        XYi_up   = [];
        XYi_down = [];
        for i=1:length(nodes.iD)
            [xi,yi]      = polyxpoly(nodes.x{i}, nodes.y{i}, Xsl{1}-line*deltaX,(Ysl{1}+line*deltaY));% find intersection between polyline and scanline
            X_up         = [X_up xi]; %#ok<AGROW>
            Y_up         = [Y_up yi]; %#ok<AGROW>
            scanline.X{2*line+1}       = X_up;
            scanline.Y{2*line+1}       = Y_up;
            XYi_up = [XYi_up; xi yi]; %#ok<AGROW>
            coord_cross_up     = sortrows([XYi_up;[Xsl{1}' Ysl{1}']],1);
            
            [xi,yi]      = polyxpoly(nodes.x{i}, nodes.y{i}, Xsl{1}+line*deltaX,(Ysl{1}-line*deltaY));% find intersection between polyline and scanline
            X_down       = [X_down xi]; %#ok<AGROW>
            Y_down       = [Y_down yi]; %#ok<AGROW>
            scanline.X{2*line}       = X_down;
            scanline.Y{2*line}       = Y_down;
            XYi_down = [XYi_down; xi yi]; %#ok<AGROW>
        end
        
        %-- Spacing analysis
        coord_cross_down   = sortrows([XYi_down;[Xsl{1}' Ysl{1}']],1);
        coord_cross_up     = sortrows([XYi_up;[Xsl{1}' Ysl{1}']],1);
        spacing_app_up     = sqrt(diff(coord_cross_up(:,1)).^2+diff(coord_cross_up(:,2)).^2);
        spacing_app_down   = sqrt(diff(coord_cross_down(:,1)).^2+diff(coord_cross_down(:,2)).^2);
        spacing_real_up    = spacing_app_up .* abs(sin(pi/2 - mean(THETA) - best_scanline.theta_scanline));
        spacing_real_down  = spacing_app_down .* abs(sin(pi/2 - mean(THETA) - best_scanline.theta_scanline));
        frequency_up       = 1/mean(spacing_real_up);
        fprintf('Linear fracture frequency for  %s : %f\n', txt_up,frequency_up);
        frequency_down       = 1/mean(spacing_real_down);
        fprintf('Linear fracture frequency for %s : %f\n', txt_down,frequency_down);
        
        max_line = max([size(spacing_real, 1), length(spacing_real_up), length(spacing_real_down)]);
        % add in the ending nan 
        spacing_app_up      = [spacing_app_up; nan(max_line-length(spacing_app_up), 1)]; %#ok<AGROW>
        spacing_real_up     = [spacing_real_up; nan(max_line-length(spacing_real_up), 1)]; %#ok<AGROW>
        spacing_app_down    = [spacing_app_down; nan(max_line-length(spacing_app_down), 1)]; %#ok<AGROW>
        spacing_real_down   = [spacing_real_down; nan(max_line-length(spacing_real_down), 1)]; %#ok<AGROW>
        spacing_app         = [spacing_app; nan(max_line-size(spacing_app, 1), size(spacing_app, 2))]; %#ok<AGROW>
        spacing_real        = [spacing_real; nan(max_line-size(spacing_real, 1), size(spacing_real, 2))]; %#ok<AGROW>
        spacing_app         = [spacing_app spacing_app_up spacing_app_down]; %#ok<AGROW>
        spacing_real        = [spacing_real spacing_real_up spacing_real_down]; %#ok<AGROW>
    end
    
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
    %% Window size
    if nodes.synthetic
        [~, window, nodes] = selectExtends(nodes, 0.1);
        xlim([window.minX,window.maxX])
        ylim([window.minY,window.maxY])
    end
    
    %% POST-PROCESSING
    %-- joint direction 
    figure(2)
    north = info_scanline.north*2*pi/360;
    THETA = THETA + north;
    THETA(THETA > 2*pi) = THETA(THETA>2*pi) - 2*pi;
    THETA(THETA < 0) = THETA(THETA<0) + 2*pi;
    polarhistogram(THETA,50);
    hold on
    polarhistogram(THETA+pi,50);
    title('Rose diagram (°)')
    ax = gca;
    ax.ThetaDir = 'clockwise';
    ax.ThetaZeroLocation = 'Top';
    
    %-- Trace length and orientation -- histogram and cumul
    figure()
    nbins = 10;
    %1 - tracelength histogram
    subplot(311)
    histogram(cell2mat(nodes.norm),nbins);
    xlabel('Trace lengths (m)')
    ylabel('Counts')
    title('Histogram - Trace length')
    %2 - tracelength cumul
    subplot(312)
    cdfplot(cell2mat(nodes.norm))
    xlabel('Trace length (m)')
    ylabel('CDF') 
    title('Cumulative distribution - Trace length') 
    %3 - Orientation cumul
    subplot(313)
    ori = rad2deg(THETA(:,1));   
    cdfplot(ori)
    xlabel('Orientation (°)')
    ylabel('CDF') 
    title('Cumulative distribution - Orientation')
    xlabel('Orientation(°)')
    
    %Spacing histograms
    figure()
    subplot(411)
    hist(spacing_app,nbins);
    xlabel('App spacing (m)')
    ylabel('Counts')
    title('Histogram - Apparent spacing along parallel scanlines')
    subplot(412)
    hist(spacing_real,nbins); %#ok<*HIST>
    xlabel('Real spacing (m)')
    ylabel('Counts')
    title('Histogram - Real spacing along parallel scanlines')
    subplot(413)
    hold on
    for i=1:size(spacing_app,2)       
        cdfplot(spacing_app(:,i));
        if i==1
            cumul_plot.Color = 'k';
            cumul_plot.LineWidth = 1;
        end
    end
    xlabel('App spacing (m)')
    ylabel('CDF')
    title('Cumulative distribution - App spacing along parallel scanlines')
    subplot(414)
    hold on
    for i=1:size(spacing_real,2)       
        cumul_plot = cdfplot(spacing_real(:,i));
        if i==1
            cumul_plot.Color = 'k';
            cumul_plot.LineWidth = 1;
        end
    end
    xlabel('Real spacing (m)')
    ylabel('CDF')
    title('Cumulative distribution - Real spacing along parallel scanlines')
end
