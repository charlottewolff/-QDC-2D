function jointset = get_jointset_hough(handles)
    %Get joints information 
    jointset.H_mean{1} = get(handles.slider_j1_mean, 'Value'); 
    jointset.H_mean{2} = get(handles.slider_j2_mean, 'Value');
    jointset.H_mean{3} = get(handles.slider_j3_mean, 'Value');
    jointset.H_mean{4} = get(handles.slider_j4_mean, 'Value');
    jointset.H_mean{5} = get(handles.slider_j5_mean, 'Value');
    jointset.H_mean{6} = get(handles.slider_j6_mean, 'Value');
    jointset.H_std{1} = get(handles.slider_j1_std, 'Value');
    jointset.H_std{2} = get(handles.slider_j2_std, 'Value');
    jointset.H_std{3} = get(handles.slider_j3_std, 'Value');
    jointset.H_std{4} = get(handles.slider_j4_std, 'Value');
    jointset.H_std{5} = get(handles.slider_j5_std, 'Value');
    jointset.H_std{6} = get(handles.slider_j6_std, 'Value');
    jointset.used{1} = 1; %always at least one joint set 
    jointset.used{2} = get(handles.checkbox_j2, 'Value');
    jointset.used{3} = get(handles.checkbox_j3, 'Value');
    jointset.used{4} = get(handles.checkbox_j4, 'Value');
    jointset.used{5} = get(handles.checkbox_j5, 'Value');
    jointset.used{6} = get(handles.checkbox_j6, 'Value');
    jointset.NBjointSet = 6;
end