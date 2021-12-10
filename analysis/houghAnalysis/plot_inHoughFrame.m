function updated_nodes = plot_inHoughFrame(nodes)
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
        nodes.r{j} = abs(y*cosd(nodes.ori_mean_deg{j}) - x*sind(nodes.ori_mean_deg{j}));
         
        plot(nodes.ori_mean_deg{j}, nodes.r{j}, 'r.');
    end
    
    updated_nodes = nodes;
end 