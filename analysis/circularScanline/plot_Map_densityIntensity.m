function plot_Map_densityIntensity(xw,yw,density_vect,intensity_vect,dx)    
    
    figure()
    % Intensity map plot
    subplot(2,1,1) 
    image(xw,yw,reshape(intensity_vect,[length(unique(xw)), length(unique(yw))])','CDataMapping','scaled')
    colorbar
    title('Intensity map')
    set(gca,'YDir','normal') 

    % Density map plot
    subplot(2,1,2) 
    image(xw,yw,reshape(density_vect,[length(unique(xw)), length(unique(yw))])','CDataMapping','scaled')
    colorbar
    title('Density map')    
    set(gca,'YDir','normal')    
    
end