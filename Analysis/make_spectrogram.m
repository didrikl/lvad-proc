function make_spectrogram(signal,varname) 
    % MAKE_SPECTROGRAM
    % ...
    %
    % Usage
    %   make_spectrogram(signal,varname)
    %
    % See also spectrogram, detrend

    fs = signal.Properties.SampleRate;
    overlap_pst = 80;
    
    % Determine minimum 4th harmonic in Hz 
    min_speed = min(str2double(categories(signal.pumpSpeed)))/60;
    min_4th_harmonic = min_speed*4;
    
    % Relate window length to the no. of recorded samples to "no. of 4th 
    % harmonic rotations"-ratio, and multiply by the number of statistics 
    % (i.e. 4th harmonic event we want to capture)
    win_len = 100*fs/min_4th_harmonic;
    
    n_overlap_samp = min(ceil(overlap_pst/100*win_len),win_len-1); %n_overlap_samp = 80;%round(win_len/3);
    
    % FFT resolution: Use the nearest number that can be written 2-exponential,
    % which is optimal in the numerical FFT algorithm 
    n_fft = 2^nextpow2(fs/2); 

    %Remove a linear trend from a vector
    vec = detrend(signal.(varname));
    spectrogram(vec,win_len,n_overlap_samp,n_fft,fs,'yaxis','onesided');

    caxis([-80,-5]);
    %view(-77,72)
    %shading interp
    %colorbar off
    
    
    %%
    
%% Calc acceleration with removed average values
% Remove the static effect of gravity in the in vitro setup

% (to speed up/more accuracy: mean(acc_vec(1:1000)), i.e. for a initial window only)
vec = signal.accNorm;
vec_ = vec-movmean(vec,10000);
plot(signal.time,vec)



%% Calc FFT (for intervention windows)

vec = data_range.acc_xyzrms;
%acc = d.acc(:,1);
%acc = d.acc(:,2);
vec = data_range.acc(:,3);
%hold on

L = numel(vec);                                   % Signal Length
Fn = Fs/2;                                                    % Nyquist Frequency
FTvr = fft(vec)/L;                                % Fourier Transform
freq = linspace(0, 1, fix(L/2)+1)*Fn;                         % Frequency Vector
Iv = 1:length(freq);                                          % Index Vector

ampl = abs(FTvr(Iv))*2;
phase = angle(FTvr(Iv));

figure;
plot(freq, ampl)
title('Amplitude plot')

ylim([0 0.05])
xlim([0 200])
rpm = 2600;
harmonics = [1:4]*(rpm/60);

for i=1:numel(harmonics)
    xline(gca,harmonics(i),':',...
        'Color',[0.9290 0.6940 0.1250],...
        'LineWidth',2,...
        'FontWeight','bold',...
        'LabelHorizontalAlignment','left',...
        'LabelVerticalAlignment','middle',...
        'Label',['harmonic ',num2str(i)]);
end

grid off

        

%figure
%plot(freq, phase)
%title('Phase plot')
%plot(freq,movvar(angle(FTvr(Iv)),32))
    
    
    
    