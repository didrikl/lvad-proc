function output_varname = check_output_var(signal, output_varname)
    
    if ismember(output_varname,signal.Properties.VariableNames)
        msg = sprintf('Variable %s already exist in signal',output_varname);
        response = ask_list_ui({'Overwrite','Skip','Abort'},msg);
        if response==2, output_varname = ''; end
        if response==3, abort; end
    end