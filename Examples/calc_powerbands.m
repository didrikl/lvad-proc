

%% Calc MPF

N = size(freq,2);
pow_x = cell(1,N);
pow_y = cell(1,N);

% % loop over time window(s)
% for i=1:N
%     [pow_x{i}, pow_y{i}] = calc_powbands(freq{i}, ampl{i}, b_width);
% end


function [pow_x, pow_y] = calc_powbands(freq, ampl, b_width)
    % Make a continious band power "distribution", which can be used as a 
    % quentitative a meassure for quality control.
    % The amplitue power is integrated in separate frequency bands, and
    % normalized by a given band width. The individual band widths are given 
    % by f_step.
    f_step = freq(2)-freq(1);
    ind1 = 1;
    ind_step = round(b_width/double(f_step));
    ind2 = ind1+ind_step-1;
    L = length(freq);
    pow_x = nan(floor(L/ind_step),1);
    pow_y = nan(floor(L/ind_step),1);
    k = 1;
    f_range = [freq(1), freq(1)+b_width];
    for i=1:ind_step:L
        pow_val = bandpower(ampl, freq, f_range, 'psd')/(f_range(2)-f_range(1));              
        pow_x(k:k+1) = [f_range(1),f_range(2)];
        pow_y(k:k+1) = [pow_val,pow_val];
        k = k+2;
        
        ind1 = ind2;
        ind2 = ind2+ind_step-1;
        if ind2>L
            ind2=L;
            f_range = [f_range(1)+b_width, freq(end)];
        else
            f_range = f_range+b_width;
        end
    end
end    


