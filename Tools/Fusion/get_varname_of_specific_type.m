function [vars,S_sub] = get_varname_of_specific_type(S,type)
    % type must be supported by Matlab's subscript-generator function vartype.
    %
    % See vartype
	
    t = vartype(type);
    S_sub = S(:,t);
    vars = S_sub.Properties.VariableNames;
    
end