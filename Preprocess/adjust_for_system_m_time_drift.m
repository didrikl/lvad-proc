function T = adjust_for_system_m_time_drift(T,secsAhead,varargin)
    
    welcome('Adjust system M linear time drift')
    
    % TODO:
    % Check that numel(secsAhead) must correspond to numel(T)
	
    defDriftRatePerSec = 0.002012984;
    
    for i=1:numel(T)
        
		isEmpty = display_block_info(T{i},i,numel(T));
        if isEmpty, continue; end

        T{i} = adjust_for_linear_time_drift(T{i},secsAhead{i},defDriftRatePerSec,varargin{:});

    end