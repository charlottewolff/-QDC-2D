function gaussian_param_OPT = find_jointSet_fromHistogram(nodes)
    global theta_vector
    global theta_histogram
    theta_vector = (1:2:179);
    
    
    %Plot polar histogram
    figure(1)
    theta = cell2mat(nodes.ori_mean);
	polarhistogram([theta;theta+pi],50);
    %Plot raw histogram
    figure(2);
    clf; %clear figure window 
    subplot(2,1,1)
    hold on
    title('Estimated result')
    xlabel('Orientation (degrees)')
    ylabel('Counts')
    plot(theta_vector,nodes.oriHisto,'--','Color',[0.5,0.5,0]);%plot tracelength
    XTick = (0:10:180);
    set(gca,'xtick',XTick)
    %Plot smoothed data
    theta_histogram_smoothed = smoothHisto(nodes.oriHisto, 10);
    plot(theta_vector,theta_histogram_smoothed,'-','Color',[1,0,0])
    legend('Raw data', 'Smoothed data')
    
    %% -- USER estimation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gaussian_param_esti = jointSet_estimation_byUser();
    
    %Create Gaussian curves
    gaussians = computeGaussians(gaussian_param_esti);
 
    %Plot first estimation
    for curve=1:size(gaussians.curves,2)
        plot(theta_vector, gaussians.curves(:,curve))
    end
    graph = gca; legend(graph,'off');
	plot(theta_vector, gaussians.sum,'LineWidth',2);
    
    
    %% -- Optimization
    theta_histogram = nodes.oriHisto;
    w0 = [gaussian_param_esti.noise, cell2mat(gaussian_param_esti.G_mean), cell2mat(gaussian_param_esti.G_std), cell2mat(gaussian_param_esti.G_N)];
    [w,~] = fminunc( @(x) minimizeFunction(x), w0);

    % Plot result of 2nd estimation 
    subplot(2,1,2)
    title('Optimization result')
    xlabel('Orientation (degrees)')
    ylabel('Counts')
    hold on 
    plot(theta_vector,theta_histogram,'-','Color',[1,0,0])
    set(gca,'xtick',XTick)
    gaussian_param_OPT = gaussian_param_esti;
    NBjointSet = gaussian_param_OPT.NBjointSet;
    gaussian_param_OPT.G_mean = num2cell(w(2:NBjointSet+1));
    gaussian_param_OPT.G_std  = num2cell(w(NBjointSet+2:2*NBjointSet+1));
    gaussian_param_OPT.G_N  = num2cell(w(2*NBjointSet+2:3*NBjointSet+1));
    gaussian_param_OPT.noise = w(1);
    gaussians_OPT = computeGaussians(gaussian_param_OPT);
    
    for curve=1:size(gaussians_OPT.curves,2)
        plot(theta_vector, gaussians_OPT.curves(:,curve))
    end
    plot(theta_vector, gaussians_OPT.sum,'LineWidth',2);
    
    
    %% --  RESUME
    fprintf('End of histogram optimization!\n -- \nResults are : \n');
    fprintf('Noise estimation : %f\n',  w(1))
    for j=1:NBjointSet
        fprintf('Joint %d\n', j)
        fprintf('Mean: %f  --  ', w(j+1)) 
        fprintf('Standard deviation : %f  --  ', w(NBjointSet+j+1))
        fprintf('Amplitude : %f\n', w(2*NBjointSet+j+1))
    end


end 
