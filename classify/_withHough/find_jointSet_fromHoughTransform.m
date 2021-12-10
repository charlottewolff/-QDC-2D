function hough_estimation = find_jointSet_fromHoughTransform(nodes)

    %Create Hough matrix from nodes
    [nodes, ~] = polylines_to_lines(nodes);
    
    %Plot in Hough frame
    figure(1);
    clf; %clear figure window 
    hold on
    title('Hough transform')
    xlabel('Theta')
    ylabel('r')
    for j = 1:length(nodes.iD)
        x = nodes.line{j}(1);
        y = nodes.line{j}(3);
        nodes.r{j} = y*cosd(nodes.ori_mean_deg{j}) - x*sind(nodes.ori_mean_deg{j});
         
        plot(nodes.ori_mean_deg{j}, nodes.r{j}, 'r.');
    end
    
    hough_estimation = jointSet_estimation_byUser_hough();
    
    
    %% -- Plot estimation
    for set=1:hough_estimation.NBjointSet
        xline(hough_estimation.H_mean{set}, '-r', 'LineWidth', 2);
        if hough_estimation.H_mean{set} + hough_estimation.H_std{set}<=180 && hough_estimation.H_mean{set} + hough_estimation.H_std{set}>=0
            xline(hough_estimation.H_mean{set} + hough_estimation.H_std{set}, '-b', 'LineWidth', 0.5);
        elseif hough_estimation.H_mean{set} + hough_estimation.H_std{set} > 180
            xline(hough_estimation.H_mean{set} + hough_estimation.H_std{set}-180, '-b', 'LineWidth', 0.5);
        end
        if hough_estimation.H_mean{set} - hough_estimation.H_std{set} <= 180 && hough_estimation.H_mean{set} - hough_estimation.H_std{set}>=0
            xline(hough_estimation.H_mean{set} - hough_estimation.H_std{set}, '-b', 'LineWidth', 0.5);
        elseif hough_estimation.H_mean{set} - hough_estimation.H_std{set}<0
            xline(hough_estimation.H_mean{set} - hough_estimation.H_std{set}+180, '-b', 'LineWidth', 0.5);
        end
    end
    
end