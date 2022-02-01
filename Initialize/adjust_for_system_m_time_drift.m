function T = adjust_for_system_m_time_drift(T, secsAhead, varargin)
    
	if isempty(secsAhead), return; end
	
    welcome('Adjust system M linear time drift')
    
	if numel(secsAhead)~=numel(T)
		error(sprintf(['Number of drift corrections (%d no of cells) is ',...
			'unequal to number of table blocks (%d number of cells)',...
			numel(secsAhead),numel(T)]))
	end

	% This drift default is used only if secsAhead is empty
    defDriftRatePerSec = 0.002012984;
    
    for i=1:numel(T)
        
		isEmpty = display_block_info(T{i},i,numel(T));
        if isEmpty, continue; end

        T{i} = adjust_for_linear_time_drift(...
			T{i}, secsAhead{i}, defDriftRatePerSec, varargin{:});

    end