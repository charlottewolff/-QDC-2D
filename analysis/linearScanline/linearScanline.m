function [frequency, spacing_real, THETA] = linearScanline(nodes, info_scanline)

    [vector]  = nodes2vector(nodes);
    
    %% User info
    prompt = 'Automatic scanline estimation? \n -- 0:automatic \n -- 1:click 2 points  \n -- 2:1point and 1 orientation \n';
    autoScanline_bool = input(prompt);   
    [best_scanline] = scanlineSelection(autoScanline_bool, nodes, info_scanline.nbScan);     
        
    Xsl = best_scanline.Xsl;
    Ysl = best_scanline.Ysl;
    Xb  = best_scanline.Xb;
    Yb  = best_scanline.Yb;
    
    figure(1);
    clf; %clear figure window 
    hold on    
    plot_nodes(nodes);
    plot(Xsl{1},Ysl{1},'k--','LineWidth',1)%plot scanline
    plot(Xb{1},Yb{1},'g-.','LineWidth',1)%plot scanline extend
    XYi = [];
    for i=1:length(nodes.iD)
        [xi,yi]    = polyxpoly(nodes.x{i}, nodes.y{i}, Xsl{1},Ysl{1});% find intersection between polyline and scanline
        plot(xi,yi,'rx')%plot intersection scanline and joints
        XYi = [XYi; xi yi]; %#ok<AGROW>
    end
    
    %% Observation window for synthetic joints
    if nodes.synthetic
        [~, window, nodes] = selectExtends(nodes, 0.1);
        xlim([window.minX,window.maxX])
        ylim([window.minY,window.maxY])
    end
    
        
    %% POST-PROCESSING
    %-- joint direction 
    figure(2)
    THETA = vector.ori;
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

    %-- joint tracelength and spacing
    coord_cross     = sortrows([XYi;[Xsl{1}' Ysl{1}']],1);
    spacing_app     = sqrt(diff(coord_cross(:,1)).^2+diff(coord_cross(:,2)).^2);
    spacing_real    = spacing_app .* abs(sin(pi/2 - mean(THETA) - best_scanline.theta_scanline));
    frequency       = 1/mean(spacing_real);
    fprintf('Spacing frequency : %f', frequency);
    
    figure(3);
    nbins = 10;
    subplot(311)
    histogram(cell2mat(nodes.norm),nbins);
    xlabel('Trace lengths (m)')
    ylabel('Counts')
    title('Histogram - Trace length')
    subplot(312)
    histogram(spacing_app,nbins);
    xlabel('Apparent spacing (m)')
    ylabel('Counts')
    title('Histogram - Apparent spacing')
    subplot(313)
    histogram(spacing_real,nbins); 
    xlabel('Real spacing (m)')
    ylabel('Counts')
    title('Histogram - Real spacing')
    
    %Cumulative distribution
    figure(4)
    subplot(311)    
    ori = rad2deg(THETA(:,1));   
    cdfplot(ori)
    xlabel('Orientation (°)')
    ylabel('CDF') 
    title('Cumulative distribution - Orientation')
    xlabel('orientation(°)')
    hold on
    
    subplot(312)
    cdfplot(spacing_real)
    xlabel('Real spacing (m)')
    ylabel('CDF') 
    title('Cumulative distribution - Spacing')
    
    subplot(313)
    cdfplot(cell2mat(nodes.norm))
    xlabel('Trace length (m)')
    ylabel('CDF') 
    title('Cumulative distribution - Trace length')
    hold off   
end