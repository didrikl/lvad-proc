function signal = calc_moving(signal)
    % CALC_MOVING
    %   
    %
    % See also dsp
    %

    var = 'acc_length';
    signal_vec = signal.(var);
    win_length = 1*signal.Properties.SampleRate;
    
    
    MovRMSObj = dsp.MovingRMS(win_length);   
    signal.movrms = MovRMSObj(signal_vec);
    signal.movrms(1:win_length) = nan;

    MovVarObj = dsp.MovingVariance(win_length);   
    signal.movvar = MovVarObj(signal_vec);
    signal.movvar(1:win_length) = nan;

    MovSTDObj = dsp.MovingStandardDeviation(win_length);   
    signal.movstd = MovSTDObj(signal_vec);
    signal.movstd(1:win_length) = nan;
    