function T = adjust_for_linear_time_drift(T,secsAhead,defDriftRatePerSec,diffReadTime,inSyncTime)
    
    if isempty(T)
        warning('Input data table %s is empty',inputname(1))
        return
    end
    
    if nargin<4, diffReadTime = []; end
    if nargin<5, inSyncTime = []; end
    if nargin<3, defDriftRatePerSec = 0; end
    
    if isempty(diffReadTime), diffReadTime = T.time(end); end
    if isempty(inSyncTime), inSyncTime = T.time(1); end   
    if isempty(secsAhead)
        % Driften taken as avergae from drift overview Excel sheet
        driftRatePerSec = defDriftRatePerSec;
        fprintf('Drift per second: %g (apriori, not measured)\n',...
            driftRatePerSec)
    else
        driftDur = seconds(diffReadTime-inSyncTime);
        driftRatePerSec = secsAhead/driftDur;
        fprintf('Drift per second: %g\n',driftRatePerSec)
    end
    
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
    
    