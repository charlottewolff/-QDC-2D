clear 
close all

joint_path      = 'C:\Users\charl\OneDrive\Bureau\RISK\jointAnalyse_cleaned\TEMPLATES\examples\Set1_nodes.txt';
nb_lines        = 2;   %nb of scanlines one wants to plot
deltaY          = 0;     %shift along Y axis
deltaX          = 2;     %shift along X axis
nbScan          = 30;    %number of scanline to try to find the best one
theta_scanline  = 0;


spacing = load(joint_path);
nodes   = readJoints(spacing);

%% Scanline-PROCESSING
scanline_info.nb_scans = nbScan;
scanline_info.nb_lines = nb_lines;
scanline_info.dX       = deltaX;
scanline_info.dY       = deltaY;

theta_scanline         = 90-theta_scanline;
scanlines = createScanlines(nodes, scanline_info, theta_scanline);      
%% -- Wavelet analyse 
computeWavelet(scanlines)
     