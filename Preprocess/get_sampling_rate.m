function [fs,T] = get_sampling_rate(T,ask_user_if_nan)
    
    if nargin<2, ask_user_if_nan = true; end
    
    if istimetable(T)
        
        % If timetable that is regular, then sample rate is set as a property
        % automatically by Matlab
        fs = T.Properties.SampleRate;
    
    else
        
        % In case input is a table, but not a timetable, check in metadata
        try
            fs = T.Properties.UserData.SampleRate;
        catch
            fs = nan;
        end
        
    end
    
    if isnan(fs) && ask_user_if_nan
        
        opts = {
            'Re-sample'
            'Set sampling frequency'
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
            T = resample_signal(T,fs);
        
        elseif response==2
            fs = input(sprintf('\n\tGive sampling frequency --> '));
            T.Properties.UserData.SampleRate = fs;
            
        elseif response==4
            abort
            
        end
        
    end
    