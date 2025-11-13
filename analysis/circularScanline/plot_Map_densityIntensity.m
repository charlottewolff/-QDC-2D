function plot_Map_densityIntensity(xw,yw,intensity_vect,density_vect,total_length_vect,dx,R)    
    figure()
    colormap(flipud(hot)) 
    
    %% 1-Intensity map plot
    subplot(4,1,1)
    intensity__estimator_vect = intensity_vect /(4*R);
    intensity__estimator_mat = reshape(intensity__estimator_vect,[length(unique(yw)), length(unique(xw))]);
    h1=imagesc(xw,yw,intensity__estimator_mat,'CDataMapping','scaled');
    colorbar
    title('Intensity map')    
    set(gca,'YDir','normal') 
    set(h1, 'AlphaData', ~isnan(intensity__estimator_mat));
    axis equal

    %% 2-Density map plot
    subplot(4,1,2) 
    density__estimator_vect = density_vect/(2*pi*(R^2));
    density__estimator_mat = reshape(density__estimator_vect,[length(unique(yw)), length(unique(xw))]);
    h2=imagesc(xw,yw,density__estimator_mat,'CDataMapping','scaled');
    colorbar
    title('Density map')    
    set(gca,'YDir','normal')  
    set(h2, 'AlphaData', ~isnan(density__estimator_mat));
    axis equal

    %% 3-Trace length estimator map plot
    subplot(4,1,3) 
    tracelength__estimator_vect = intensity__estimator_vect*pi*R./(2*density__estimator_vect);
    tracelength__estimator_mat = reshape(tracelength__estimator_vect,[length(unique(yw)), length(unique(xw))]);
    h3=imagesc(xw,yw,tracelength__estimator_mat,'CDataMapping','scaled');
    colorbar
    title('Trace length estimator (n*pi*R/2*m) map')    
    set(gca,'YDir','normal')  
    set(h3, 'AlphaData', ~isnan(tracelength__estimator_mat));
    axis equal

    %% 4-Intensity map -- method 2
    subplot(4,1,4) 
    totalTraceLength_vect = total_length_vect./(pi*R^2);
    totalTraceLength_mat = reshape(totalTraceLength_vect,[length(unique(yw)), length(unique(xw))]);
    h4=imagesc(xw,yw,totalTraceLength_mat,'CDataMapping','scaled');
    colorbar
    title('Intensity map - method 2')    
    set(gca,'YDir','normal')  
    set(h4, 'AlphaData', ~isnan(totalTraceLength_mat));
    axis equal
    
end