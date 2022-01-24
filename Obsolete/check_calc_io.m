function [input_name,output_name] = check_calc_io(signal,input_name,suffix)
    
    input_name = check_table_var_input(signal, input_name);
    if isempty(input_name)
        fprintf('\n\tInput variable: %s',input_name)
        fprintf('\n\tCalculation not done.\n')
        output_name = '';
        return
    end
    
    output_name = [input_name,suffix];
    output_name = check_table_var_output(signal, output_name);
    if isempty(output_name)
        fprintf('\n\tOutput variable: %s',output_name)
        fprintf('\n\tCalculation not done.\n')
    end
    
    