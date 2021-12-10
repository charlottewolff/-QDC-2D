function nodes = houghAnalysis(nodes)
    close all
    nodes = plot_inHoughFrame(nodes);
    
    pd = fitdist((cell2mat(nodes.ori_mean_deg))','Normal');
    fprintf('Gaussian distribution parameters for orientation : \n mu=%f -- sigma=%f\n', pd.mu, pd.sigma)
       
    % Apparent spacing
    r = (cell2mat(nodes.r));
    app_spacing = NaN(1, size(r,2)-1);
    
    % Real spacing
    r_theta = sortrows([(cell2mat(nodes.r))' (cell2mat(nodes.ori_mean))']);
    real_spacing = NaN(1, size(r,2)-1);
    for s=1:size(r,2)-1
        app_spacing(1, s) = r_theta(s+1,1)-r_theta(s,1);
        r1 = r_theta(s+1,1) - r_theta(s,1)/cos(r_theta(s+1,2) - r_theta(s,2));
        r2 = r_theta(s+1,1)/cos(r_theta(s+1,2) - r_theta(s,2)) - r_theta(s,1);
        real_spacing(1, s) = mean([r2 r1]);
    end
    nodes.real_spacing_hough = real_spacing;
    nodes.app_spacing_hough  = app_spacing;
    
    % Plot figure 
    figure(2);
    nbins = 10;
    subplot(311)
    histogram(cell2mat(nodes.norm),nbins);
    xlabel('Trace lengths (m)')
    ylabel('Counts')
    subplot(312)
    histogram(app_spacing,nbins);
    xlabel('Apparent spacing (m)')
    ylabel('Counts')
    subplot(313)
    histogram(real_spacing,nbins);
    xlabel('Real spacing (m)')
    ylabel('Counts')

end
