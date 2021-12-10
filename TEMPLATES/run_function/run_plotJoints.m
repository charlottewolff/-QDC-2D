function run_plotJoints(template)
    close all

    if isfield(template,'INPUT')
        joint_file    = template.INPUT;
    else
        warning('Missing arguments : INPUT')
        return;
    end

    joints = load(joint_file);
    nodes = readJoints(joints);
    figure()
    hold on
    for i = 1:length(nodes.iD)
        Xl = [nodes.x{i}];% x-coordinate
        Yl = [nodes.y{i}];% y-coordinate 
        plot(Xl,Yl,'-','Color',[0,0,1])
    end
end