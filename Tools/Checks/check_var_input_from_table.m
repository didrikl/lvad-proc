function varName = check_var_input_from_table(signal, varName)
    
    persistent always_skip
    if isempty(always_skip), always_skip = false; end
    
    if not(ismember(varName,signal.Properties.VariableNames))
        
        msg = sprintf('\n\tVariable: %s does not exist',varName);
        
        if always_skip
            fprintf('\n\tMissing variable is always skipped');
            fprintf('\n\t(type "clear check_var_input_from_table" to reset)\n')
            varName = '';
            return
        end
        
        opts = {
            'Skip'
            'Skip, always'
            'Select another name for input variable'
            'Abort'
            };
        response = ask_list_ui(opts,msg);
        
        if response==1
            varName = '';
        
        elseif response==2
            always_skip = true;
            varName = '';
            
        elseif response==3
            msg2 = sprintf('\n\tSelect which variable to use');
            response2 = ask_list_ui(signal.Properties.VariableNames,msg2);
            varName = signal.Properties.VariableNames{response2};
        
        elseif response==4
            abort;
        
        end
        
    end