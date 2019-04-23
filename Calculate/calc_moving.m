function movvar = calc_moving(mov_fun, signal_vec, win_length)
    % Calc moving variance along the time
    
%     if nargin==1
%         win_length = 125;
%     end
    
    % Requirement check for resampling to equal time steps?!
    
    MovObj = mov_fun(win_length);   
    
    % Error is not a moving calculation object was initialized by the provided
    % function
    assert(isa(MovObj,'dsp.private.AbstractMovingStatistic'))
    
    movvar = MovObj(signal_vec);
    movvar(1:win_length) = nan;
       