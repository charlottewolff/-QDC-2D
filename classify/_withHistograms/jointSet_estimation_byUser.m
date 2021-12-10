function jointsets = jointSet_estimation_byUser()
	confirm = 'N';
	while confirm ~= 'Y'
		%---------Input 
		question_NBjointSet = 'Number of joint sets you estimate ? : ';
		NBjointSet = input(question_NBjointSet);
        
        %Jointset structure with parameters
        jointsets.NBjointSet = NBjointSet;
                                
		%for each jointset, estimation of gaussians parameters
        for joint = 1:NBjointSet
			fprintf('Joint set %d : ', joint);
			question_mean = 'Gaussian mean you estimate ? : ';
			question_std  = 'Gaussian std you estimate ? : ';
			question_N    = 'Gaussian amplitude you estimate ? : ';
			mean          = input(question_mean);
			std           = input(question_std);
			N             = input(question_N);
            
			jointsets.G_mean{joint} = mean; 
			jointsets.G_std{joint}  = std;
			jointsets.G_N{joint}    = N;
        end
        %Noise estimation
		question_noise    = 'Noise you estimate ? : ';
		jointsets.noise          = input(question_noise);
		
		%---------resume estimation : 
		fprintf('---------------------------------------\n');
		fprintf('Confirm your estimation : \n');
		fprintf('%d join sets\n', NBjointSet);
		disp('Mean -- std -- N\n');
		resume = [(cell2mat(jointsets.G_mean))' (cell2mat(jointsets.G_std))' (cell2mat(jointsets.G_N))'];
		disp(resume);
		fprintf('Noise your estimate : %f\n', jointsets.noise);
		fprintf('---------------------------------------\n');
		
        % User confirmation
		question_comfirm = 'Confirm ? Y/N   ';
		confirm = input(question_comfirm, 's');
	end
end