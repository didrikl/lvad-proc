function [T,inFile_inds,inFile_vars] = map_varnames(T,fileMapVars,codeMapVars)
    
    varsInT = T.Properties.VariableNames;
    welcome('Variable mapping','function')
    fprintf('Varible expected to be found in file: %s\n',strjoin(fileMapVars))
    %fprintf('Varible expected to be found in file: %s\n',strjoin(codeMapVars))
    
    % Handle uncovered columns in map (i.e. extra columns in file are removed)
    isMissingInMap = not(ismember(varsInT,fileMapVars));
    if any(isMissingInMap)
        warning(sprintf([...
            '\n\tVariables found in file that are not listed in varaible ',...
            'mapping:\n\t\t%s'],strjoin(varsInT(isMissingInMap),', ')));
    end
    
    % Update map when columns are missing in the file
    varsInT = T.Properties.VariableNames;
    inFile_inds = find(ismember(fileMapVars,varsInT));
        
    isMissingInFile = find(not(ismember(fileMapVars,varsInT)));
    if any(isMissingInFile)
       warning(sprintf(...
           '\n\tVariables in variable mapping, but not in file:\n\t\t%s\n',...
            strjoin(fileMapVars(isMissingInFile)+...
            " (=> "+codeMapVars(isMissingInFile)+")",', ')));
    end

    % Rearrange columns according to map listing oder
    inFile_inds= inFile_inds(not(inFile_inds==0));
    inFile_vars = fileMapVars(inFile_inds);
    
    T = T(:,inFile_vars);
    T.Properties.VariableNames = codeMapVars(inFile_inds);
