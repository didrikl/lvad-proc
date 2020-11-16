function varNames = check_table_var_input(T, varNames)
    
    persistent always_skip
    if isempty(always_skip), always_skip = false; end
    
    if not(iscell(varNames))
        varNames = cellstr(varNames);
        output_as_cell = false;
    else
        output_as_cell = true;
    end
    
    for i=1:numel(varNames)

        if not(ismember(varNames{i},T.Properties.VariableNames))
            
            if i==1, fprintf('\n'); end
            fprintf('Variable %s does not exist\n',varNames{i});
            
            if always_skip
                warning(sprintf(['Always skipped',...
                    ' (Type "clear check_table_var_input" to reset)']));
                varNames{i} = '';
                continue
            end
            
            opts = {
                'Skip'
                'Skip, always'
                'Select another name for input variable'
                'Abort'
                };
            response = ask_list_ui(opts,'');
            
            if response==1
                varNames{i} = '';
                
            elseif response==2
                always_skip = true;
                varNames{i} = '';
                
            elseif response==3
                msg2 = sprintf('\n\tSelect which variable to use');
                response2 = ask_list_ui(T.Properties.VariableNames,msg2);
                varNames{i} = T.Properties.VariableNames{response2};
                
            elseif response==4
                abort;
                
            end
        end
        
    end
    
    if not(output_as_cell) 
        varNames = varNames{1}; 
    end