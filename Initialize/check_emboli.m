function check_emboli(S,var,threshold)
	
	var = check_table_var_input(S,var);

	vol = sum(S.(var));
	id = unique(S.analysis_id);
	if vol>threshold
		warning(sprintf(...
			'Accumulated emboli volume > %g muL\n\tVolume: %g\n\tSegment ID: %s',...
			threshold,vol,id));
	end
