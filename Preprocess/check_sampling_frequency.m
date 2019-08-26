function [fs,signal] = check_sampling_frequency(signal)
    
    fs = signal.Properties.SampleRate;
    
    if isnan(fs)
        opts = {
            'Run resampling'
            'Ignore'
            'Abort'
            };
        response = ask_list_ui(opts,'Sample rate is undefined');
        if response==1
            fs = input(sprintf('\n\tGive sampling frequency --> '));
            signal = resample_signal(signal,fs);
        elseif response==3
            abort
        end
        
    end
    