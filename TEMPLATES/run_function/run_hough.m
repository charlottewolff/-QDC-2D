function run_hough(template)

close all
    if isfield(template,'INPUT')
        joint_file    = template.INPUT;
    else
        warning('Missing arguments : INPUT')
        return;
    end

    joints = load(joint_file);
    nodes = readJoints(joints);
    nodes = houghAnalysis(nodes);
    fprintf('Real spacing - Hough frame : %f\n', mean((nodes.real_spacing_hough)))
end