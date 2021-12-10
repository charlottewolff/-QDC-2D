function new_handles = plot_hough_inUI(handles)
    hough_estimation = handles.jointset;
    new_handles = handles;
    %Plot estimation
    n = 1;
    for set=1:hough_estimation.NBjointSet
        if hough_estimation.used{set} %if jointset is checked
            h_set = xline(hough_estimation.H_mean{set}, '-r', 'LineWidth', 2);
            if hough_estimation.H_mean{set} + hough_estimation.H_std{set}<=180 && hough_estimation.H_mean{set} + hough_estimation.H_std{set}>=0
                h_set_STD1 = xline(hough_estimation.H_mean{set} + hough_estimation.H_std{set}, '-b', 'LineWidth', 0.5);
            elseif hough_estimation.H_mean{set} + hough_estimation.H_std{set} > 180
                h_set_STD1 = xline(hough_estimation.H_mean{set} + hough_estimation.H_std{set}-180, '-b', 'LineWidth', 0.5);
            end
            if hough_estimation.H_mean{set} - hough_estimation.H_std{set} <= 180 && hough_estimation.H_mean{set} - hough_estimation.H_std{set}>=0
                h_set_STD2 = xline(hough_estimation.H_mean{set} - hough_estimation.H_std{set}, '-b', 'LineWidth', 0.5);
            elseif hough_estimation.H_mean{set} - hough_estimation.H_std{set}<0
                h_set_STD2 = xline(hough_estimation.H_mean{set} - hough_estimation.H_std{set}+180, '-b', 'LineWidth', 0.5);
            end
            new_handles.plot{n} = h_set;
            new_handles.plot_std1{n} = h_set_STD1;
            new_handles.plot_std2{n} = h_set_STD2;
            n = n+1;
        end
    end 
end