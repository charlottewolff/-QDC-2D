%% -- To do a circular analysis
clear, close

%Read wanted joints information from table 
%-----
joint_file    = '.\TEMPLATES\examples\Set1_nodes.txt';
nb_circles    = 5;
%-----

joints = load(joint_file);
nodes = readJoints(joints) ;
[intensity_estimator, density_estimator, traceLength_estimator] = circularScanline(nodes, nb_circles);