function [summarizeTable, files] = workflow_classify_Analyse_withHistograms(nodes, outPath)
    close all
    %% -- Classification
    gaussianParams = find_jointSet_fromHistogram(nodes);
    limits = find_jointSetLimits(gaussianParams);
    classify_fromGaussians(limits, nodes, outPath);
    
    %% -- Get classif files
    [fPath, fName, fExt] = fileparts(outPath);    
    classif = "*" + string(fName) + "*" + string(fExt);
    S = dir(fullfile(fPath,classif));
    for k = 1:numel(S)
        files.name{k}     = S(k).name;
        files.fullPath{k} = fullfile(fPath,S(k).name);
    end
    
    %% -- Analyse of each joint set 
    close all
    fprintf('---------STRARTING ANALYSIS---------\n')
    for j = 1:length(files.fullPath)
        joint_file  = files.fullPath{j};
        fprintf('--- File : %s\n', joint_file)
        set_iD      = split(joint_file,'_');
        set_iD      = split(set_iD{end}, 'classif');
        joints      = load(joint_file);
        nodes       = readJoints(joints);
        
        %hough analyse
        close all
        nodes = houghAnalysis(nodes);
        %linear analyse
        close all
        [frequency, spacing_real] = linearScanline(nodes, 30);
        %circular scanline
        close all
        [intensity_estimator, density_estimator, traceLength_estimator] = circularScanline(nodes, 5);
        %persistance
        close all
        persistance = computePersistance(nodes, 0.9);
        close all

        %% -- summarize
        resume.SetId{j,1}                   = set_iD{1};
        resume.nbTraces{j,1}                = length(nodes.iD);
        orientations = mean_orientation(nodes);
        resume.orientation_mean{j,1}        = orientations.MEAN;
        resume.orientation_min{j,1}         = orientations.MIN;
        resume.orientation_max{j,1}         = orientations.MAX;
        resume.length_mean{j,1}             = mean(cell2mat(nodes.norm));
        resume.length_min{j,1}              = min(cell2mat(nodes.norm));
        resume.length_max{j,1}              = max(cell2mat(nodes.norm));
        resume.spacing_mean_linearScanline{j,1} = mean(spacing_real);
        resume.spacing_min_linearScanline{j,1}  = min(spacing_real);
        resume.spacing_max_linearScanline{j,1}  = max(spacing_real);
        resume.spacing_mean_houghAnalyse{j,1}   = mean(nodes.real_spacing_hough);
        resume.spacing_min_houghAnalyse{j,1}    = min(nodes.real_spacing_hough);
        resume.spacing_max_houghAnalyse{j,1}    = max(nodes.real_spacing_hough);     
        resume.persistence_mean{j,1}        = mean(persistance);
        resume.persistence_min{j,1}         = min(persistance);
        resume.persistence_max{j,1}         = max(persistance);
        resume.spacing_frequency{j,1}       = frequency;
        resume.intensity_estimator{j,1}     = intensity_estimator;
        resume.density_estimator{j,1}       = density_estimator;
        resume.traceLength_estimator{j,1}   = traceLength_estimator;       
    end
    close all
    summarizeTable = struct2table(resume);
    disp(summarizeTable)
    writetable(summarizeTable,outPath)
end