function T = resample_signal(T,sampleRate,method)
    %RESAMPLE_SIGNAL resamples timetable 
    % Resampling T to new given sampling frequency fs. Method may by specified,
    % as supported by Matlab's retime function
    %
    % T = resample_signal(T,fs)
    % T = resample_signal(T,fs,method)
    %
    % See also timetable, retime
    %
    
    % Method default settings
    if nargin<3
        method = 'linear';
    end
    
    fprintf('\nResampling:')
    fprintf('\n\tMethod: %s',method)
    fprintf('\n\tNew sample rate: %d',sampleRate)
    
    % Resample to even sampling, before adding categorical data and more from notes
    % TODO: Implement a check/support for signal containing non-numeric columns
    measured_cols = T.Properties.CustomProperties.Measured;
    derived_cols = T.Properties.VariableContinuity=='continuous' & not(measured_cols);
    resamp_cols = measured_cols | derived_cols;
    merge_cols = not(resamp_cols);
        
%    resamp_varNames = T.Properties.VariableNames(meassued_cols);
    merge_varNames = T.Properties.VariableNames(merge_cols);
    resamp_varNames = T.Properties.VariableNames(measured_cols | derived_cols);
  
    fprintf('\n\tVariable(s) to re-sample: %s\n',strjoin(resamp_varNames,', '))
    
    % In case there are notes columns merged with signal, then these columns
    % must be kept separately and then merged with signal after resampling
    if any(merge_cols)
        fprintf('\tVariable(s) to re-merge: %s\n',strjoin(merge_varNames,', '))
        merge_varsTable = T(:,merge_varNames);
   end
    
    % Resampling
    T = retime(T(:,resamp_varNames),...
        'regular',method,...
        'SampleRate',sampleRate);
    
    % Re-include notes info
    if any(merge_cols)
        T = fuse_timetables(T,merge_varsTable,...
            'regular','SampleRate',sampleRate);
    end
        
    fprintf('\nResampling done.\n')