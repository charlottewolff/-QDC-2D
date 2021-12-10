function run_parallelLinear(template)
    close all
    if isfield(template,'INPUT')
        joint_file    = template.INPUT;
    else
        warning('Missing arguments : INPUT (mandatory)')
        return;
    end
    
    if isfield(template,'NORTH')
        info_scanline.north    = template.NORTH;
        disp('North orientation given. Joints rotation');
    else
        info_scanline.north = 0;
    end
    
    joints = load(joint_file);
    nodes = readJoints(joints);
    info_scanline.nbScan = 30;
    nodes.synthetic = template.SYNTHETIC;
    
    [frequency, spacing_real, THETA] = parallelLinearScanline(nodes, info_scanline);

end

