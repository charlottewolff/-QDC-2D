function refresh_plot_gaussians(jointset, handles)
    gaussians = computeGaussians(jointset);   
    %Refresh plot 
    for curve=1:size(gaussians.curves,2)
        h = handles.plot{curve+3};
        h.YData = gaussians.curves(:,curve);
    end
    h_sum = handles.plot{3};
    h_sum.YData = gaussians.sum;
    refreshdata
end