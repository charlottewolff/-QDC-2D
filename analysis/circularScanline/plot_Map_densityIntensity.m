function plot_Map_densityIntensity(xw,yw,density_vect,intensity_vect,dx,R)    
    
    figure()
    % Intensity map plot
    subplot(2,1,1)
    intensity_mat = reshape(intensity_vect,[length(unique(yw)), length(unique(xw))]);
    h1=imagesc(xw,yw,intensity_mat,'CDataMapping','scaled');
    colorbar
    title('Intensity map')
    set(gca,'YDir','normal')
    set(h1, 'AlphaData', ~isnan(intensity_mat));
    axis equal

    % Density map plot
    subplot(2,1,2) 
    density_mat = reshape(density_vect,[length(unique(yw)), length(unique(xw))]);
    h2=imagesc(xw,yw,density_mat,'CDataMapping','scaled');
    colorbar
    title('Density map')    
    set(gca,'YDir','normal')
    set(h2, 'AlphaData', ~isnan(density_mat));
    axis equal
    
    figure()
    % Intensity estimator map plot
    subplot(3,1,1) 
    intensity__estimator_vect = intensity_vect/(4*R);
    intensity__estimator_mat = reshape(intensity__estimator_vect,[length(unique(yw)), length(unique(xw))]);
    h3=imagesc(xw,yw,intensity__estimator_mat,'CDataMapping','scaled');
    colorbar
    title('Intensity estimator (n) map')    
    set(gca,'YDir','normal') 
    set(h3, 'AlphaData', ~isnan(intensity__estimator_mat));
    axis equal
    
    % Density estimator map plot
    subplot(3,1,2) 
    density__estimator_vect = density_vect/(2*pi*R);
    density__estimator_mat = reshape(density__estimator_vect,[length(unique(yw)), length(unique(xw))]);
    h4=imagesc(xw,yw,density__estimator_mat,'CDataMapping','scaled');
    colorbar
    title('Density estimator (m) map')    
    set(gca,'YDir','normal')  
    set(h4, 'AlphaData', ~isnan(intensity__estimator_mat));
    axis equal
    
    % Trace length estimator map plot
    subplot(3,1,3) 
    tracelength__estimator_vect = intensity__estimator_vect*pi*R./(2*density__estimator_vect);
    tracelength__estimator_mat = reshape(tracelength__estimator_vect,[length(unique(yw)), length(unique(xw))]);
    h5=imagesc(xw,yw,tracelength__estimator_mat,'CDataMapping','scaled');
    colorbar
    title('Trace length estimator (n*pi*R/2*m) map')    
    set(gca,'YDir','normal')  
    set(h5, 'AlphaData', ~isnan(tracelength__estimator_mat));
    axis equal
    
end