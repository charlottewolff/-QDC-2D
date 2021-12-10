%% -- To create synthetic joints with orientation following gaussian distributions
clear, close

%Read wanted joints information from table 
%-----
table_joints = 'table_wantedJoints.txt';
output_path  = 'out.txt';
%-----

wantedJoints = read_jointsFromTable(table_joints);
[idXY_matrice, idX1X2Y1Y2_matrice] = create_synthetic(wantedJoints);
nodes = readJoints(idXY_matrice) ;
[nodes]= lines_to_polylines(nodes, 5, 0.2);
matrice = writeJoints(nodes);

