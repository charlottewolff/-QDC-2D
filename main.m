clear 
close all
% [file,path] = uigetfile('*.txt');
% if isequal(file,0)
%    disp('No template selected');
%    return;
% else
%    disp(['User selected ', fullfile(path,file)]);
%    template.fullpath = fullfile(path,file);
% end

% template.path = '1';
template.fullpath = 'C:\Users\charl\OneDrive\Bureau\RISK\jointAnalyse_cleaned\TEMPLATE.txt';
% template.file = '2';

%% Read template file
fid = fopen(template.fullpath,'rt');
joint = 1;
template.SYNTHETIC = 0;
while ~feof(fid)
     line=sscanf(fgetl(fid),'%s');
     line = split(line,';');

     switch line{1}
         case 'SYNTHETIC'
             template.SYNTHETIC = str2double(line{2});
         case 'STEP'
             template.STEP = (line{2});
         case 'METHOD'
             template.METHOD = (line{2});
         case 'INPUT'
             template.INPUT = (line{2});
         case 'OUTPUT'
             template.OUTPUT = (line{2});
         case 'SCALE'
             template.SCALE = (line{2});
         case 'NORTH'
             template.NORTH = str2num((line{2}));
         case 'TABLE'
             template.TABLE = (line{2});
         case 'COVER'
             template.COVER = str2double(line{2});
         case 'NB_LINEARSCANS'
            template.NB_LINEARSCANS = round(str2double(line{2}));
         case 'DX'
             template.DX = str2double(line{2});
          case 'DY'
             template.DY = str2double(line{2});
          case 'SCANS'
             template.SCANS = round(str2double(line{2})); 
          case 'THETA'
             template.THETA = round(str2double(line{2}));  
          case 'JOINT'
             if length(line)<4
                 warning('Missing information. Needed : JOINT;name;orientation;spacing')
                 return;
             end
             template.jNAME{joint}        = line{2};
             template.jORIENTATION{joint} = str2double(line{3});
             template.jSPACING{joint}     = str2double(line{4});
             joint = joint+1;
         otherwise
             fprintf('%s : Not used\n', line{1})
     end  
end
fid=fclose(fid);

%% -- Step : HELP
if isequal(template.STEP,'HELP')||isequal(template.STEP,'-h')
    helper = fopen('help.txt','rt');
    while ~feof(helper)
        disp(sscanf(fgetl(helper),'%s'));
    end
    helper=fclose(helper);
end


%% -- Step 1 : Create joints
if str2double(template.STEP) == 1
    disp('STEP 1 : Create joints')
    if isfield(template,'METHOD') 
        if template.METHOD == "draw"
            disp('Draw on image')
            run_drawJoints(template)
        elseif template.METHOD == "synthetic"
            disp('Create synthetic joints')
            run_createSyntheticJoints(template)
        elseif template.METHOD == "plot"
            disp('Plot joints')
            run_plotJoints(template)
        else
            warning('Available method for STEP 1 : draw or synthetic')
            return;
        end
    else
        warning('No METHOD:draw/synthetic')
        return;
    end 
end 

%% -- Step 2 : Classify joints
if str2double(template.STEP) == 2
    disp('STEP 2 : Classify joints')
    if isfield(template,'METHOD') 
        if template.METHOD == "hough"
            disp('Classify with Hough')
            UI_classif_withHough()
        elseif template.METHOD == "histo"
            disp('Classify with oriention histograms')
            UI_classif_withGauss()
        else
            warning('Available method for STEP 2 : histo or hough')
            return;
        end
    else
        warning('No METHOD:histo/hough')
        return;
    end  
end

%% -- Step 3 : Analysis 1 jointset 
if str2double(template.STEP) == 3
    disp('STEP 3 : Analyse jointset')
    if isfield(template,'METHOD') 
        if template.METHOD == "hough"
            disp('Analyse with Hough frame')
            run_hough(template)
        elseif template.METHOD == "linear"
            disp('Analyse with linear scanline')
            run_linear(template)
        elseif template.METHOD == "persistence"
            disp('Analyse the persistence')
            run_persistence(template) 
        elseif template.METHOD == "wavelet"
            disp('Analyse spacing with wavelet transform')
            run_wavelet(template)
        elseif template.METHOD == "circular"
            disp('Analyse with circular scanline')
            run_circular(template)
        elseif template.METHOD == "parallelLinear"
            run_parallelLinear(template)
        else
            warning('Available method for STEP 3 : hough or linear or parallelLinear or circular or wavelet or persistence')
            return;
        end
    else
        warning('No METHOD;hough/linear/persistence')
        return;
    end  
end


%% -- Step 4 : Analysis all jointsets
if str2double(template.STEP) == 4
    disp('STEP 4 : Characterization of the jointing degree ')
    if isfield(template,'METHOD') 
        if template.METHOD == "circular"
            disp('Analyse circular scanline')
            run_circular(template)
        elseif template.METHOD == "volume"          
            disp('Analyse block volume and volume joint count')
            run_volume(template)         
        else
            warning('Available method for STEP 4 : circular or volume')
            return;
        end
    else
        warning('No METHOD;circular/volume')
        return;
    end  
end