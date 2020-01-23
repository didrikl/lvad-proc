function signal = resample_signal(signal,fs)
    % RESAMPLE_SIGNAL
    
    % Must be applied before merging with note columns, as this function is
    % implemented with a given method.
    
    % Method default settings
    resample_method = 'linear';

    fprintf('\nResampling signal:')
    fprintf('\n\tMethod: %s',resample_method)
    
    % Resample to even sampling, before adding categorical data and more from notes
    % TODO: Implement a check/support for signal containing non-numeric columns
    meassued_cols = signal.Properties.CustomProperties.Measured;
    derived_cols = signal.Properties.VariableContinuity=='continuous' & not(meassued_cols);
    notes_cols = not(signal.Properties.VariableContinuity=='continuous');
        
    resamp_varnames = signal.Properties.VariableNames(meassued_cols);
    drop_varnames = {};
    notes_varnames = signal.Properties.VariableNames(notes_cols);
    
    if any(derived_cols)
        msg = sprintf('There are continous, but derived variables:\n\t%s',...
            strjoin(signal.Properties.VariableNames(derived_cols),', '));
        opts = {'Drop (delete) variables','Resample variables'};
        response = ask_list_ui(opts,msg,1);
        if response==2
            resamp_varnames = signal.Properties.VariableNames(meassued_cols & derived_cols);
        elseif response==1
            drop_varnames = signal.Properties.VariableNames(derived_cols);
        end
    end
    
    fprintf('\n\tVariable(s) to re-sample: %s',strjoin(resamp_varnames,', '))
    fprintf('\n\tVariable(s) to drop: %s\n',strjoin(drop_varnames,', '))
    
    % In case there are notes columns merged with signal, then these columns
    % must be kept separately and then merged with signal after resampling
    % NOTE: A better way is to merge with initialized notes table, which could
    % e.g. be accessible with object orientation
    if any(notes_cols)
        fprintf('\tVariable(s) to re-merge: %s\n',strjoin(notes_varnames,', '))
        notes_vars_in_signal = signal(:,notes_varnames);
   end
    
    % Resampling
    signal = retime(signal(:,resamp_varnames),...
        'regular',resample_method,...
        'SampleRate',fs);
    
    % Re-include notes info
    if any(notes_cols)
        signal = merge_signal_and_notes(signal,notes_vars_in_signal);
    end
        
    fprintf('Done.\n')