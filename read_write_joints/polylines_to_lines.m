function [nodes, id_x1x2y1y2_matrice] = polylines_to_lines(nodes)
    id_x1x2y1y2_matrice = NaN(length(nodes.iD), 5);
    hold on
    for i = 1:length(nodes.iD)
        x = nodes.x{i};
        y = nodes.y{i};
        p = polyfit(x,y,1);
        x_1 = min(x);
        x_2 = max(x);
        y_1 = p(1)*x_1 + p(2);
        y_2 = p(1)*x_2 + p(2);
        nodes.line{i} = [x_1, x_2, y_1, y_2]; 
        id_x1x2y1y2_matrice(i,:) = [i, x_1, x_2, y_1, y_2];
        
        Xl = [x_1,x_2];% x-coordinate
        Yl = [y_1,y_2];% y-coordinate 
        
        plot(Xl,Yl,'-','Color',[0,0,1])
    
    end
    
    %% Extend of the window
    [vector]  = nodes2vector(nodes);
    xmoy      = (min(vector.x) + max(vector.x))/2;
    ymoy      = (min(vector.y) + max(vector.y))/2;
    %Find the max trace length 
    %--> the extend will be the 1/2 of max trace length
    norm = cell2mat(nodes.norm');
    [sortedX, ~] = sort(norm(:),'descend');
    top3 = sortedX(2);
    max_extend = top3/2;
    n = 2;
    xlim([xmoy-max_extend/n, xmoy+max_extend/n])
    ylim([ymoy-max_extend/n, ymoy+max_extend/n])

end