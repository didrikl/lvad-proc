function T = map_varnames(T,varNames_raw,varNames_mat)
    
    varNames_T = T.Properties.VariableNames;
    
    missing_vars = varNames_mat(not(ismember(varNames_raw,varNames_T)));
    if not(isempty(missing_vars))
        warning(sprintf(['\n\tVariable name mapping is inconsistent with:'...
            '\n\t\t',strjoin(missing_vars,', ')]))
        %TODO
        %Ask for input: Abort, ignore/cont., give new name
    end
    
    T.Properties.VariableNames = varNames_mat(ismember(varNames_raw,varNames_T));
    
