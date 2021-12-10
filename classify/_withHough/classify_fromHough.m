function nodes_classif = classify_fromHough(classifParams, nodes, outPath)
    
    nbJointSet = classifParams.NBjointSet;
    
    %Classify jointSet
    fprintf('Classification of joint set --> Started\n');
    for i=1:length(nodes.iD)
        joint_orientation = nodes.ori_mean_deg{i};
        nodes.setiD{i} = -1;
        for set = 1:nbJointSet
            if joint_orientation >= classifParams.H_mean{set}-classifParams.H_std{set} && joint_orientation < classifParams.H_mean{set}+classifParams.H_std{set}
                nodes.setiD{i} = set;
            end
            if classifParams.H_mean{set}-classifParams.H_std{set}<0
                if joint_orientation>classifParams.H_mean{set}-classifParams.H_std{set}+180
                    nodes.setiD{i} = set;
                end
            end
            if classifParams.H_mean{set}+classifParams.H_std{set}>180
                if joint_orientation<classifParams.H_mean{set}+classifParams.H_std{set}-180
                    nodes.setiD{i} = set;
                end
            end           
        end
    end
    
    nodes_classif = nodes;

    %Split nodes and write in OutPath
    for set = 1:nbJointSet
        out = replace(outPath, '.', ('_' + string(set) + 'classif.'));
        split_nodes = splitNodes_per_setID(nodes_classif, set);
        split_matrice = writeJoints(split_nodes);
        writematrix(split_matrice, out)
    end
    %Write in file not classified joints
    out = replace(outPath, '.', '_NOT_CLASSIF.');
    split_nodes = splitNodes_per_setID(nodes_classif, -1);
    split_matrice = writeJoints(split_nodes);
    writematrix(split_matrice, out)

    fprintf('Classification of joint set --> DONE! \n');
end