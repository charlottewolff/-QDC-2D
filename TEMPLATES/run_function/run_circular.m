function run_circular(template)
    close all
    
    if isfield(template,'INPUT')
            joint_file = template.INPUT;
    else
        warning('Missing arguments : INPUT')
        return;
    end
    prompt = 'Number of horizontal circles? : '; 
    circles = input(prompt);
    
    joints = load(joint_file);
    nodes = readJoints(joints) ;
    circularScanline(nodes, circles);
end 