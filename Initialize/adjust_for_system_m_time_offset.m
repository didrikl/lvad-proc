function T = adjust_for_system_m_time_offset(T, offsets, timeVar)
    
	if nargin<3, timeVar = 'time'; end
	if isempty(offsets), return; end

    welcome('Adjust system M constant time offsets')
    
	if numel(offsets)~=numel(T)
		error(sprintf(['Number of offset corrections (%d no of cells) is ',...
			'unequal to number of table blocks (%d number of cells)',...
			numel(offsets),numel(T)]))
	end

% 	startTimeCut = Notes.time(find(Notes.intervType=='Recording end',1,'first'))+minutes(1);
% 	endTimeCut = Notes.time(find(Notes.intervType=='Recording start',1,'first'))-minutes(1);

	for i=1:numel(T)

		isEmpty = display_block_info(T{i},i,numel(T));
		if isEmpty, continue; end

		T{i}.time = T{i}.(timeVar)-offsets{i};

% 		% Remove unneeded record outside notes sheet time range
% 		T(T.time>endTimeCut,:) = [];
% 		T(T.time<startTimeCut,:) = [];

	end

