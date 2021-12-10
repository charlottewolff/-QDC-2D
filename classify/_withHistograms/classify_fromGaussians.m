function nodes_classif = classify_fromGaussians(limits, nodes, outPath)
    if limits == -1
       warning('Only 1 jointset selected -- No need for classification')
       nodes_classif = nodes;
       return;
    end
    
    %Classify jointSet
    fprintf('Classification of joint set --> Started\n');
    for i=1:length(nodes.iD)
        joint_orientation = nodes.ori_mean_deg{i};
        for inter = 1:length(limits)-1
            if joint_orientation >= limits(inter) && joint_orientation < limits(inter+1)
                nodes.setiD{i} = inter +1;
            end
        end
        if joint_orientation >= limits(end) || joint_orientation < limits(1) 
            nodes.setiD{i} = 1;   
        end 
        
    end
    nodes_classif = nodes;
    
    %Split nodes and write in OutPath
    for set = 1:length(limits)
       out = replace(outPath, '.', ('_' + string(set) + 'classif.'));
       split_nodes = splitNodes_per_setID(nodes_classif, set); 
       split_matrice = writeJoints(split_nodes);
       writematrix(split_matrice, out)
    end
    
    fprintf('Classification of joint set --> DONE! \n');
end