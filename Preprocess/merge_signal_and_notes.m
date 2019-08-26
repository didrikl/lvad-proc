function data = merge_signal_and_notes(signal,notes)

    fprintf('\nMerging signal with notes:\n')
    
    [fs,signal] = check_sampling_frequency(signal);
    if isnan(fs), return; end
            
    % Ignore columns not in use when merging
    notes(:,all(ismissing(notes))) = [];
    
    % Merge only data with specified variable continuity (which is used for
    % filling empty entries in non-matching rows when syncing).
    notes_drop_cols = notes.Properties.VariableContinuity=='unset';
    notes_merge_cols = not(notes_drop_cols);
    notes_drop_varnames = notes.Properties.VariableNames(notes_drop_cols);
    notes_merge_varnames = notes.Properties.VariableNames(notes_merge_cols);
    fprintf('\n\tNotes variables to merge: %s',strjoin(notes_merge_varnames,', '))
    fprintf('\n\tNotes variables to drop: %s\n',strjoin(notes_drop_varnames,', '))
    
    notes_vars_already_in_signal = signal.Properties.VariableNames(...
        ismember(signal.Properties.VariableNames,notes_merge_varnames));
    if not(isempty(notes_vars_already_in_signal))
        opts = {
            'Remove in signal, before merging'
            'Ignore and continue'
            };
        msg = sprintf(['\nNotes varaibles exist already in signal: \n',...
            strjoin(notes_vars_already_in_signal,', ')]);
        response = ask_list_ui(opts,msg,1);
        if not(response), return; end
        if response==1, signal(:,notes_vars_already_in_signal) = []; end
    end
    
    notes = notes(:,notes_merge_varnames);
        %notes.Properties.VariableContinuity=='step'));
    data = synchronize(signal,notes,...
        'regular','SampleRate',fs);
    
    fprintf('\nMerging signal with notes done.\n')
    
    % After syncing and filling (according to given variable continuity), then
    % treat the not applicable placeholder as missing/undefined
    data = standardizeMissing(data,'-');
    