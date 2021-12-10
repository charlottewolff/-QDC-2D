function new_handles = refresh_plot_hough(handles)
    %Delete previous line
    for p=1:length(handles.plot)
        delete(handles.plot{p});
        delete(handles.plot_std1{p});
        delete(handles.plot_std2{p});
    end    
    %Plot refresh data 
    new_handles = plot_hough_inUI(handles);
    %new_handles = handles;
end