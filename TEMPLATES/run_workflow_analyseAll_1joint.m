clear, close all

inputFile = '.\TEMPLATES\examples\Set1_nodes.txt';
outputFolder = 'out.txt';
matrix_joints = load(inputFile);

nodes = readJoints(matrix_joints);


summarizeTable = workflow_Analyse_1joint(nodes, outputFolder);

