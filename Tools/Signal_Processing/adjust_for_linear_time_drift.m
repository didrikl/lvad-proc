function T = adjust_for_linear_time_drift(T,secsAhead,diffReadTime,inSyncTime)
    
    % TODO: Make this as input...
    defDriftRatePerSec = 0.002007175;
        
    if isempty(T)
        warning('Input data table %s is empty',inputname(1))
        return
    end
    
    if nargin<3, diffReadTime = T.time(end); end
    if nargin<4, inSyncTime = T.time(1); end
    
    if isempty(secsAhead)
        % Driften taken as avergae from drift overview Excel sheet
        driftRatePerSec = defDriftRatePerSec;
        fprintf('Drift per second: %g (apriori, not measured)\n\n',...
            driftRatePerSec)
    else
        driftDur = seconds(diffReadTime-inSyncTime);
        driftRatePerSec = secsAhead/driftDur;
        fprintf('Drift per second: %g\n\n',driftRatePerSec)
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
    
    