function T = map_varnames(T,varNamesInFile,varNamesInCode)
    
    varNamesInT = T.Properties.VariableNames;
    
    missingVarsInCode = varNamesInT(not(ismember(varNamesInT,varNamesInFile)));
    if not(isempty(missingVarsInCode))
        warning(sprintf(['\n\tMissing variable(s) in code for mapping:'...
            '\n\t\t',strjoin(missingVarsInCode,', ')]))

    end
    
    missingVarsInFile = varNamesInCode(not(ismember(varNamesInFile,varNamesInT)));
    if not(isempty(missingVarsInFile))
        warning(sprintf(['\n\tMissing variable(s) in file for mapping:'...
            '\n\t\t',strjoin(missingVarsInFile,', ')]))
    end
    
    %NOTE: Can make UI and OO

    T.Properties.VariableNames = varNamesInCode(ismember(varNamesInFile,varNamesInT));
    
