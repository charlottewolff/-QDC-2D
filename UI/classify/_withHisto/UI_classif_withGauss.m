function varargout = UI_classif_withGauss(varargin)
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_classif_withGauss_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_classif_withGauss_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function UI_classif_withGauss_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
handles.isFile = 0;
handles.plot = [];
handles.theta_vector = (1:2:179);
handles.ini = handles;
handles.ini;
guidata(hObject, handles);

function varargout = UI_classif_withGauss_OutputFcn(~, ~, handles)
varargout{1} = handles.output;

function slider_j3_mean_Callback(hObject, ~, handles)    %#ok<DEFNU> %Get joints information 
    jointset = get_jointset_gauss(handles); 
    set(handles.t3_mean, 'String', fix(jointset.G_mean{3}));
    handles.jointset = jointset;    
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j3_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j3_std_Callback(hObject, ~, handles)    %#ok<DEFNU> %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;  
    set(handles.t3_std, 'String', fix(jointset.G_std{3}));  
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j3_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j3_N_Callback(hObject, ~, handles)    %#ok<DEFNU> %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;  
    set(handles.t3_N, 'String', fix(jointset.G_N{3}));  
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j3_N_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j4_N_Callback(hObject, ~, handles)    %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;  
    set(handles.t4_N, 'String', fix(jointset.G_N{4}));  
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j4_N_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j4_std_Callback(hObject, ~, handles)    %#ok<DEFNU> %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset; 
    set(handles.t4_std, 'String', fix(jointset.G_std{4}));   
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j4_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j4_mean_Callback(hObject, ~, handles)     %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_gauss(handles);  
    set(handles.t4_mean, 'String', fix(jointset.G_mean{4}));
    handles.jointset = jointset;    
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j4_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j5_mean_Callback(hObject, ~, handles) %#ok<DEFNU>   
    %Get joints information 
    jointset = get_jointset_gauss(handles);  
    set(handles.t5_mean, 'String', fix(jointset.G_mean{5}));
    handles.jointset = jointset;    
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j5_mean_CreateFcn(hObject, ~, ~)%#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j5_std_Callback(hObject, ~, handles)    %#ok<DEFNU> %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;
    set(handles.t5_std, 'String', fix(jointset.G_std{5}));    
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j5_std_CreateFcn(hObject, ~, ~)%#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j5_N_Callback(hObject, ~, handles) %#ok<DEFNU>   
    %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;   
    set(handles.t5_N, 'String', fix(jointset.G_N{5}));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)
 
function slider_j5_N_CreateFcn(hObject, ~, ~)%#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j6_N_Callback(hObject, ~, handles)   %#ok<DEFNU> 
    %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;    
    set(handles.t6_N, 'String', fix(jointset.G_N{6}));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)
 
function slider_j6_N_CreateFcn(hObject, ~, ~)%#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j6_std_Callback(hObject, ~, handles) %#ok<DEFNU>   
%Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset; 
    set(handles.t6_std, 'String', fix(jointset.G_std{6}));   
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)
 
function slider_j6_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j6_mean_Callback(hObject, ~, handles)   %#ok<DEFNU> 
    %Get joints information 
    jointset = get_jointset_gauss(handles); 
    set(handles.t6_mean, 'String', fix(jointset.G_mean{6}));
    handles.jointset = jointset;    
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j6_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j1_mean_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;   
    refresh_plot_gaussians(jointset, handles);
    set(handles.t1_mean, 'String', fix(jointset.G_mean{1}));
    guidata(hObject, handles)

function slider_j1_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j1_std_Callback(hObject, ~, handles)%#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_gauss(handles);
    handles.jointset = jointset;
    set(handles.t1_std, 'String', fix(jointset.G_std{1}));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j1_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j1_N_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_gauss(handles);
    handles.jointset = jointset;
    set(handles.t1_N, 'String', fix(jointset.G_N{1}));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j1_N_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
function slider_j2_N_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;    
    set(handles.t2_N, 'String', fix(jointset.G_N{2}));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j2_N_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j2_std_Callback(hObject, ~, handles) %#ok<DEFNU>   
    %Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;
    set(handles.t2_std, 'String', fix(jointset.G_std{2}));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j2_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j2_mean_Callback(hObject, ~, handles)   %#ok<DEFNU> 
%Get joints information 
    jointset = get_jointset_gauss(handles);   
    handles.jointset = jointset;
    set(handles.t2_mean, 'String',fix(jointset.G_mean{2}));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)

function slider_j2_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function push_validate1_Callback(hObject, ~, handles) %#ok<DEFNU>
    global theta_histogram
    jointset = get_jointset_gauss(handles);
    %% -- Optimization
    theta_histogram = (handles.plot{1}.YData)';
    G = [];
    STD = [];
    N = [];
    NBjointSet = 0;
    for used=1:length(jointset.used)
        if jointset.used{used}
            NBjointSet = NBjointSet+1;
            G = [G fix(jointset.G_mean{used})]; %#ok<AGROW>
            STD = [STD fix(jointset.G_std{used})]; %#ok<AGROW>
            N = [N fix(jointset.G_N{used})]; %#ok<AGROW>
        end
    end 
    jointset.NBjointSet = NBjointSet;
    w0 = [jointset.noise, G, STD, N];
    [w,~] = fminunc( @(x) minimizeFunction(x), w0);

    % Plot result of 2nd estimation 
    axes(handles.histo_plot)
    title('Optimization result')
    hold on 
    gaussian_param_OPT = jointset;
    NBjointSet = gaussian_param_OPT.NBjointSet;
    gaussian_param_OPT.G_mean = num2cell(w(2:NBjointSet+1));
    for mean=1:NBjointSet
        if gaussian_param_OPT.G_mean{mean} > 180
            gaussian_param_OPT.G_mean{mean} = gaussian_param_OPT.G_mean{mean} - 180;
        elseif gaussian_param_OPT.G_mean{mean} < 0
            gaussian_param_OPT.G_mean{mean} = gaussian_param_OPT.G_mean{mean} + 180;
        end
    end
    gaussian_param_OPT.G_std  = num2cell(w(NBjointSet+2:2*NBjointSet+1));
    gaussian_param_OPT.G_N  = num2cell(w(2*NBjointSet+2:3*NBjointSet+1));
    gaussian_param_OPT.noise = w(1);
    refresh_plot_gaussians(gaussian_param_OPT, handles)
    handles.jointset=gaussian_param_OPT;
    guidata(hObject, handles)
    %Enable classify
    set(handles.push_classify, 'Enable', 'on')
    %Edit results in txt and slider
    set(handles.t_noise, 'String', fix(gaussian_param_OPT.noise))
    set(handles.t1_mean, 'String', gaussian_param_OPT.G_mean(1))
    set(handles.t1_std, 'String', gaussian_param_OPT.G_std(1))
    set(handles.t1_N, 'String', gaussian_param_OPT.G_N(1))
    set(handles.slider_noise, 'Value', fix(gaussian_param_OPT.noise))
    gaussian_param_OPT.G_mean(1)
    set(handles.slider_j1_mean, 'Value', cell2mat(gaussian_param_OPT.G_mean(1)))
    set(handles.slider_j1_std, 'Value', cell2mat(gaussian_param_OPT.G_std(1)))
    set(handles.slider_j1_N, 'Value', cell2mat(gaussian_param_OPT.G_N(1)))
    n = 2;
    if jointset.used{2}
        set(handles.t2_mean, 'String', gaussian_param_OPT.G_mean(n))
        set(handles.t2_std, 'String', gaussian_param_OPT.G_std(n))
        set(handles.t2_N, 'String', gaussian_param_OPT.G_N(n))
        set(handles.slider_j2_mean, 'Value', cell2mat(gaussian_param_OPT.G_mean(2)))
        set(handles.slider_j2_std, 'Value', cell2mat(gaussian_param_OPT.G_std(2)))
        set(handles.slider_j2_N, 'Value', cell2mat(gaussian_param_OPT.G_N(2)))
        n = n+1;
    end
    if jointset.used{3}
        set(handles.t3_mean, 'String', gaussian_param_OPT.G_mean(n))
        set(handles.t3_std, 'String', gaussian_param_OPT.G_std(n))
        set(handles.t3_N, 'String', gaussian_param_OPT.G_N(n))
        set(handles.slider_j3_mean, 'Value', cell2mat(gaussian_param_OPT.G_mean(3)))
        set(handles.slider_j3_std, 'Value', cell2mat(gaussian_param_OPT.G_std(3)))
        set(handles.slider_j3_N, 'Value', cell2mat(gaussian_param_OPT.G_N(3)))
        n = n+1;
    end
    if jointset.used{4}
        set(handles.t4_mean, 'String', gaussian_param_OPT.G_mean(n))
        set(handles.t4_std, 'String', gaussian_param_OPT.G_std(n))
        set(handles.t4_N, 'String', gaussian_param_OPT.G_N(n))
        set(handles.slider_j4_mean, 'Value', cell2mat(gaussian_param_OPT.G_mean(4)))
        set(handles.slider_j4_std, 'Value', cell2mat(gaussian_param_OPT.G_std(4)))
        set(handles.slider_j4_N, 'Value', cell2mat(gaussian_param_OPT.G_N(4)))
        n = n+1;
     end
     if jointset.used{5}
        set(handles.t5_mean, 'String', gaussian_param_OPT.G_mean(n))
        set(handles.t5_std, 'String', gaussian_param_OPT.G_std(n))
        set(handles.t5_N, 'String', gaussian_param_OPT.G_N(n))
        set(handles.slider_j5_mean, 'Value', cell2mat(gaussian_param_OPT.G_mean(5)))
        set(handles.slider_j5_std, 'Value', cell2mat(gaussian_param_OPT.G_std(5)))
        set(handles.slider_j5_N, 'Value', cell2mat(gaussian_param_OPT.G_N(5)))
        n = n+1;
     end
     if jointset.used{6}
        set(handles.t6_mean, 'String', gaussian_param_OPT.G_mean(n))
        set(handles.t6_std, 'String', gaussian_param_OPT.G_std(n))
        set(handles.t6_N, 'String', gaussian_param_OPT.G_N(n))
        set(handles.slider_j6_mean, 'Value', cell2mat(gaussian_param_OPT.G_mean(6)))
        set(handles.slider_j6_std, 'Value', cell2mat(gaussian_param_OPT.G_std(6)))
        set(handles.slider_j6_N, 'Value', cell2mat(gaussian_param_OPT.G_N(6)))
        n = n+1;
    end
    
    
 
function push_loadJoints_Callback(hObject, ~, handles) %#ok<DEFNU>
    [file,path] = uigetfile('*.txt', 'Select joint file');
    if isequal(file,0)
       disp('No file selected');
       return;
    end
    
   %enable slider
   handles.isFile = 1;
   set(handles.slider_j1_mean, 'Enable', 'on')
   set(handles.slider_j1_std, 'Enable', 'on')
   set(handles.slider_j1_N, 'Enable', 'on')
   set(handles.slider_j2_mean, 'Enable', 'on')
   set(handles.slider_j2_std, 'Enable', 'on')
   set(handles.slider_j2_N, 'Enable', 'on')
   set(handles.slider_noise, 'Enable', 'on')
   set(handles.checkbox_j6, 'Enable', 'on')
   set(handles.checkbox_j2, 'Enable', 'on')
   set(handles.checkbox_j3, 'Enable', 'on')
   set(handles.checkbox_j4, 'Enable', 'on')
   set(handles.checkbox_j5, 'Enable', 'on')
   set(handles.checkbox_j6, 'Enable', 'on')
   set(handles.push_clear, 'Enable', 'on')
   
   %Load joints
   joint_file    = fullfile(path,file);
   handles.joint_file = joint_file;
   joint_matrice = load(joint_file);
   nodes         = readJoints(joint_matrice);
   handles.nodes = nodes;

   %Plot polar histogram
   set(handles.polar_histo, 'Visible', 'On')
   axes(handles.polar_histo)
   theta = cell2mat(nodes.ori_mean);
   polarhistogram([theta;theta+pi],50);
   title('Orientations histogram')
   ax = gca;
   ax.ThetaDir = 'clockwise';
   ax.ThetaZeroLocation = 'Top';

   %Plot raw histogram
   theta_vector  = (1:2:179);
   handles.theta_vector = theta_vector;
   axes(handles.histo_plot)

   hold on
   title('Estimated result')
    xlabel('Orientation (degrees)')
    ylabel('Counts')
    h1 = plot(theta_vector,nodes.oriHisto,'--','Color',[0.5,0.5,0]);%plot tracelength
    %Plot smoothed data
    theta_histogram_smoothed = smoothHisto(nodes.oriHisto, 10);
    h2 = plot(theta_vector,theta_histogram_smoothed,'-','Color',[1,0,0]);
    handles.plot{1} = h1;
    handles.plot{2} = h2;
    %Get joints information 
    jointset = get_jointset_gauss(handles);
    handles.jointset = jointset;
    gaussians = computeGaussians(jointset);
    %Plot estimation
    h3 = plot(handles.theta_vector, gaussians.sum,'LineWidth',2);
    handles.plot{3} = h3;
    for curve=1:size(gaussians.curves,2)
        hc = plot(handles.theta_vector, gaussians.curves(:,curve));
        handles.plot{curve+3} = hc;
    end
    guidata(hObject,handles);
 
function slider_noise_Callback(hObject, ~ , handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_gauss(handles);
    handles.jointset = jointset;
    set(handles.t_noise, 'String', fix(jointset.noise));
    refresh_plot_gaussians(jointset, handles);
    guidata(hObject, handles)
    
function slider_noise_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function checkbox_j2_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j2{1} = hObject.Value;
if handles.j2{1}
    set(handles.slider_j2_mean,'Enable','On')
    set(handles.slider_j2_std,'Enable','On')
    set(handles.slider_j2_N,'Enable','On')
else
    set(handles.slider_j2_mean,'Enable','Off')
    set(handles.slider_j2_std,'Enable','Off')
    set(handles.slider_j2_N,'Enable','Off')
    set(handles.slider_j2_mean,'Value',0)
    set(handles.slider_j2_std,'Value',0)
    set(handles.slider_j2_N,'Value',0)
end

function checkbox_j3_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j3{1} = hObject.Value;
if handles.j3{1}
    set(handles.slider_j3_mean,'Enable','On')
    set(handles.slider_j3_std,'Enable','On')
    set(handles.slider_j3_N,'Enable','On')
else
    set(handles.slider_j3_mean,'Enable','Off')
    set(handles.slider_j3_std,'Enable','Off')
    set(handles.slider_j3_N,'Enable','Off')
    set(handles.slider_j3_mean,'Value',0)
    set(handles.slider_j3_std,'Value',0)
    set(handles.slider_j3_N,'Value',0)
end

function checkbox_j4_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j4{1} = hObject.Value;
if handles.j4{1}
    set(handles.slider_j4_mean,'Enable','On')
    set(handles.slider_j4_std,'Enable','On')
    set(handles.slider_j4_N,'Enable','On')
else
    set(handles.slider_j4_mean,'Enable','Off')
    set(handles.slider_j4_std,'Enable','Off')
    set(handles.slider_j4_N,'Enable','Off')
    set(handles.slider_j4_mean,'Value',0)
    set(handles.slider_j4_std,'Value',0)
    set(handles.slider_j4_N,'Value',0)
end

function checkbox_j5_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j5{1} = hObject.Value;
if handles.j5{1}
    set(handles.slider_j5_mean,'Enable','On')
    set(handles.slider_j5_std,'Enable','On')
    set(handles.slider_j5_N,'Enable','On')
    set(handles.slider_j5_mean,'Value',0)
    set(handles.slider_j5_std,'Value',0)
    set(handles.slider_j5_N,'Value',0)
else
    set(handles.slider_j5_mean,'Enable','Off')
    set(handles.slider_j5_std,'Enable','Off')
    set(handles.slider_j5_N,'Enable','Off')
end

function checkbox_j6_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j6{1} = hObject.Value;
if handles.j6{1}
    set(handles.slider_j6_mean,'Enable','On')
    set(handles.slider_j6_std,'Enable','On')
    set(handles.slider_j6_N,'Enable','On')
else
    set(handles.slider_j6_mean,'Enable','Off')
    set(handles.slider_j6_std,'Enable','Off')
    set(handles.slider_j6_N,'Enable','Off')
    set(handles.slider_j6_mean,'Value',0)
    set(handles.slider_j6_std,'Value',0)
    set(handles.slider_j6_N,'Value',0)
end

function push_clear_Callback(hObject, ~, handles) %#ok<DEFNU>
h_ini = struct2cell(handles.ini);
for cell=1:length(h_ini)
    if isa(h_ini{cell},'UIControl')
        uiControl = h_ini(cell);
        enable = uiControl.Enable ;
        set(uiControl, 'Enable', enable)
    end
end
guidata(hObject, handles);

function push_classify_Callback(~, ~, handles)%#ok<DEFNU>
    jointset = get_jointset_gauss(handles);
    handles.jointset = jointset;
    n=0;
    for j=1:6
        if jointset.used{j}
            n = n+1;
            new_jointset.G_mean{n} = jointset.G_mean{j};
            if jointset.G_mean{j}<0
                jointset.G_mean{j}=0;
            end
            new_jointset.G_std{n}  = jointset.G_std{j};
            new_jointset.G_N{n}  = jointset.G_N{j};
            
        end
    end
    new_jointset.NBjointSet= n;
    %Find intersection
    intersection = find_jointSetLimits(new_jointset);
    %Classify results
    classify_fromGaussians(intersection, handles.nodes, handles.joint_file)
