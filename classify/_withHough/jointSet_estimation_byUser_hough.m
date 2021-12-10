function jointsets = jointSet_estimation_byUser_hough()
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
			question_mean = 'Orientation mean you estimate ? : ';
			question_std  = 'STD you estimate ? : ';
			mean          = input(question_mean);
			std           = input(question_std);
            
			jointsets.H_mean{joint} = mean; 
			jointsets.H_std{joint}  = std;
        end
		
		%---------resume estimation : 
		fprintf('---------------------------------------\n');
		fprintf('Confirm your estimation : \n');
		fprintf('%d join sets\n', NBjointSet);
		disp('Mean -- std\n');
		resume = [(cell2mat(jointsets.H_mean))' (cell2mat(jointsets.H_std))'];
		disp(resume);
		fprintf('---------------------------------------\n');
		
        % User confirmation
		question_comfirm = 'Confirm ? Y/N   ';
		confirm = input(question_comfirm, 's');
	end
end