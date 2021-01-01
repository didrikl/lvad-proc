function T = calc_spatial_norm(T,varNames,norm_varName,p)
    % Add spatial norms for recorded data in a timetable
    
    % To be skipped, if empty output var name (e.g. in case existing
    % varabible in timetable shall not be overwritten)
    if isempty(norm_varName), return; end
    
    % Default is, unless p is specified, the Eucledian distance norm (i.e. L2-norm)
    if nargin<4, p=2; end
    
    if p==2
        T{:,norm_varName} = sqrt(sum(T{:,varNames}.^2,2));
    elseif p==1
        T{:,norm_varName} = sum(abs(T{:,varNames}),2);
    else
        try
            T{:,norm_varName} = norm(T{:,varNames},p);
        catch
            error('Norm type not supported')
        end
    end
    
    T.Properties.VariableContinuity(norm_varName) = 'continuous';
    T.Properties.VariableDescriptions{norm_varName} = ...
            [num2str(p),'-norm of ',strjoin(varNames,', ')];
    