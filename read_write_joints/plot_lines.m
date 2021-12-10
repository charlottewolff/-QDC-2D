function plot_lines(nodes)
    hold on    
    if isfield(nodes, 'line')
        for i = 1:length(nodes.iD)
            Xl = nodes.line{i}(1:2);% x-coordinate
            Yl = nodes.line{i}(3:4);% y-coordinate 
            plot(Xl,Yl,'-','Color',[0,0,1])
        end
    else
        disp('No lines to plot ! ')
    end
end