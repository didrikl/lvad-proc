function check_emboli(s_id_tab,var,threshold)
	
	%TODO: check if variable exist
	vol = sum(s_id_tab.(var));
	if vol>threshold
		warning(['Accumulated emboli volume >',num2str(threshold),...
			' muL detected: ',num2str(vol)])
		% TODO: Display id info as well
	end
