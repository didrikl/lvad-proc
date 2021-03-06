function [ampl, phase] = make_fft_plots(signal, varname, rpm)

% (to speed up/more accuracy: mean(acc_vec(1:1000)), i.e. for a initial window only)
s = signal.(varname);
%t = signal.time;

%s = detrend(s);

Fs = signal.Properties.SampleRate;
Fs = 500;

L = numel(s);                                   % Signal Length
Fn = Fs/2;                                      % Nyquist Frequency
FTvr = fft(s)/L;                                % Fourier Transform
freq = linspace(0, 1, fix(L/2)+1)*Fn;           % Frequency Vector
Iv = 1:length(freq);                            % Index Vector

ampl = abs(FTvr(Iv))*2;
phase = angle(FTvr(Iv));

plot(freq, ampl);
title('Frequency amplitude plot')

% Add harmonics lines
harmonics = (1:4)*(rpm/60);
for i=1:numel(harmonics)
    xline(gca,harmonics(i),':',...
        'Color',[0.9290 0.740 0.1250],...
        'LineWidth',1.5,...
        'FontWeight','bold',...
        'LabelHorizontalAlignment','left',...
        'LabelVerticalAlignment','middle',...
        'Label',['harmonic ',num2str(i)]);
end

ylim([0 prctile(ampl,99.9)])
xlim([1 200])
grid off

        

%figure
%plot(freq, phase)
%title('Phase plot')
%plot(freq,movvar(angle(FTvr(Iv)),32))
    
