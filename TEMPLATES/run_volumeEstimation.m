%% -- To estimate block volumes et bock shape
clear, close all

%Read wanted joints information from table 
%-----
joint_table    = '.\TEMPLATES\table_jointSet_info.txt';
%-----


jointSetInfo = read_setFromTable(joint_table);
Vb = compute_volume(jointSetInfo);
