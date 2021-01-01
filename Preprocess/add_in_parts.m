function T_parts = add_in_parts(fnc,T_parts,inputVarNames,outputVarNames,varargin)
    % NOTE: This function could e.g. be made generic or common in master class.
    % Function handle can then be passed as input
    for i=1:numel(T_parts)
        
        welcome(sprintf('Part %d',i),'iteration')
        %fprintf('\n<strong>Part %d</strong> \n',i)
        if height(T_parts{i})==0
            warning('Empty part')
            continue; 
        end
       
        inputVarNamesChecked = check_table_var_input(T_parts{i}, inputVarNames);
        if any(cellfun(@isempty,inputVarNamesChecked))
            fprintf('\n')
            warning(sprintf('%s is not added in part %d',outputVarName,i))
            continue;
        end
        outputVarNamesChecked = check_table_var_output(T_parts{i}, outputVarNames);
        if isempty(outputVarNamesChecked)
            fprintf('\n')
            warning(sprintf('%s is not added in part %d',outputVarName,i))
            continue
        end
        
        T_parts{i} = fnc(...
            T_parts{i},inputVarNamesChecked,outputVarNamesChecked,varargin{:});
        
    end

    clear check_table_var_output check_table_var_input