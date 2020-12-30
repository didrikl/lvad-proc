%     LC = 45;
%     HC = 349;
%     f_win = [LC , HC]/(700/2);
%     [b,a] = butter(4, f_win);
%     T.accA_norm = double(T.accA_norm);
%     T.accA_norm = single( filtfilt( b, a, T.accA_norm ) );