function T_parts = make_curve_data_per_part(Data, accVars, Config, eventsToClip)

	movStdWin = Config.movStdWin;
	partSpec = Config.partSpec;
	accVars = cellstr(accVars);
	
	fs = Config.fs; 
	nParts = size(partSpec,1);
	
	% Extract relevant part, BL and Notes info
	T_parts = cell(nParts,1);
	for i=1:nParts
		T_parts{i} = extract_from_data(Data, partSpec(i,:), eventsToClip);
	end

	T_parts = add_norms_and_filtered_vars_as_needed(accVars, T_parts, Config);	
	T_parts = add_rel_diff_from_bl(T_parts, accVars, nParts, fs, movStdWin);
