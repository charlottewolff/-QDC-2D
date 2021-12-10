file = 'Set1_nodes.txt';

matrix = load(file);
nodes = readJoints(matrix);

nodes = houghAnalysis(nodes);