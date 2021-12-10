function gaussians = computeGaussians(jointset_info)
    global theta_vector
    theta_vector = (0:2:179);
    NBjointSet = jointset_info.NBjointSet;
    gaussian_curves = NaN(90, NBjointSet);
    G_mean  = jointset_info.G_mean;
    G_std   = jointset_info.G_std;
    G_N     = jointset_info.G_N;
    for joint = 1:NBjointSet
        H       = NaN(90,1);
        histo1  = G_N{joint}* normpdf(theta_vector,     G_mean{joint}, G_std{joint});
        histo2  = G_N{joint}* normpdf(theta_vector-180, G_mean{joint}, G_std{joint});
        histo3  = G_N{joint}* normpdf(theta_vector+180, G_mean{joint}, G_std{joint});
        indice1 = find(histo1>0.0001);
        indice2 = find(histo2>0.0001);
        indice3 = find(histo3>0.0001);
        H(indice1) = histo1(indice1);
        H(indice2) = histo2(indice2);
        H(indice3) = histo3(indice3);
        H(isnan(H))=0;
        gaussian_curves(:,joint) = H;
    end	
    gaussians.curves = gaussian_curves;
    gaussians.sum     = sum(gaussian_curves,2) + jointset_info.noise;	
end