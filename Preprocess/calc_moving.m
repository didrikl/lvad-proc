function signal = calc_moving(signal, statistic_types, var_name)
    % CALC_MOVING
    %   
    %
    % See also dsp
    %

    if nargin < 2
        statistic_types = {'rms','var','std'};
    end
    
    if nargin < 3
        var_name = 'acc_length';
    end
    
    signal_vec = signal.(var_name);
    win_length = 1*signal.Properties.SampleRate;
    
    if ismember('rms',statistic_types)
        MovRMSObj = dsp.MovingRMS(win_length);
        signal.movrms = MovRMSObj(signal_vec);
        signal.movrms(1:win_length) = nan;
        
    end
    
    if ismember('var',statistic_types)
        MovVarObj = dsp.MovingVariance(win_length);
        signal.movvar = MovVarObj(signal_vec);
        signal.movvar(1:win_length) = nan;
    end
    
    if ismember('std',statistic_types)
        MovSTDObj = dsp.MovingStandardDeviation(win_length);
        signal.movstd = MovSTDObj(signal_vec);
        signal.movstd(1:win_length) = nan;
    end
    
    signal.Properties.VariableContinuity{statistic_types} = true;
    