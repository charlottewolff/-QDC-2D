function run_createSyntheticJoints(template)
close all
if isfield(template,'TABLE') && isfield(template,'OUTPUT')
    table_joints  = template.TABLE;
    output_path   = template.OUTPUT;
else
    warning('Missing arguments : TABLE - OUTPUT')
    return;
end
wantedJoints = read_jointsFromTable(table_joints);
[idXY_matrice, ~] = create_synthetic_2(wantedJoints);
nodes = readJoints(idXY_matrice) ;
[nodes]= lines_to_polylines(nodes, 5, 0.009);
%% Window selection
[~, window, nodes] = selectExtends(nodes, 0.1);
xlim([window.minX,window.maxX])
ylim([window.minY,window.maxY])
matrice = writeJoints(nodes);
writematrix(matrice,output_path)
end