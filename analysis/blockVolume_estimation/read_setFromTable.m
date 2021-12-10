function jointSetInfo = read_setFromTable(tablePath)
    jointTable = readtable(tablePath)
    %-- to create a function
    nbJointSet = height(jointTable);
    
    jointSetInfo = NaN(nbJointSet, 2);
    for set=1:nbJointSet
        %-- Joint informations
        jointInfo   = jointTable(set,:); 
        jointSetInfo(set,1)    = jointInfo.orientation;
        jointSetInfo(set,2)    = jointInfo.spacing;
    end

end