function [T,inFile_inds] = map_varnames(T,varNamesInFile,varNamesInCode)
    
    varNamesInT = T.Properties.VariableNames;
    
    % Handle uncovered columns in map (i.e. extra columns in file are removed)
    missingVarsInCode = varNamesInT(not(ismember(varNamesInT,varNamesInFile)));
    if numel(missingVarsInCode)>0
        warning('\nt\tMissing variable(s) in code for variable mapping:\n\t\t%s',...
            strjoin(missingVarsInCode,', '));
        T(:,missingVarsInCode) = [];
    end
    
    % Update map when columns are missing in the file
    inFile_inds = ismember(varNamesInFile,varNamesInT);
    if any(not(inFile_inds))
        missingVarsInFile = varNamesInCode(not(ismember(varNamesInFile,varNamesInT)));
        warning(sprintf(['\n\tMissing variable(s) in file for mapping:'...
            '\n\t\t',strjoin(missingVarsInFile,', ')]))
    end
    
    %NOTE: Can make UI and OO

    T.Properties.VariableNames =  varNamesInCode(inFile_inds);% varNamesInCode(ismember(varNamesInFile,varNamesInT));
    
