function S_parts = add_moving_statistics(S_parts)
    % Function for IV2 model to add relevant variables
    % TODO: Make this an IV2 object method
    
    % Add moving statistics (first values in each part will be NaN)
    % Good practice could e.g. be to do some extra recording at start of
    % the part before doing interventions, which would avoid such gaps.
    
    rms_winDur = 1;
    std_winDur = 10;
    
    welcome('Calculating moving statistics')
    
    fprintf('\tRMS of accA_norm in %d sec moving windows\n',rms_winDur)
    fprintf('\tStandard deviation of accA_norm in %d sec moving windows\n',std_winDur)
    for i=1:numel(S_parts)
        if height(S_parts{i})==0, continue; end
        fs = S_parts{i}.Properties.SampleRate;
        S_parts{i} = calc_moving(S_parts{i},{'accA_norm'},{'RMS'},fs*rms_winDur);
        S_parts{i} = calc_moving(S_parts{i},{'accA_norm'},{'Std'},fs*std_winDur);
        
        % for testing:
        S_parts{i} = calc_moving(S_parts{i},{'accA_1norm'},{'RMS'},fs*rms_winDur);
        S_parts{i} = calc_moving(S_parts{i},{'accA_1norm'},{'Std'},fs*std_winDur);
    end     
        
    fprintf('\tRMS of accA_xz_norm in %d sec moving windows\n',rms_winDur)
    fprintf('\tStandard deviation of accA_xz_norm in %d sec moving windows\n',std_winDur)
    for i=1:numel(S_parts)
        if height(S_parts{i})==0, continue; end
        fs = S_parts{i}.Properties.SampleRate;
        S_parts{i} = calc_moving(S_parts{i},{'accA_xz_norm'},{'RMS'},fs*rms_winDur);
        S_parts{i} = calc_moving(S_parts{i},{'accA_xz_norm'},{'Std'},fs*std_winDur);
        
        % for testing
        S_parts{i} = calc_moving(S_parts{i},{'accA_xz_1norm'},{'RMS'},fs*rms_winDur);
        S_parts{i} = calc_moving(S_parts{i},{'accA_xz_1norm'},{'Std'},fs*std_winDur);
    end
    
    clear clear check_var_output_to_table
    clear clear check_var_input_to_table
    
    
    
