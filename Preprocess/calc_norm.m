function signal = calc_norm(signal, var_name)
    
    if nargin < 2
        var_name = 'acc';
    end
        
    signal.accNorm = sqrt(sum(signal.(var_name).^2,2));
    %signal.accL1Norm = sum(signal.(var_name),2);
    
    signal.Properties.VariableDescriptions('accNorm') = ...
        {'Eucledian distance of sensor components'};
    signal.Properties.VariableContinuity('accNorm') = 'continuous';
    