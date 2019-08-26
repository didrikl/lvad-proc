function signal = resample_signal(signal,fs)
    % RESAMPLE_SIGNAL
    
    % Must be applied before merging with note columns, as this function is
    % implemented with a given method.
    
    % Method default settings
    resample_method = 'linear';

    fprintf('\nResampling signal:\n')
    fprintf('\n\tMethod: %s',resample_method)
    
    % Resample to even sampling, before adding categorical data and more from notes
    % TODO: Implement a check/support for signal containing non-numeric columns
    resamp_cols = signal.Properties.VariableContinuity=='continuous';
    vars_to_resample = signal.Properties.VariableNames(resamp_cols);
    fprintf('\n\tVariable(s) to resample: %s\n',strjoin(vars_to_resample,', '))
    
    drop_cols = not(resamp_cols);
    if any(drop_cols)
        vars_to_drop = signal.Properties.VariableNames(drop_cols);
        fprintf('\tVariable(s) considered as notes: %s\n',strjoin(vars_to_drop,', '))
        notes_from_signal = signal(:,vars_to_drop);
        signal = retime(signal(:,vars_to_resample),...
            'regular',resample_method,...
            'SampleRate',fs);
    
        signal = merge_signal_and_notes(signal,notes_from_signal);
    end
    
    fprintf('\nResampling done.\n')