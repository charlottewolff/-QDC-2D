function [summarizeTable] = workflow_Analyse_1joint(nodes, outPath)
   
    %% -- Analyse of the joint set 
    close all
    fprintf('---------STRARTING ANALYSIS---------\n')
    
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
    resume.SetId{1,1}                   = 1;
    resume.nbTraces{1,1}                = length(nodes.iD);
    orientations = mean_orientation(nodes);
    resume.orientation_mean{1,1}        = orientations.MEAN;
    resume.orientation_min{1,1}         = orientations.MIN;
    resume.orientation_max{1,1}         = orientations.MAX;
    resume.length_mean{1,1}             = mean(cell2mat(nodes.norm));
    resume.length_min{1,1}              = min(cell2mat(nodes.norm));
    resume.length_max{1,1}              = max(cell2mat(nodes.norm));
    resume.spacing_mean_linearScanline{1,1} = mean(spacing_real);
    resume.spacing_min_linearScanline{1,1}  = min(spacing_real);
    resume.spacing_max_linearScanline{1,1}  = max(spacing_real);
    resume.spacing_mean_houghAnalyse{1,1}   = mean(nodes.real_spacing_hough);
    resume.spacing_min_houghAnalyse{1,1}    = min(nodes.real_spacing_hough);
    resume.spacing_max_houghAnalyse{1,1}    = max(nodes.real_spacing_hough);
    resume.persistence_mean{1,1}        = mean(persistance);
    resume.persistence_min{1,1}         = min(persistance);
    resume.persistence_max{1,1}         = max(persistance);
    resume.spacing_frequency{1,1}       = frequency;
    resume.intensity_estimator{1,1}     = intensity_estimator;
    resume.density_estimator{1,1}       = density_estimator;
    resume.traceLength_estimator{1,1}   = traceLength_estimator;
    
    close all
    summarizeTable = struct2table(resume);
    disp(summarizeTable)
    writetable(summarizeTable,outPath)
end