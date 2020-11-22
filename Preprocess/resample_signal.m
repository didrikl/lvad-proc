function T = resample_signal(T,sampleRate,method)
    %RESAMPLE_SIGNAL resamples timetable 
    % Resampling timetable T. Columns that have the true value in a 
    % T.Properties.CustomProperties.Measured or any (derived) continious 
    % variable are re-samples. Remaining variables are set aside and
    % fused into the resampled table by the fuse_timetables function, for 
    % which the T.Properties.VariableContinuity dictates how the fusion process
    % is done.
    %
    % Input:
    %  T: Timetable
    %  sampleRate: New sample rate.
    %  method (optional): Method, as supported by Matlab's retime function
    %
    % Examples:
    %  T = resample_signal(T,fs)
    %  T = resample_signal(T,fs,method)
    %
    % See also timetable, retime, fuse_timetables
    %
    
    % Method default settings
    if nargin<3, method = 'linear'; end
    
    fprintf('\nResampling:')
    fprintf('\n\tMethod: %s',method)
    fprintf('\n\tNew sample rate: %d',sampleRate)
    
    % Resample to even sampling, before adding categorical data and more from notes
    measured_cols = T.Properties.CustomProperties.Measured;
    derived_cols = T.Properties.VariableContinuity=='continuous' & not(measured_cols);
    resamp_cols = measured_cols | derived_cols;
    %TODO: 
    % int_resamp_cols = resamp_cols && isa(T{:,resamp_cols),'int16')
    % T{:,int_resamp_cols} = single(T{:,int_resamp_cols});
    % ...resample...
    % T{:,int_resamp_cols} = int(T{:,int_resamp_cols});
    merge_cols = not(resamp_cols);
    merge_varNames = T.Properties.VariableNames(merge_cols);
    resamp_varNames = T.Properties.VariableNames(resamp_cols);
  
    fprintf('\n\tRe-sampling: %s\n',strjoin(resamp_varNames,', '))
    
    % In case there are notes columns merged with signal, then these columns
    % must be kept separately and then merged with signal after resampling
    if any(merge_cols)
        fprintf('\tRe-merging: %s\n',strjoin(merge_varNames,', '))
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
