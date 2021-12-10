function plot_gaussians(jointset, handles)
    gaussians = computeGaussians(jointset);
    %Plot first estimation
    for curve=1:size(gaussians.curves,2)
        plot(handles.theta_vector, gaussians.curves(:,curve))
    end
	plot(handles.theta_vector, gaussians.sum,'LineWidth',2);
end