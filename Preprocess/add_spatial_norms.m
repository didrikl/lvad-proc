function S_parts = add_spatial_norms(S_parts)
    % Function for IV2 model to add relevant variables
    % TODO: Make this an IV2 object method
    
    welcome('Calculating spatial norms')
    
    % Adding 2-norms
    fprintf('\t2-norm: Eucledian distance of accA_x, accA_y and accA_z\n')
    S_parts = add_in_parts(S_parts,{'accA_x','accA_y','accA_z'},'accA_norm', 2);
    fprintf('\t2-norm: Eucledian distance of accA_x and accA_z\n')
    S_parts = add_in_parts(S_parts,{'accA_x','accA_z'},'accA_xz_norm', 2);
    
    % Add also 1-norm (sum of each component's absolute values), for testing
    fprintf('\t1-norms: Sum of absolute values of accA_x and accA_z\n')
    S_parts = add_in_parts(S_parts,{'accA_x','accA_y','accA_z'},'accA_1norm', 1);
    fprintf('\t1-norms: Sum of absolute values of accA_x and accA_z\n')
    S_parts = add_in_parts(S_parts,{'accA_x','accA_z'},'accA_xz_1norm', 1);
    
    clear clear check_var_output_to_table
    clear clear check_var_input_to_table
    
    
function S_parts = add_in_parts(S_parts,inputVarNames, outputVarName, p)
    % NOTE: This function could e.g. be made generic or common in master class.
    % Function handle can then be passed as input
    
    for i=1:numel(S_parts)
        
        if height(S_parts{i})==0, continue; end
        
        S_parts{i} = calc_spatial_norm(S_parts{i},inputVarNames, outputVarName, p);     
        
        % Filter out the DC component (e.g. gravity and linear drift)
        %S_parts{i}.(outputVarName) = detrend(S_parts{i}.(outputVarName));
        
    end
   

