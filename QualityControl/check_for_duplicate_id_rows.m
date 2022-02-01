function check_for_duplicate_id_rows(T, id_inds)
	[~, dups] = find_cellstr_duplicates(cellstr(T.analysis_id(id_inds)));
	if not(isempty(dups))
		dup_inds = ismember(T.analysis_id,dups);
		fprintf('\n\n\tDuplicate IDs:\n\t\t%s\n\n',strjoin(unique(dups),'\n\t\t'))
		disp(T(dup_inds,:))
	end