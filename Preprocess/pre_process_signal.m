function signal = pre_process_signal(signal, notes)
    
    fs = 520;
    resample_method = 'linear';

    % Must be applied before merging with note columns, as this function is
    % implemented with a given method.
    signal = resample_signal(signal, fs, resample_method);

    % Init notes, then signal and notes fusion (after resampling)
    signal = merge_signal_and_notes(signal,notes);
    signal = clip_to_experiment(signal,notes,fs);
