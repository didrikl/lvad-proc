function [input_name,output_name] = check_calc_io(signal,input_name,suffix)
    
    fprintf('\n\tInput variable: %s',input_name)
    input_name = check_var_input_from_table(signal, input_name);
    if isempty(input_name)
        output_name = '';
        fprintf('\n\tCalculation not done\n')
        return
    end
    
    output_name = [input_name,suffix];
    fprintf('\n\tOutput variable: %s\n',output_name)
    output_name = check_var_output_to_table(signal, output_name);
    if isempty(output_name)
        fprintf('\n\tCalculation not done\n')
    end
    