function signal = calc_moving(signal, statistic_types, var)
    % CALC_MOVING
    %   
    %
    % See also dsp
    %

    if nargin < 2
        statistic_types = {'RMS','Var','Std'};
    end
    
    if nargin < 3
        var = 'accNorm';
    end
    
    win_length_fs_factor = 1;
    
    signal_vec = signal.(var);
    win_length = win_length_fs_factor*signal.Properties.SampleRate;
    new_vars = "mov"+statistic_types+"_"+var;
    
    if any(strcmpi('RMS',statistic_types))
        new_var = new_vars{strcmpi(statistic_types,'RMS')};
        MovRMSObj = dsp.MovingRMS(win_length);
        signal.(new_var) = MovRMSObj(signal_vec);
        signal.(new_var)(1:win_length) = nan;
        signal.Properties.VariableContinuity(new_var) = 'continuous';
        signal.Properties.VariableDescriptions(new_var) = {sprintf(...
            'Moving root-mean-sqaure\n\tWindow length: %s',win_length)};
    end
    
    if any(strcmpi('Var',statistic_types))
        new_var = new_vars{strcmpi(statistic_types,'Var')};
        MovVarObj = dsp.MovingVariance(win_length);
        signal.(new_var) = MovVarObj(signal_vec);
        signal.(new_var)(1:win_length) = nan;
        signal.Properties.VariableContinuity(new_var) = 'continuous';
        signal.Properties.VariableDescriptions(new_var) = {sprintf(...
            'Moving variance\n\tWindow length: %s',win_length)};    
    end
    
    if any(strcmpi('Std',statistic_types))
        new_var = new_vars{strcmpi(statistic_types,'Std')};
        MovSTDObj = dsp.MovingStandardDeviation(win_length);
        signal.(new_var) = MovSTDObj(signal_vec);
        signal.(new_var)(1:win_length) = nan;
        signal.Properties.VariableContinuity(new_var) = 'continuous';
        signal.Properties.VariableDescriptions(new_var) = {sprintf(...
            'Moving standard deviation\n\tWindow length: %s',win_length)};    
    end