function T = calc_norm(T, input_varnames)
    
    if nargin<2
        is_meassured = T.Properties.CustomProperties.Measured;
        input_varnames = T.Properties.VariableNames(is_meassured);
    end
    
    if not(iscell(input_varnames))
        input_varnames = {input_varnames};
    end
    
    new_var_suffix = '_norm';
    tableName = inputname(1);
    
    fprintf('\nCalculating Euclidian norm (L2-norm):\n')
    if not(isempty(tableName))
        fprintf('\tTable: %s\n',tableName)
    end
    
    for i=1:numel(input_varnames)
        
        [input_varname,output_varname] = ...
            check_calc_io(T,input_varnames{i},new_var_suffix);
        if isempty(output_varname), continue; end
                
        T.(output_varname) = sqrt(sum(T.(input_varname).^2,2));
        %T.accL1Norm = sum(T.(var_norm_name),2);
        
        T.Properties.VariableDescriptions(output_varname) = ...
            {'Euclidian norm of spatial components'};
        T.Properties.VariableContinuity(output_varname) = 'continuous';
        
    end
    