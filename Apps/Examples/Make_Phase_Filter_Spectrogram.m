%function make_spectrogram(T,varname)
% MAKE_SPECTROGRAM
% ...
%
% Usage
%   make_spectrogram(signal,varname)
%
% See also spectrogram, detrend

%    [fs,T] = get_sampling_rate(T);
%    if isnan(fs), return; end
T = S_parts{5};
varname = 'accA_norm';
fs = 500;
overlap_pst = 85;
clear PhaseMat
% Determine minimum 4th harmonic in Hz
min_speed = min(T.pumpSpeed)/60;
min_4th_harmonic = min_speed*4;

% Relate window length to the no. of recorded samples to "no. of 4th
% harmonic rotations"-ratio, and multiply by the number of statistics
% (i.e. 4th harmonic event we want to capture)
win_len = fs;
%win_len = 100*fs/min_4th_harmonic;

n_overlap_samp = min(ceil(overlap_pst/100*win_len),win_len-1); %n_overlap_samp = 80;%round(win_len/3);

% FFT resolution: Use the nearest number that can be written 2-exponential,
% which is optimal in the numerical FFT algorithm
n_fft = 2^nextpow2(2*fs);

%Remove a linear trend from a vector
%vec = detrend(signal.(varname));
vec = T.(varname);
%[s,f,t] = spectrogram(vec,win_len,n_overlap_samp,n_fft,fs);
win = hamming(1000);
s = stft(detrend(vec),'FFTLength',n_fft,'FrequencyRange','onesided',...
    'OverlapLength',150,'Window',win);
%view(-77,72)
%shading interp
%colorbar off


MaskedHarmAmpMat = abs(s);
AnalizedMat = angle(s);
AnalizedMat = mod(AnalizedMat,2*pi);
PhaseMat(:,2:(size(AnalizedMat,2))) = mod(AnalizedMat(:,2:size(AnalizedMat,2))-AnalizedMat(:,1:(size(AnalizedMat,2)-1)), 2*pi);
for j = 1 : (size(PhaseMat,2)-30)
    PhaseMatStd = std (PhaseMat(:,j:j+30),0,2);
    for i = 1 : size (PhaseMatStd,1)
        if (PhaseMatStd(i) < 1.1)
            PhaseMat(i,j) = 0 ;
        else
            PhaseMat (i,j) = 1 ;
        end
    end
end
PhaseMat(:,(size(PhaseMat,2)-3):size(PhaseMat,2)) = 0;
MaskedHarmAmpMat = MaskedHarmAmpMat.*PhaseMat;

% figure
% clims = [-80,35];
% imagesc(20*log10(abs(s)))
% set(gca,'YDir','normal')


figure
clims = [-40,20];
imagesc(20*log10(MaskedHarmAmpMat),clims)
set(gca,'YDir','normal')


