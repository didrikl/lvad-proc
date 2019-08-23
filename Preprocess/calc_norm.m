function signal = calc_norm(signal, input_varnames)
    
    if nargin < 2
        input_varnames = {'acc'};
    end 
    if not(iscell(input_varnames))
        input_varnames = {input_varnames};
    end
    
    for i=1:numel(input_varnames)

        input_varname = check_input_var(signal, input_varnames{i});
        if isempty(input_varname), continue; end
        
        output_varname = [input_varname,'Norm'];
        output_varname = check_output_var(signal, output_varname);
        if isempty(output_varname), continue; end
        
        signal.(output_varname) = sqrt(sum(signal.(input_varname).^2,2));
        %signal.accL1Norm = sum(signal.(var_norm_name),2);
        
        signal.Properties.VariableDescriptions(output_varname) = ...
            {'Euclidian length of spatial components'};
        signal.Properties.VariableContinuity(output_varname) = 'continuous';
        
    end