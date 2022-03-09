function [T, segStarts, segEnds] = make_plot_data_G1(segIDs, S, var, fs, durLim)

	Notes = S.Properties.UserData.Notes;
	noteVars = [Notes.Properties.VariableNames(...
		Notes.Properties.CustomProperties.Measured),'pumpSpeed'];
	S = join_notes(S, Notes, noteVars);
	T = sort_table_in_given_order(segIDs, S, 'analysis_id');
	T.Properties.SampleRate = fs;
	
	segIDs = handle_missing_seg_id(segIDs, T);

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
		T = add_segment_data_G1(T,BL,var,inds,fs);
	end

	T.dur = linspace(0,1/fs*height(T),height(T))';
	segStarts = round(T.dur(segmentStart_inds));
	segEnds = round(T.dur(segmentEnd_inds));


function segIDs = handle_missing_seg_id(segIDs, T)
	misSegID = not(ismember(segIDs,unique(T.analysis_id)));
	if any(misSegID)
		warning('Missing segID: %s',strjoin(segIDs(misSegID),', '))
		segIDs(misSegID) = [];
	end