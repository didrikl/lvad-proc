function [T, segmentStarts, segmentEnds] = make_plot_data(segIDs, S, ...
		accVar, fs, durLim, plotType)
	% TODO: Make object oriented by dedicated functions for what's inside the
	% for-loop, depending on what plot and experiments type.

	T = sort_table_in_given_order(segIDs, S, 'analysis_id');
	Notes = T.Properties.UserData.Notes;
	T = join(T,Notes(:,{'noteRow','pumpSpeed'}),'Keys','noteRow');
	T.Properties.SampleRate = fs;
	
	% Which type of data to add for plotting
	% NOTE: This is proably better as object oriented
	switch plotType
		case 'IV2', f = @add_segment_data_IV2;
		case 'G1',	f = @add_segment_data_G1;
	end

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
		T = f(T,BL,accVar,inds,fs);
	end

	T.dur = linspace(0,1/fs*height(T),height(T))';
	segmentStarts = round(T.dur(segmentStart_inds));
	segmentEnds = round(T.dur(segmentEnd_inds));
