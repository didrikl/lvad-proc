function check_for_unlisted_notes_ids(Notes, idSpecs, id_inds)
	extraIDs = not(ismember(Notes.analysis_id,idSpecs.analysis_id)) & id_inds;
	if any(extraIDs)
		fprintf('\n\nExtra analysis IDs that are not defined:\n\n');
		disp(Notes(extraIDs,:))
	end