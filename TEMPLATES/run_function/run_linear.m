function run_linear(template)
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
    nodes.synthetic = template.SYNTHETIC;
    
    info_scanline.nbScan = 30;
    
    [~, spacing_real, THETA] = linearScanline(nodes, info_scanline);
    fprintf('\nReal spacing : %f\n', mean(spacing_real))
    fprintf('\nMean orientation : %f\n', mean(rad2deg(THETA)))
    fprintf('\nTrace length : %f\n', mean(cell2mat(nodes.norm)))
end