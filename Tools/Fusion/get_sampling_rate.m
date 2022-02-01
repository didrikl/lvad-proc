function [fs,T] = get_sampling_rate(T, askIfNan)
    % Get sample rate of a table or a timetable by:
    % 
    % 1) Checking T.Properties.SampleRate in input is a timetables, or
    %    checking T.Properties.UserData.SampleRate in input is a table
    %
    % 2) If no sampleRate property is found, then ask the user to set a new 
    %    sample rate, with or without re-sampling
    %
    % See also resample_signal, timetable
    
    if nargin<2, askIfNan = true; end
    
    % If the input table is a regular timetable, then sample rate is set as a
    % property automatically by Matlab, otherwise the userdata is also checked  
    if istimetable(T)
        fs = T.Properties.SampleRate;
    else  
        try
            fs = T.Properties.UserData.SampleRate;
        catch
            fs = nan;
        end
    end
    
    if isnan(fs) && askIfNan
        
        opts = {
            'Set new and re-sample'
            'Set new'
            'Ignore'
            'Abort'
            };
        response = ask_list_ui(opts,sprintf('\n\tSample rate is undefined'));
        if response==1
            fs = ask_for_new_sample_rate;
            T = resample_signal(T,fs); 
        elseif response==2
            fs = ask_for_new_sample_rate;
            T.Properties.UserData.SampleRate = fs;        
        elseif response==4
            abort   
        end
        
    end
    