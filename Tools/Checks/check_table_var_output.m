function varNames = check_table_var_output(signal, varNames)
    
    persistent always_overwrite
    if isempty(always_overwrite), always_overwrite = false; end
    persistent always_keep
    if isempty(always_keep), always_keep = false; end
    
    [returnAsCell,varNames] = get_cell(varNames);
    
    for i=1:numel(varNames)
        if ismember(varNames{i},signal.Properties.VariableNames)
            
            msg = sprintf('\nOutput variable %s already exist\n',varNames{i});
            fprintf(msg);
            
            if always_overwrite
                warning(sprintf(['Always overwrite existing',...
                    ' (Type "clear check_table_var_input" to reset)']));
                return
            end
            if always_keep
                varNames{i} = '';
                warning(sprintf(['Always keep existing',...
                    ' (Type "clear check_table_var_input" to reset)']));
                return
            end
            
            opts = {
                'Keep'
                'Keep, always'
                'Overwrite'
                'Overwrite, always'
                'Abort'
                };
            response = ask_list_ui(opts,msg);
            
            if response==1
                varNames{i} = '';
                
            elseif response==2
                always_keep = true;
                varNames{i} = '';
                
            elseif response==3
                
            elseif response==4
                always_overwrite = true;
                
            elseif response==5
                abort;
            end
            
        end
    end
    
    if not(returnAsCell), varNames = varNames{1}; end
