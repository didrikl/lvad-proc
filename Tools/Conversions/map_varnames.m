function [T,inFile_inds] = map_varnames(T,varNamesInFile,varNamesInCode)
    
    varNamesInT = T.Properties.VariableNames;
    
    % Handle uncovered columns in map (i.e. extra columns in file are removed)
    missingVarsInCode = varNamesInT(not(ismember(varNamesInT,varNamesInFile)));
    if numel(missingVarsInCode)>0
        warning(sprintf('\n\tVariables in file, but not in variable mapping:\n\t\t%s',...
            strjoin(missingVarsInCode,', ')));
        T(:,missingVarsInCode) = [];
    end
    
    % Update map when columns are missing in the file
    inFile_inds = ismember(varNamesInFile,varNamesInT);
    if any(not(inFile_inds))
        missingVarsInFile = varNamesInCode(not(ismember(varNamesInFile,varNamesInT)));
        warning(sprintf('\n\tVariables in variable mapping, but not in file:\n\t\t%s\n',...
            strjoin(missingVarsInFile,', ')));
    end
    
    T.Properties.VariableNames =  varNamesInCode(inFile_inds);
    
