%% Initialze the processing environment and code

% Add all subfolders to path. To be removed as it gives less control compared to importing packages
addpath(genpath('.')) 

% Use code in packages with subfolders prefixed with a '+'
% import Initialize.*
% import Calculate.*
% import Analyze.*
% import Tools.*

% Settings for Matlab 
init_matlab


%% Initilize signal

cardiaccs_file = fullfile('Surface','monitor-20181207-154327.txt');
powerlab_file = fullfile('PowerLab','test.mat');
notes_file = fullfile('Notes','IV_LVAD_CARDIACCS_1 - Notes - Rev 2.xlsx');
experiment_subdir = 'IV_LVAD_CARDIACCS_1';
[read_path, save_path] = init_paths(experiment_subdir);

signal = init_cardiaccs_raw_txtfile(cardiaccs_file,read_path);
p_signal = init_powerlab_raw_matfile(powerlab_file,read_path);
notes = init_notes_xlsfile(notes_file,read_path);


%% Pre-process signal
% * Resample signal
% * Initialize notes
% * Clip to signal to notes range

signal = resample_signal(signal);

% Init notes, then signal and notes fusion (after resampling)
data = merge_signal_and_notes(signal,notes);
data = clip_to_experiment(data, notes, fs);


%% Pre-process new variables
% Pre-calculate in batch new variables for the whole time range. 

% Vector length
data.acc_length = rms(data.acc,2); % same as acc_length = sqrt(mean(acc.^2,2))
    
% Moving RMS, variance and standard deviation for 3 comp. length
win_length = 1*data.Properties.SampleRate;
data.movrms = calc_moving(@dsp.MovingRMS, data.acc_length, win_length);
data.movvar = calc_moving(@dsp.MovingVariance, data.acc_length, win_length);
data.movstd = calc_moving(@dsp.MovingStandardDeviation, data.acc_length, win_length);



%% Continuous wavelet transform
%% Estimate the spectrum using the short-time Fourier transform
% Divide the signal into sections of a given length
% Windowed with a Hamming window. 
% Specify 80 samples of overlap between adjoining sections
% Evaluate the spectrum at fs/2+1 frequencies.

window = 500;
n_overlap_samp = 80;
n_fft = fs/2; % "freq eval resolution"

spectrogram(data.acc_length,window,n_overlap_samp,n_fft,fs,'yaxis');


%% Make RPM order map
% Compare the pre and post intervention baselines with Matlab's build-in 
% RPM order plots. Detrending is applied, so that the DC component is attenuated

make_rpm_order_map(data)



%%
figure
hold on
data.t.Format = 'SS';
for i=1:numel(iv_injection_ranges)
    plot_data = data(iv_injection_ranges{i},:);
    plot_time = plot_data.t - plot_data.t(2);
    h_plt = plot(plot_time,sum(plot_data.mov520rms,2));
    %h_plt.Color(4) = 0.2;
end

h_ax = gca;
h_ax.YLim(1) = 0;

hold off
h_leg = legend(string(notes.thrombusVolume(notes.event=='Thrombus injection')));
get(h_leg)


%% Clip data into parts


% Remove non-experiement recording (NB: clipping after calculations is okay, but
% clipped parts prior to calculations must be kept separate in the calculations)
%data_clip = clip_signal_with_notes(data);
%data_clip = data(ismember(data.experimentPartNo,{'1','2','3'}),:);
parts.all = data(not(isundefined(data.experimentSubpart)),:);
parts.part1 = data(data.experimentPartNo=='1',:);
parts.part2 = data(data.experimentPartNo=='2',:);
parts.part3 = data(data.experimentPartNo=='3',:);

parts.pause = data(data.experimentSubpart=='Pause',:);
pause_start_ind = find(notes.experimentSubpart=='Pause');
pause_end_ind = pause_start_ind+1;
pause_interv = [notes.timestamp(pause_start_ind),notes.timestamp(pause_end_ind)];


%% plot  type 1
close all
h_ax(1) = subplot(4,1,1);
hold on
for i=1:3
    data_part = parts.(['part',num2str(i)]);
    yyaxis left
    plot(data_part.timestamp, data_part.movrms_sum)
    yyaxis right
    plot(data_part.timestamp, data_part.movstd_sum)
    h_ax(1).ColorOrderIndex = 1;
end
data_part = parts.pause;
yyaxis left
h_p1 = plot(data_part.timestamp, data_part.movrms_sum,'.');
yyaxis right
h_p2 = plot(data_part.timestamp, data_part.movstd_sum,'.');
hold off

h_ax(2) = subplot(4,1,2);
yyaxis left
plot(data_clip.timestamp, data_clip.pumpSpeed,'clipping','on')
yyaxis right
plot(data_clip.timestamp, data_clip.thrombusVolume,'clipping','on')
% 
% h_ax(3) = subplot(4,1,3);
% scatter(notes.timestamp, notes.efferentPressure, 'filled')
% hold on 
% scatter(notes.timestamp, notes.afferentPressure, 'filled')
% hold off
% h_ax(3).YLim = [min(h_ax(3).YLim(1),-5),h_ax(3).YLim(2)*1.15];
% legend({'Afferent','Efferent','Flow'})
% 
% h_ax(4) = subplot(4,1,4);
% yyaxis left
% plot(parts.timestamp, parts.event_intervention,'.','MarkerSize',15)
% yyaxis right
% plot(parts.timestamp, parts.experimentSubpart,'.','MarkerSize',15)
% h_ax(2) = subplot(4,1,2);
% 
% linkaxes(h_ax,'x')
% h_ax(1).XLim = [parts.timestamp(1),parts.timestamp(end)];
% 

