function signal = resample_signal(signal, fs, method)

    % Resample to even sampling, before adding categorical data and more from notes
    signal = retime(signal,'regular',method,...
        'SampleRate',fs);
