%% Sound analysis

part = 12;
baseline = 1;
varName = 'accA_norm';
dur_sec = 12;
speedUp = 4;

P = S_parts{part};
B = S_parts{baseline};
B = B(get_steady_state_rows(B) & B.pumpSpeed=='3200',:);

fs = get_sampling_rate(P);
notches = (2600/60)*[1,4];
n_levels = 5;

B.(varName) = detrend(B.(varName));
P.(varName) = detrend(P.(varName));
%B.(varName) = highpass(B.(varName),0.20*notches(1)+2,fs);
%P.(varName) = highpass(P.(varName),0.20*notches(1)+2,fs);
% B.(varName) = lowpass(B.(varName),540/2,fs);
% P.(varName) = lowpass(P.(varName),540/2,fs);
% P = filter_notches(P,varName,notches,1);
% B = filter_notches(B,varName,notches,1);
% varName = [varName,'_hFilt'];

s = cell(1,n_levels+1);
s{1} = B.(varName);
for i=1:5   
    s{i+1} = P.(varName)(P.balloonLevel==num2str(i));
end

% Amplifying and clipping in time
n_samps = dur_sec*fs;
for i=1:numel(s)
    i-1
    s{i} = 2*(s{i}(1:n_samps));       
    sound(s{i},speedUp*540)
    pause(dur_sec/speedUp+0.1) 
end

