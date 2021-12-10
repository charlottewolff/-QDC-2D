function intersection = find_jointSetLimits(gaussian_params)
    nbJointsSet = gaussian_params.NBjointSet;
    G_mean = cell2mat(gaussian_params.G_mean);
    G_std  = cell2mat(gaussian_params.G_std);
    G_N    = cell2mat(gaussian_params.G_N);
    gaussian_params
    if length(G_mean)<=1 % only on joint set, no intersection
        intersection = -1;
    else
        w = [G_mean', G_std', G_N'];


        intersection = NaN(1,nbJointsSet);
        gaussians_params = sortrows(w);

        for gauss=1:length(intersection)-1
           %define equation to minimize and to solve
           equation2solve = @(x) abs(gaussians_params(gauss+1,3)* normpdf(x, gaussians_params(gauss+1,1), gaussians_params(gauss+1,2)) - gaussians_params(gauss,3)* normpdf(x, gaussians_params(gauss,1), gaussians_params(gauss,2)));
           inter = fminsearch(equation2solve,(gaussians_params(gauss,1) + gaussians_params(gauss+1,1))/2);
           intersection(gauss) = inter;
        end

        %equation to solve for the intersection of first and last gaussians 
        equation2solve = @(x) abs(gaussians_params(end,3)* normpdf(x, gaussians_params(end,1), gaussians_params(end,2)) - gaussians_params(1,3)* normpdf(x, gaussians_params(1,1)+180, gaussians_params(1,2)));    
        inter = fminsearch(equation2solve,(gaussians_params(end,1) + gaussians_params(1,1)+180)/2);
        intersection(end) = inter; 
        %rescale intersection to have between (0-180)
        intersection(intersection>180)  = intersection(intersection>180)-180;
        intersection(intersection<0)    = intersection(intersection<0)+180;

        %Sorting results and resume
        intersection = sort(intersection);   
        disp('The classification limits are : ');
        disp(intersection);
    end

end