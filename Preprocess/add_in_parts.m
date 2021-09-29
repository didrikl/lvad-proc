function T_parts = add_in_parts(fnc,T_parts,inputVarNames,outputVarNames,varargin)
    % Checks calculation input and output variable name existence in timetable,
    % with formatted info displayed in the commnand window. 
    %
    % In case input does not exist, relevant options are given to user,
    % according to the function check_table_var_input.
    %
    % In case output already exist, relevant options are given to user according
    % to the function check_table_var_output.
    %
    % User selected option may be persistent for all parts, and options are
    % reset once all the parts are processed.
    %
    % See also check_table_var_input, check_table_var_output
    
    % NOTE: This function could e.g. be made generic or common in master class.
    % Function handle can then be passed as input
    
    [returnAsCellOutput,outputVarNames] = get_cell(outputVarNames);
    [returnAsCellInput,inputVarNames] = get_cell(inputVarNames);
    
    for i=1:numel(T_parts)
        
%         if numel(T_parts)>1
%             welcome(sprintf('Part %d',i),'iteration')
%         end
        
        if height(T_parts{i})==0
            fprintf(newline)
            welcome(sprintf('Part %d',i),'iteration')
            warning('Empty part')
            continue; 
        end
       
        inputVarNamesChecked = check_table_var_input(T_parts{i}, inputVarNames);
        if any(cellfun(@isempty,inputVarNamesChecked))
            fprintf('\n')
            warning(sprintf('%s is not added in part %d',...
                strjoin(outputVarNames,', '),i))
            continue;
        end
        
        outputVarNamesChecked = check_table_var_output(T_parts{i}, outputVarNames);
        isNoOutput = cellfun(@isempty,inputVarNamesChecked);
        if all(isNoOutput)
            fprintf('\n')
            warning(sprintf('%s is not added in part %d',...
                strjoin(outputVarNames,', '),i))
            continue
        elseif any(isNoOutput)
            fprintf('\n')
            warning(sprintf('%s is not added in part %d',...
                strjoin(outputVarNames(outputVarNames),', '),i))
        end
        
        if not(returnAsCellOutput), outputVarNamesChecked = outputVarNamesChecked{1}; end
        if not(returnAsCellInput), inputVarNamesChecked = inputVarNamesChecked{1}; end
        T_parts{i} = fnc(...
            T_parts{i},inputVarNamesChecked,outputVarNamesChecked,varargin{:});
        
    end
    clear check_table_var_output check_table_var_input

    %dbs = dbstack;
    %fprintf('\n%s done.\n',dbs(end).name);
    fprintf('\nDone.\n'); 
    
    