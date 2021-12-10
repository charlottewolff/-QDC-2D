function [vector]  = nodes2vector(nodes)
    ori_vector = NaN(length(nodes.iD),1);
    length_vector = NaN(length(nodes.iD),1);
    x = [];
    y = [];
    for i = 1:length(nodes.iD)
       ori_vector(i) = nodes.ori_mean{i};
       length_vector(i) = nodes.norm{i};
       x = [x; nodes.x{i}];
       y = [y; nodes.y{i}];
    end
    vector.ori = ori_vector;
    vector.length_vector = length_vector;
    vector.x = x;
    vector.y = y;
    
end