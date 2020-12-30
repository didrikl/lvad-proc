function fs = ask_for_new_sample_rate
    
    while true
        try
            fs = input(sprintf('\n\tGive sampling rate --> '));
            if isnumeric(fs) && mod(fs,1)==0 && fs>0
                break
            else
                fprintf('\nSampling rate must be positive integer, try again...\n')
            end
        catch
            fprintf('\nSampling rate must be positive integer, try again...\n')
        end
    end