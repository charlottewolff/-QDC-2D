function plot_nodes(nodes)
    hold on    
    for i = 1:length(nodes.iD)
        Xl = [nodes.x{i}];% x-coordinate
        Yl = [nodes.y{i}];% y-coordinate 
        h = plot(Xl,Yl,'-','Color',[0,0,1]);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end
end