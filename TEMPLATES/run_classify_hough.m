%% -- Classify joints based on Hough transform frame
clear, close all

%Read wanted joints information from table 
%-----
joint = '.\TEMPLATES\examples\createdJoints1.txt';
outPath = 'gaussian_classif.txt';
%-----

input_joint = load(joint);
nodes = readJoints(input_joint);
setParams = find_jointSet_fromHoughTransform(nodes);
nodes_classif = classify_fromHough(setParams, nodes, outPath);