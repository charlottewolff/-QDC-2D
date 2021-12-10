function run_volume(template)
    close all 
    if isfield(template,'jORIENTATION') && isfield(template,'jSPACING') 
            orientation  = (cell2mat(template.jORIENTATION))';
            spacing      = (cell2mat(template.jSPACING))';
            jointSetInfo =  [orientation spacing];
        else
            warning('Missing arguments : JOINTS;orientation;spacing')
            return;
    end
    compute_volume(jointSetInfo);
    compute_Jv(jointSetInfo);
end 