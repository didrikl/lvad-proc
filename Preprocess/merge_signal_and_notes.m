function data = merge_signal_and_notes(signal,notes)
    signal.Properties.SampleRate
    % Ignore columns not in use when merging
    notes(:,all(ismissing(notes))) = [];
    
    % Merge only data with specified variable continuity (which is used for
    % filling empty entries in non-matching rows when syncing).
    notes = notes(:,notes.Properties.VariableNames(...
        not(notes.Properties.VariableContinuity=='unset')));  
        %notes.Properties.VariableContinuity=='step'));
    data = synchronize(signal,notes,'regular',...
        'SampleRate',signal.Properties.SampleRate);
    
    % After syncing and filling (according to given variable continuity), then
    % treat the not applicable placeholder as missing/undefined
    data = standardizeMissing(data,'-');
    