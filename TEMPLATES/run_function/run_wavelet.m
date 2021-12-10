function run_wavelet(template) 
    close all
        
    if isfield(template,'INPUT') && isfield(template,'SCANS') && isfield(template,'DX') && isfield(template,'DY')
        joint_path    = template.INPUT;
        nb_scans = (template.SCANS);
        deltaX       = (template.DX);
        deltaY       = (template.DY);

        if isfield(template,'THETA') 
            if template.THETA <= 90 && template.THETA>= -90
             THETA       = 90-(template.THETA);
            else
                warning('Theta orientation for scanline should be (-90,90). Will estimate best scanline')
                THETA    = -999;
            end
        else
            warning('No theta orientation for scanline given by user. Will estimate best scanline')
            THETA = -999;
        end

    else
        warning('Missing arguments : INPUT - SCANS - DX - DY - THETA')
        return;
    end

    spacing = load(joint_path);
    nodes   = readJoints(spacing);

    %% Scanline-PROCESSING
    scanline_info.nb_scans = 30;
    scanline_info.nb_lines = nb_scans;
    scanline_info.dX       = deltaX;
    scanline_info.dY       = deltaY;
    scanline_info.theta    = deg2rad(THETA);
    scanlines = createScanlines(nodes, scanline_info);


    %% -- Wavelet analyse 
    computeWavelet(scanlines)

end
     