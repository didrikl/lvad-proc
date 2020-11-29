function varName = check_table_var_output(signal, varName)
    
    persistent always_overwrite
    if isempty(always_overwrite), always_overwrite = false; end
    persistent always_keep
    if isempty(always_keep), always_keep = false; end
    
    if ismember(varName,signal.Properties.VariableNames)
        
        msg = sprintf('\nOutput variable %s already exist\n',varName);
        fprintf(msg);
        
        if always_overwrite
            warning(sprintf(['Always overwrite existing',...
                    ' (Type "clear check_table_var_input" to reset)']));
            return
        end
        if always_keep
            varName = '';
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
             varName = '';
             
        elseif response==2
            always_keep = true;
            varName = '';
            
        elseif response==3
            
        elseif response==4
            always_overwrite = true;
            
        elseif response==5
            abort; 
        end
    
    end