function wantedJoints = read_jointsFromTable(tablePath)
    jointTable = readtable(tablePath);
    %-- to create a function
    nbJointSet = height(jointTable);
    wantedJoints = NaN(nbJointSet, 5);
    for set=1:nbJointSet
        %-- Joint informations
        jointInfo   = jointTable(set,:); 
        wantedJoints(set,1)    = jointInfo.nb_joints;
        wantedJoints(set,2)    = jointInfo.orientation;
        wantedJoints(set,3)    = jointInfo.std;
        wantedJoints(set,4)    = jointInfo.mean_traceLength;
        wantedJoints(set,5)    = jointInfo.mean_spacing;
    end
end