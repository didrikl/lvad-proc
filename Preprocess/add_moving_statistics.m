function T_parts = add_moving_statistics(T_parts, varNames, statisticTypes)
    % Function for IV2 model to add relevant variables
    % TODO: Make this an IV2 object method
    
    % Add moving statistics (first values in each part will be NaN)
    % Good practice could e.g. be to do some extra recording at start of
    % the part before doing interventions, which would avoid such gaps.
    
    if nargin<2, varNames = {'accA_norm'}; end
    if nargin<3, statisticTypes = {'RMS','Std','Min','Max','Avg'}; end
    
    rms_winDur = 1;
    std_winDur = 10;
    min_winDur = 5;
    max_winDur = 5;
    avg_winDur = 10;
    
    
    welcome('Calculating moving statistics')
    fprintf(['\nCalculations\n\tMoving RMS in %d sec windows',...
        '\n\tMoving SD in %d sec windows\n'],rms_winDur,std_winDur);
    stdNames = varNames+"_movStd";
    rmsNames = varNames+"_movRMS";
    minNames = varNames+"_movMin";
    maxNames = varNames+"_movMax";
    avgNames = varNames+"_movAvg";
    fprintf('Input\n\t%s\nOutput\n\tRMS: %s\n\tSD: %s\n',...
        strjoin(varNames,', '),strjoin(rmsNames,', '),strjoin(stdNames,', '))
    
    for i=1:numel(T_parts)
        
        if height(T_parts{i})==0, continue; end
        fs = T_parts{i}.Properties.SampleRate;
        
        T_parts{i} = calc_moving(T_parts{i},varNames,{'RMS'},fs*rms_winDur);
        T_parts{i} = calc_moving(T_parts{i},varNames,{'Std'},fs*std_winDur);
%         T_parts{i} = calc_moving(T_parts{i},varNames,{'Min'},fs*min_winDur);
%         T_parts{i} = calc_moving(T_parts{i},varNames,{'Max'},fs*max_winDur);
        T_parts{i} = calc_moving(T_parts{i},varNames,{'Avg'},fs*avg_winDur);
       
    end
    
    T_parts = convert_to_single(T_parts, rmsNames);
    T_parts = convert_to_single(T_parts, stdNames);

    clear clear check_var_output_to_table
    clear clear check_var_input_to_table
    
    
    
