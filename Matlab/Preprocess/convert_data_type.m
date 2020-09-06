function T_parts = convert_data_type(T_parts, varNames)
    % Function for IV2 model to save memory in converting selected variables 
    % to single precission 
    % TODO: Make this an IV2 object method
    
    if nargin<2
        varNames = { 
            'accA_norm_movRMS'
            'accA_1norm_movRMS'
            'accA_xz_norm_movRMS'
            'accA_xz_1norm_movRMS'
            'accA_norm_movStd'
            'accA_1norm_movStd'
            'accA_xz_norm_movStd'
            'accA_xz_1norm_movStd'
            'accB_norm_movRMS'
            'accB_1norm_movRMS'
            'accB_xz_norm_movRMS'
            'accB_xz_1norm_movRMS'
            'accB_norm_movStd'
            'accB_1norm_movStd'
            'accB_xz_norm_movStd'
            'accB_xz_1norm_movStd'
            };  
    end  
    
    rms_winDur = 1;
    std_winDur = 10;
    
    welcome('Converting to single precision')
    fprintf('Variables:\n\t%s',strjoin(varNames,', '))
    fprintf(['\nCalculations:\n\tRMS in %d sec windows',...
        '\n\tSD in %d sec windows\n'],rms_winDur,std_winDur);
    
    for i=1:numel(T_parts)
        
        varNames_i = varNames(...
            ismember(varNames,T_parts{i}.Properties.VariableNames));
        
        % Convert to single precision to save memory
        T_parts{i}{:,varNames_i} = single(T_parts{i}{:,varNames_i});
        
    end     