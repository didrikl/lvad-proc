function [T,inFile_inds] = map_varnames(T,fileMapVarNames,codeMapVarNames)
    
    varNamesInT = T.Properties.VariableNames;
    
    % Handle uncovered columns in map (i.e. extra columns in file are removed)
    isMissingInMap = not(ismember(varNamesInT,fileMapVarNames));
    if any(isMissingInMap)
        warning(sprintf([...
            '\n\tVariables found in file that are not listed in varaible ',...
            'mapping:\n\t\t%s'],strjoin(varNamesInT(isMissingInMap),', ')));
        T(:,isMissingInMap) = [];
    end
    
    % Update map when columns are missing in the file
    varNamesInT = T.Properties.VariableNames;
    inFile_inds = NaN(numel(fileMapVarNames,1));
    for i=1:numel(fileMapVarNames)
        inFile_ind = find(ismember(varNamesInT,fileMapVarNames{i}));
        if inFile_ind
            inFile_inds(i) = inFile_ind;
        end
    end
        
    isMissingInFile = inFile_inds==0;
    if any(isMissingInFile)
       warning(sprintf('\n\tVariables in variable mapping, but not in file:\n\t\t%s\n',...
            strjoin(fileMapVarNames(isMissingInFile)+...
            " (=> "+codeMapVarNames(isMissingInFile)+")",', ')));
    end

    % Rearrange columns according to map listing oder
    inFile_inds(inFile_inds==0)=[];
    T = T(:,inFile_inds);
    T.Properties.VariableNames = codeMapVarNames(inFile_inds);
