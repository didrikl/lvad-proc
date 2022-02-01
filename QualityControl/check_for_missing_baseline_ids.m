function misBLIds = check_for_missing_baseline_ids(T)
	% check for any rows with analysis_id, but without baseline_id
	% (Vice-versa, baseline_id without analysis_id is ok.)
	misBLIds = ismissing(T.bl_id);
	if any(misBLIds)
		fprintf('\n')
		warning(sprintf('\n\tMissing baseline IDs at rows %s\n',...
			mat2str(T.noteRow(misBLIds))));	
	end