function T = spatial_comp_as_vector(T,compVarNames,newVarName)
    compVars = ismember(compVarNames,T.Properties.VariableNames);
    if any(not(compVars))
        str = sprintf("\n\t"+string(join(compVarNames(not(compVars)),', ')));
        warning(sprintf('\nSpatial components missing: ')+str)
    end
    
    T = mergevars(T,compVarNames(compVars),'NewVariableName',newVarName);
