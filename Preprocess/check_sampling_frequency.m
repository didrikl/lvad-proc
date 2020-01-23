function [fs,signal] = check_sampling_frequency(signal)
    
    fs = signal.Properties.SampleRate;
    
    if isnan(fs)
        
        opts = {
            'Run re-sampling'
            'Ignore'
            'Abort'
            };
        response = ask_list_ui(opts,sprintf('\n\n\tSample rate is undefined'));
        if response==1
            while true
                try
                    fs = input(sprintf('\n\tGive sampling frequency --> '));
                    if isnumeric(fs) && mod(fs,1)==0 && fs>0
                        break
                    else
                        fprintf('\nSampling frequency must be positive integer, try again...\n')
                    end
                catch
                    fprintf('\nSampling frequency must be positive integer, try again...\n')
                end
            end
            signal = resample_signal(signal,fs);
        elseif response==3
            abort
        end
        
    end
    