function T = adjust_for_linear_time_drift(T,secsAhead,diffReadTime,inSyncTime)
    
    welcome('Adjusting for linear drift')
    
    if isempty(T)
        warning('Input data table %s is empty',inputname(1))
        return
    end
    
    if nargin<4, diffReadTime = T.time(end); end
    if nargin<5, inSyncTime = T.time(1); end
    
    driftDur = seconds(diffReadTime-inSyncTime);
    driftRatePerSec = secsAhead/driftDur;
    fprintf('Drift per second: %g\n\n',driftRatePerSec)
    
    % If T is a regular timetable, just update to a more accurate samplerate
    if istimetable(T) && isregular(T)
        T.Properties.SampleRate = T.Properties.SampleRate-driftRatePerSec;
        return
    end
    
    % Otherwise, compensate time info with calculated drift
    if istimetable(T)
        timeVarName = T.Properties.DimensionNames{1};
    else
        timeVarName = check_table_var_input(T, 'time');
    end
    
    tsteps = diff(T.(timeVarName));
    driftPerSample = driftRatePerSec*tsteps;
    driftAccum = [0;cumsum(driftPerSample)];
    
    T.(timeVarName) = T.(timeVarName)-driftAccum;
    
    