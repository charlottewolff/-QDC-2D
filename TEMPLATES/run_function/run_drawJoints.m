function run_drawJoints(template)
%% -- To draw joints on a given image, knowing its scale and the nb of joints to plot
close all

%Read wanted joints information from table 
%-----
if isfield(template,'INPUT') && isfield(template,'SCALE') && isfield(template,'OUTPUT')
    img           = template.INPUT;
    scale_factor  = str2double(template.SCALE);
    output_path   = template.OUTPUT;
else
    warning('Missing arguments : INPUT - SCALE - OUTPUT')
    return;
end
%-----
nodes = drawOnImg(img, output_path, scale_factor);
end