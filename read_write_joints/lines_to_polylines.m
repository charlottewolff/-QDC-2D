function [new_nodes]= lines_to_polylines(nodes,nb_split,lambda)
    close all
    for i=1:length(nodes.iD)
        x = nodes.x{i};
        y = nodes.y{i};
        
        %Parameters 
        a = (y(2)-y(1))/(x(2)-x(1));
        b = y(2)-a*x(2);
               
        %split x in segments
        y_split      = NaN(nb_split, 1);
        if x(1)< x(end)
            y_split(1)   = y(1); 
            y_split(end) = y(end);
        else
            y_split(1)   = y(end); 
            y_split(end) = y(1); 
        end
        x_split = min(x):(max(x)-min(x))/(nb_split-1):max(x);
        %find y for each x of x_split
        for j=2:nb_split-1
            y = a*x_split(j) + b;
            y_split(j) = random('norm',y, lambda);
        end
        nodes.x{i} = x_split';
        nodes.y{i} = y_split;
    end
    
    new_nodes = nodes;
    figure()
    plot_nodes(new_nodes)
end