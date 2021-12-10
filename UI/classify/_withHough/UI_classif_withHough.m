function varargout = UI_classif_withHough(varargin)
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help UI_classif_withHough% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_classif_withHough_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_classif_withHough_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function UI_classif_withHough_OpeningFcn(hObject, ~, handles, varargin)
handles.isFile = 0;
handles.plot = [];
handles.output = hObject;
guidata(hObject, handles);

function varargout = UI_classif_withHough_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

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
   set(handles.slider_j2_mean, 'Enable', 'on')
   set(handles.slider_j2_std, 'Enable', 'on')
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

   figure()
   [nodes, ~] = polylines_to_lines(nodes); 
   %Plot in Hough frame
   axes(handles.hough_plot)
   hold on
   title('Hough transform')
   xlabel('Theta')
   ylabel('r')  
   for j = 1:length(nodes.iD)
       x = nodes.line{j}(1);
       y = nodes.line{j}(3);
       nodes.r{j} = y*cosd(nodes.ori_mean_deg{j}) - x*sind(nodes.ori_mean_deg{j});      
       plot(nodes.ori_mean_deg{j}, nodes.r{j}, 'r.');
   end
   %Get joint informations
   jointset = get_jointset_hough(handles);
   handles.jointset = jointset;
   %Plot estimation
   handles = plot_hough_inUI(handles);
   guidata(hObject,handles);
       
function slider_j3_mean_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t3_mean, 'String', fix(jointset.H_mean{3}));
    guidata(hObject, handles)
 
function slider_j3_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j3_std_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t3_std, 'String', fix(jointset.H_std{3}));
    guidata(hObject, handles)
 
function slider_j3_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j4_std_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t4_std, 'String', fix(jointset.H_std{4}));
    guidata(hObject, handles)
 
function slider_j4_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j4_mean_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t4_mean, 'String', fix(jointset.H_mean{4}));
    guidata(hObject, handles)

function slider_j4_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j5_mean_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t5_mean, 'String', fix(jointset.H_mean{5}));
    guidata(hObject, handles)

function slider_j5_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j5_std_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t5_std, 'String', fix(jointset.H_std{5}));
    guidata(hObject, handles)

function slider_j5_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j6_std_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t6_std, 'String', fix(jointset.H_std{6}));
    guidata(hObject, handles)

function slider_j6_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j6_mean_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t6_mean, 'String', fix(jointset.H_mean{6}));
    guidata(hObject, handles)

function slider_j6_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j1_std_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t1_std, 'String', fix(jointset.H_std{1}));
    guidata(hObject, handles)

function slider_j1_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j2_std_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t2_std, 'String', fix(jointset.H_std{2}));
    guidata(hObject, handles)

function slider_j2_std_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j2_mean_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t2_mean, 'String', fix(jointset.H_mean{2}));
    guidata(hObject, handles)

function slider_j2_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_j1_mean_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function checkbox_j2_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j2{1} = hObject.Value;
if handles.j2{1}
    set(handles.slider_j2_mean,'Enable','On')
    set(handles.slider_j2_std,'Enable','On')
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t2_mean, 'String', fix(jointset.H_mean{2}));
    set(handles.t2_std, 'String', fix(jointset.H_std{2}));
    guidata(hObject, handles)
else
    set(handles.slider_j2_mean,'Enable','Off')
    set(handles.slider_j2_std,'Enable','Off')
    set(handles.slider_j2_mean,'Value',0)
    set(handles.slider_j2_std,'Value',0)
    %Remove plot
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t2_mean, 'String', '');
    set(handles.t2_std, 'String', '');
    guidata(hObject, handles)
end

function checkbox_j3_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j3{1} = hObject.Value;
if handles.j3{1}
    set(handles.slider_j3_mean,'Enable','On')
    set(handles.slider_j3_std,'Enable','On')
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t3_mean, 'String', fix(jointset.H_mean{3}));
    set(handles.t3_std, 'String', fix(jointset.H_std{3}));
    guidata(hObject, handles)
else
    set(handles.slider_j3_mean,'Enable','Off')
    set(handles.slider_j3_std,'Enable','Off')
    set(handles.slider_j3_mean,'Value',0)
    set(handles.slider_j3_std,'Value',0)
    %Remove plot
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t3_mean, 'String', '');
    set(handles.t3_std, 'String', '');
    guidata(hObject, handles)
end

function checkbox_j4_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j4{1} = hObject.Value;
if handles.j4{1}
    set(handles.slider_j4_mean,'Enable','On')
    set(handles.slider_j4_std,'Enable','On')
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t4_mean, 'String', fix(jointset.H_mean{2}));
    set(handles.t4_std, 'String', fix(jointset.H_std{2}));
    guidata(hObject, handles)
else
    set(handles.slider_j4_mean,'Enable','Off')
    set(handles.slider_j4_std,'Enable','Off')
    set(handles.slider_j4_mean,'Value',0)
    set(handles.slider_j4_std,'Value',0)
    %Remove plot
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t4_mean, 'String', '');
    set(handles.t4_std, 'String', '');
    guidata(hObject, handles)
end

function checkbox_j5_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j5{1} = hObject.Value;
if handles.j5{1}
    set(handles.slider_j5_mean,'Enable','On')
    set(handles.slider_j5_std,'Enable','On')
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t5_mean, 'String', fix(jointset.H_mean{2}));
    set(handles.t5_std, 'String', fix(jointset.H_std{2}));
    guidata(hObject, handles)
else
    set(handles.slider_j5_mean,'Enable','Off')
    set(handles.slider_j5_std,'Enable','Off')
    set(handles.slider_j5_mean,'Value',0)
    set(handles.slider_j5_std,'Value',0)
    %Remove plot
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t5_mean, 'String', '');
    set(handles.t5_std, 'String', '');
    guidata(hObject, handles)
end

function checkbox_j6_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.j6{1} = hObject.Value;
if handles.j6{1}
    set(handles.slider_j6_mean,'Enable','On')
    set(handles.slider_j6_std,'Enable','On')
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t6_mean, 'String', fix(jointset.H_mean{2}));
    set(handles.t6_std, 'String', fix(jointset.H_std{2}));
    guidata(hObject, handles)
else
    set(handles.slider_j6_mean,'Enable','Off')
    set(handles.slider_j6_std,'Enable','Off')
    set(handles.slider_j6_mean,'Value',0)
    set(handles.slider_j6_std,'Value',0)
    %Remove plot
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t6_mean, 'String', '');
    set(handles.t6_std, 'String', '');
    guidata(hObject, handles)
end

function slider_j1_mean_Callback(hObject, ~, handles) %#ok<DEFNU>
    %Get joints information 
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    handles = refresh_plot_hough(handles);
    set(handles.t1_mean, 'String', fix(jointset.H_mean{1}));
    guidata(hObject, handles)

function push_clear_Callback(hObject, eventdata, handles) %#ok<DEFNU>

function push_validate1_Callback(~, ~, handles)%#ok<DEFNU>
    jointset = get_jointset_hough(handles);
    handles.jointset = jointset;
    n=0;
    for j=1:6
        if jointset.used{j}
            n = n+1;
            new_jointset.H_mean{n} = jointset.H_mean{j};
            new_jointset.H_std{n}  = jointset.H_std{j};
        end
    end
    new_jointset.NBjointSet= n;
    classify_fromHough(new_jointset, handles.nodes, handles.joint_file)
