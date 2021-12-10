%% -- Classify joints based on gaussian distribution of orientation
clear, close all

%Read wanted joints information from table 
%-----
joint = '.\TEMPLATES\examples\createdJoints1.txt';
outPath = 'gaussian_classif.txt';
%-----


input_joint = load(joint);
nodes = readJoints(input_joint);
gaussianParams = find_jointSet_fromHistogram(nodes);
limits = find_jointSetLimits(gaussianParams);
nodes_classif = classify_fromGaussians(limits, nodes, outPath);