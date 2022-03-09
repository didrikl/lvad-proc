function check_for_missing_ids_in_data(idSpecs, T, id_inds)
	misIDs = not(ismember(idSpecs.analysis_id,T.analysis_id(id_inds)))...
		& not(idSpecs.contingency) & not(idSpecs.extra);
	if any(misIDs)
		fprintf('\n\nMissing analysis IDs:\n\n');
		disp(idSpecs(misIDs,:))
	end