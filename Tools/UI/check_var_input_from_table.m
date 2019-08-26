function var_name = check_var_input_from_table(signal, var_name)
    
    if not(ismember(var_name,signal.Properties.VariableNames))
        msg = sprintf('Variable %s does not exist in signal',var_name);
        response = ask_list_ui({'Use another variable','Skip','Abort'},msg);
        if response==1
            msg2 = 'Select which variable to use';
            response2 = ask_list_ui(signal.Properties.VariableNames,msg2);
            var_name = signal.Properties.VariableNames{response2};
        elseif response==2
            var_name = '';
        elseif response==3
            abort;
        end
    end