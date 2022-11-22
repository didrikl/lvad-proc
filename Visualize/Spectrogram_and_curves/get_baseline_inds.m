function inds = get_baseline_inds(T)
	inds = ismember(T.intervType,{'Baseline','baseline'}) &...
		not(contains(lower(string(T.event)),{'echo'}));
	if nnz(inds)==0
		fprintf('\n')
		warning('No baseline denoted in Notes, first steady-state is used instead.')
		segs = get_segment_info(T);
		firstSS = find(ismember(segs.main.intervType,'Steady-state'),1,'first');
		inds = segs.all.startInd(firstSS):segs.all.endInd(firstSS);
	elseif diff(find(inds))>1
		fprintf('\n')
		warning('Multiple baseline segments in Notes')
	end