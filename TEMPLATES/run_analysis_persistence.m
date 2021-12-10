%% -- To compute persistance
clear, close all

%Read wanted joints information from table 
%-----
joint_file    = '.\TEMPLATES\examples\Set1_nodes.txt';
cover         = 0.8;
%-----

joints = load(joint_file);
nodes = readJoints(joints) ;
persistance = computePersistance(nodes);