function signal = resample_signal(signal)
    % RESAMPLE_SIGNAL
    
    % Must be applied before merging with note columns, as this function is
    % implemented with a given method.
    
    fs = 520;
    resample_method = 'linear';

    % Resample to even sampling, before adding categorical data and more from notes
    % TODO: Implement a check/support for signal containing non-numeric columns
    signal = retime(signal,'regular',resample_method,...
        'SampleRate',fs);
