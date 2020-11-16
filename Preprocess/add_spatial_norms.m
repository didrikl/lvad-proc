function T_parts = add_spatial_norms(T_parts, p, compNames, newVarName)
    % Function for IV2 model to add relevant variables
    % TODO: Make this an IV2 object method
    
    welcome('Calculating spatial norms')
    
    if nargin<2, p=2; end
    if nargin<3, compNames = {'accA_x','accA_y','accA_z'}; end
    if nargin<4
        if p==1, newVarName = 'accA_1norm';
        elseif p==2, newVarName = 'accA_norm';
        else, newVarName = sprintf('accA_%snorm',p);
        end
    end
    
    if not(iscell(T_parts)), T_parts = {T_parts}; end
        
    if p==2
        % 2-norms (eucledian distance, L2-norm)
        fprintf('Calculations\n\t2-norms (Eucledian distance)')
    elseif p==1
        % 1-norms (sum of each component's absolute values):
        fprintf('Calculations\n\t1-norms (sum of absolute values)')    
    else
        % 1-norms (sum of each component's absolute values):
        fprintf('Calculations\n\tp-norms (using Matlab norm function)')
    end
    fprintf('\nInput\n\t%s\nOutput\n\t%s\n',strjoin(compNames,', '),newVarName);
    
    T_parts = add_in_parts(T_parts,compNames,newVarName,p);
    T_parts = convert_to_single(T_parts,newVarName);
    
    clear check_table_var_output check_table_var_input
    
    
function T_parts = add_in_parts(T_parts,inputVarNames, outputVarName, p)
    % NOTE: This function could e.g. be made generic or common in master class.
    % Function handle can then be passed as input
    for i=1:numel(T_parts)
        
        if height(T_parts{i})==0, continue; end
        
        inputVarNames = check_table_var_input(T_parts{i}, inputVarNames);
        if any(cellfun(@isempty,inputVarNames))
            fprintf('%s is not added in part %d\n',outputVarName,i)
            continue;
        end
        outputVarName = check_table_var_output(T_parts{i}, outputVarName);
        if isempty(outputVarName), continue; end
        
        T_parts{i} = calc_spatial_norm(T_parts{i},inputVarNames, outputVarName, p);
        
    end
