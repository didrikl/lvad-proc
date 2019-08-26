function signal = calc_norm(signal, input_varnames)
    
    if nargin<2
        is_meassured = signal.Properties.CustomProperties.MeassuredSignal;
        input_varnames = signal.Properties.VariableNames(is_meassured);
    end
    
    if not(iscell(input_varnames))
        input_varnames = {input_varnames};
    end
    
    new_var_suffix = 'Norm';
    
    fprintf('\nCalculating Euclidian Norm:\n\n\tTable: %s',inputname(1))
    
    for i=1:numel(input_varnames)
        
        [input_varname,output_varname] = ...
            check_calc_io(signal,input_varnames{i},new_var_suffix);
        if isempty(output_varname), continue; end
                
        signal.(output_varname) = sqrt(sum(signal.(input_varname).^2,2));
        %signal.accL1Norm = sum(signal.(var_norm_name),2);
        
        signal.Properties.VariableDescriptions(output_varname) = ...
            {'Euclidian length of spatial components'};
        signal.Properties.VariableContinuity(output_varname) = 'continuous';
        
    end
    