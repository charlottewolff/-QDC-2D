function matrice = writeJoints(nodes)
    matrice = [];
    for i = 1:length(nodes.iD)
        id = nodes.iD{i}* ones(size(nodes.x{i}, 1), 1);
        matrice = [matrice ; [id,nodes.x{i}, nodes.y{i}]];
    end 
end