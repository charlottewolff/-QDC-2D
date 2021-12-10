%% -- To create synthetic joints with orientation following gaussian distributions
clear, close

%Read wanted joints information from table 
%-----
table_joints = 'table_wantedJoints.txt';
output_path  = 'out.txt';
%-----


wantedJoints = read_jointsFromTable(table_joints);
[idXY_matrice, idX1X2Y1Y2_matrice] = create_synthetic_2(wantedJoints);
nodes = readJoints(idXY_matrice) ;
writematrix(idXY_matrice, output_path)