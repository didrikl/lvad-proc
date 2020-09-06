
%% Spectrogram

part = 8;

%suptitle('Part 8 - Angio catheter - 2600 RPM')
h_spectrogram = figure(...
    'WindowState','maximized',...
    'name',['Spectrogram - Part', num2str(part)]);

make_spectrogram(S_parts{part},'accA_norm')

%print(h_spectrogram,'-dpng','-r600','-opengl',fig_filePath)

%% Frequency analysis: 

% Make average order spectrogram and extract relevant features
Average_Order_Spectrum_For_Intervention_Segments

part = 8;
rpm = 2600;
S_part = S_parts{part};
S_part = S_part(S_part.pumpSpeed=='2600',:);

h_fft = figure(...
    'units','normalized',...
    'outerposition',[0 0 1 1],...
    'Name',['Frequency amplitudes - Part', num2str(part)]);
h_sub(1) = subplot(3,1,1);
make_fft_plots(S_part(S_part.balloonLevel=='1',:),'accA_norm',rpm);
title('Level 1')
h_sub(2) = subplot(3,1,2);
make_fft_plots(S_part(S_part.balloonLevel=='2',:),'accA_norm',rpm);
title('Level 2')
h_sub(3) = subplot(3,1,3);
make_fft_plots(S_part(S_part.balloonLevel=='3',:),'accA_norm',rpm);
title('Level 3')
% h_sub(4) = subplot(3,2,4);
% make_fft_plots(S_part(S_part.balloonLevel=='3',:),'accA_norm',rpm);
% title('Level 3')
% h_sub(5) = subplot(3,2,5);
% make_fft_plots(S_part(S_part.balloonLevel=='4',:),'accA_norm',rpm);
% title('Level 4')
% h_sub(6) = subplot(3,2,6);
% make_fft_plots(S_part(S_part.balloonLevel=='5',:),'accA_norm',rpm);
% title('Level 5')

set(h_sub,'Ylim',[0,0.0006])

fig_filePath = fullfile(proc_basePath,['Frequency amplitudes - Part ',num2str(part)]);
print(h_fft,'-dpng','-r600','-opengl',fig_filePath)