function T = adjust_for_system_m_time_drift(T,secsAhead,varargin)
    
    welcome('Adjust system M linear time drift')
    
    % TODO:
    % Check that numel(secsAhead) must correspond to numel(T)
    
    defDriftRatePerSec = 0.002012984;
    
    for i=1:numel(T)
        
        if isempty(T{i})
            warning('Input data table %s is empty',inputname(1))
            continue
        end

        T{i} = adjust_for_linear_time_drift(T{i},secsAhead{i},defDriftRatePerSec,varargin{:});

    end