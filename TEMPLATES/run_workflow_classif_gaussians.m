clear, close all

inputFile = '.\TEMPLATES\examples\createdJoints1.txt';
outputFolder = 'C:\Users\charl\OneDrive\Bureau\RISK\jointAnalyse_cleaned\classif.txt';
matrix_joints = load(inputFile);

nodes = readJoints(matrix_joints);


summarizeTable = workflow_classify_Analyse_withHistograms(nodes, outputFolder);

