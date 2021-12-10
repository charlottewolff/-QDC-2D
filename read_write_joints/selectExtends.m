function [extends, window, nodes] = selectExtends(nodes, extend)
    id_x1x2y1y2_matrice = NaN(length(nodes.iD), 5);
    
    VALUE = extend;
    
    for i = 1:length(nodes.iD)
        x = nodes.x{i};
        y = nodes.y{i};
        p = polyfit(x,y,1);
        x_1 = min(x);
        x_2 = max(x);
        y_1 = p(1)*x_1 + p(2);
        y_2 = p(1)*x_2 + p(2);
        x_moy = (x_1 + x_2)/2;
        y_moy = (y_1 + y_2)/2;        
        nodes.middle{i} = [x_moy, y_moy];

    end
    %% Min/max of the middle
    middle          = cell2mat((nodes.middle)');
    middle_min      = min(middle);
    middle_max      = max(middle);
    extends.minX    = middle_min(1);
    extends.minY    = middle_min(2);
    extends.maxX    = middle_max(1);
    extends.maxY    = middle_max(2);
    
    %% Extends of the window
    window.minX    = extends.minX+VALUE*(extends.maxX - extends.minX);
    window.minY    = extends.minY+VALUE*(extends.maxY - extends.minY);
    window.maxX    = extends.maxX-VALUE*(extends.maxX - extends.minX);
    window.maxY    = extends.maxY-VALUE*(extends.maxY - extends.minY);
end