function T = adjust_for_system_m_time_offset(T, offsets, timeVar)
    
	if nargin<3, timeVar = 'time'; end
	if isempty(offsets), return; end

    welcome('Adjust system M constant time offsets')
    
	if numel(offsets)~=numel(T)
		error(sprintf(['Number of offset corrections (%d no of cells) is ',...
			'unequal to number of table blocks (%d number of cells)',...
			numel(offsets),numel(T)]))
	end

	for i=1:numel(T)

		isEmpty = display_block_info(T{i},i,numel(T));
		if isEmpty, continue; end

		T{i}.time = T{i}.(timeVar)-seconds(offsets{i});

	end

