function [T, segStarts, segEnds] = make_plot_data(segIDs, S, var, fs, durLim)

	T = sort_table_in_given_order(segIDs, S, 'analysis_id');
	Notes = T.Properties.UserData.Notes;
	T = join(T,Notes(:,{'noteRow','pumpSpeed'}),'Keys','noteRow');
	T.Properties.SampleRate = fs;
	
	for k=1:numel(segIDs)

		% Determine and clip out segments
		inds = find(ismember(T.analysis_id,segIDs{k}));
		clipInds = inds(fs*durLim:numel(inds));
		T(clipInds,:) = [];
		inds(ismember(inds,clipInds)) = [];
		
		% Store start and end of segments
		segmentStart_inds(k) = inds(1); %#ok<*AGROW> 
		segmentEnd_inds(k) = inds(end);
		
		% Lookup baseline
		bl_id = Notes.bl_id(Notes.analysis_id==segIDs{k});
		BL = S(ismember(S.analysis_id,bl_id),:);
		
		% Add relevant data for specified plot type
		T = add_segment_data(T,BL,var,inds,fs);
	end

	T.dur = linspace(0,1/fs*height(T),height(T))';
	segStarts = round(T.dur(segmentStart_inds));
	segEnds = round(T.dur(segmentEnd_inds));


	