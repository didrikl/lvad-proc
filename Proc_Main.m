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


%% Initilize raw signal files

cardiaccs_filename = fullfile('Surface','monitor-20181207-154327.txt');
powerlab_filename = fullfile('PowerLab','test.mat');
notes_filename = fullfile('Notes','IV_LVAD_CARDIACCS_1 - Notes - Rev 2.xlsx');

experiment_subdir = 'IV_LVAD_CARDIACCS_1';
[read_path, save_path] = init_paths(experiment_subdir);

signal = init_cardiaccs_raw_txtfile(cardiaccs_filename,read_path);
p_signal = init_powerlab_raw_matfile(powerlab_filename,read_path);
notes = init_notes_xlsfile(notes_filename,read_path);

save_table('signal.mat', save_path, signal, 'matlab');


%% Initialize saved signal file

signal = init_signal_file('signal.mat', save_path);


%% Pre-process signal
% * Resample signal
% * Add note columns that have given VariableContinuity properties
% * Clip to signal to notes range

signal = pre_process_signal(notes, signal);
signal_parts = split_into_experiment_parts(signal,notes);




%% Pre-process new variables
% Pre-calculate in batch new variables for the whole time range. 

% Vector length
signal.acc_length = rms(signal.acc,2); % same as acc_length = sqrt(mean(acc.^2,2))
    
% Moving RMS, variance and standard deviation for 3 comp. length
win_length = 1*signal.Properties.SampleRate;
signal.movrms = calc_moving(@dsp.MovingRMS, signal.acc_length, win_length);
signal.movvar = calc_moving(@dsp.MovingVariance, signal.acc_length, win_length);
signal.movstd = calc_moving(@dsp.MovingStandardDeviation, signal.acc_length, win_length);


%% Continuous wavelet transform



%% Estimate the spectrum using the short-time Fourier transform
% Divide the signal into sections of a given length
% Windowed with a Hamming window. 
% Specify 80 samples of overlap between adjoining sections
% Evaluate the spectrum at fs/2+1 frequencies.

window = 500;
n_overlap_samp = 80;
n_fft = fs/2; % "freq eval resolution"

spectrogram(signal.acc_length,window,n_overlap_samp,n_fft,fs,'yaxis');


%% Make RPM order map
% Compare the pre and post intervention baselines with Matlab's build-in 
% RPM order plots. Detrending is applied, so that the DC component is attenuated

make_rpm_order_map(signal)


%%
figure
hold on
%signal.t.Format = 'SS';
for i=1:numel(iv_injection_ranges)
    plot_data = signal(iv_injection_ranges{i},:);
    plot_time = plot_data.t - plot_data.t(2);
    h_plt = plot(plot_time,sum(plot_data.movrms,2));
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

parts.all = signal(not(isundefined(signal.experimentSubpart)),:);
parts.part1 = signal(signal.experimentPartNo=='1',:);
parts.part2 = signal(signal.experimentPartNo=='2',:);
parts.part3 = signal(signal.experimentPartNo=='3',:);

parts.pause = signal(signal.experimentSubpart=='Pause',:);
pause_start_ind = find(notes.experimentSubpart=='Pause');
pause_end_ind = pause_start_ind+1;
pause_interv = [notes.timestamp(pause_start_ind),notes.timestamp(pause_end_ind)];


