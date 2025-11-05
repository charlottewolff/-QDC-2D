function run_circular(template)
    close all
    
    if isfield(template,'INPUT')
            joint_file = template.INPUT;
    else
        warning('Missing arguments : INPUT')
        return;
    end
    
    mask.bool = 0;
    if isfield(template,'MASK')
        mask.v = template.MASK;
        if isfile(mask.v)
            xy_mask = readmatrix(mask.v);
            if size(xy_mask, 2) < 3
                warning('Wrong format, no mask applied.');
            else
                mask.bool = 2;
                mask.X_mask = xy_mask(:, 2);
                mask.Y_mask = xy_mask(:, 3);
            end
        elseif str2double(mask.v)==1
            mask.bool = 1; 
        else
            warning('No mask. Analysis over the entire area')
        end
    end
    
    prompt = 'Number of horizontal circles? : '; 
    circles = input(prompt);
    joints = load(joint_file);
    nodes = readJoints(joints) ;
    circularScanline(nodes, circles, mask);
end 