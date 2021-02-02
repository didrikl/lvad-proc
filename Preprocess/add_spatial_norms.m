function T_parts = add_spatial_norms(T_parts, p, compNames, newVarName)
    % Function for IV2 model to add relevant variables
    % TODO: Make this an model object method
    
    welcome('Calculating spatial norms')
    
    [returnAsCell,T_parts] = get_cell(T_parts);
    if isempty(T_parts)
        warning('Input data %s is empty',inputname(1))
        return
    end
    
    if nargin<2, p=2; end
    if nargin<3, compNames = {'accA_x','accA_y','accA_z'}; end
    if nargin<4
        if p==1, newVarName = 'accA_1norm';
        elseif p==2, newVarName = 'accA_norm';
        else, newVarName = sprintf('accA_%snorm',p);
        end
    end
        
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
    
    fnc = @calc_spatial_norm;   
    T_parts = add_in_parts(fnc,T_parts,compNames,newVarName,p);
    T_parts = convert_to_single(T_parts,newVarName);
    
    if not(returnAsCell), T_parts = T_parts{1}; end
    
    