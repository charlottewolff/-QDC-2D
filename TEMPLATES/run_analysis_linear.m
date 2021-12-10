%% -- To do a linear analysis
clear, close all

%Read wanted joints information from table 
%-----
joint_file    = '.\TEMPLATES\examples\Set1_nodes.txt';
joint_file = "out.txt";
try_scanline  = 30;
%-----

joints = load(joint_file);
nodes = readJoints(joints) ;
[frequency, spacing_real] = linearScanline(nodes, try_scanline);