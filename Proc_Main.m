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


%% Initilize raw signal files and notes from disc

% User inputs
cardiaccs1_filename = fullfile('Cardiaccs','Surface','monitor-20181207-154327.txt');
cardiaccs2_filename = fullfile('Cardiaccs','Teguar','monitor-20181207-153752.txt');
notes_filename      = fullfile('Notes','In Vitro 1 - HVAD - THROMBI SPEED IV.xlsx');
powerlab_filename   = fullfile('PowerLab','test.mat');
M3_filename         = fullfile('M3','ECM_2019_06_28__15_58_28.wrf');

%experiment_subdir = fullfile('In Vitro 1 - HVAD - THROMBI SPEED IV');
experiment_subdir = fullfile('In Vitro - PREPERATIONS');
[read_path, save_path] = init_paths(experiment_subdir);

% Read text file and save the initialized as binary file
%acc_signal = init_cardiaccs_raw_txtfile(cardiaccs_filename,read_path);
%save_table('acc_signal.mat', save_path, signal, 'matlab');

% Read mat files
acc_signal = init_signal_proc_matfile('acc_signal.mat', save_path);
%acc_signal = init_signal_proc_matfile('acc_signal_preproc.mat', save_path);
%powerlab_signal = init_powerlab_raw_matfile(powerlab_filename,read_path);

% Read experiment notes in Excel file template
notes = init_notes_xlsfile(notes_filename,read_path);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
ultrasound_signal = init_m3_raw_textfile(M3_filename,read_path);


%% Pre-process signal
% * Resample signal
% * Add note columns that have given VariableContinuity properties
% * Clip to signal to notes range

acc_signal = resample_signal(acc_signal);

% Init notes, then signal and notes fusion (after resampling)
signal = merge_signal_and_notes(acc_signal,notes);
signal = clip_to_experiment(signal,notes);

% Vector length
signal.acc_length = sqrt(sum(signal.acc.^2,2));
    
% Moving RMS, variance and standard deviation for 3 comp. length
signal = calc_moving(signal);

% After new variable have been calculated, then split the prepared data
signal_parts = split_into_experiment_parts(signal,notes);
signal_parts.part2_iv = signal_parts.part2(signal_parts.part2.event~='Baseline',:);

features = extract_features_from_notes(notes);

%save_table('signal_preproc.mat', save_path, signal, 'matlab');

features = make_feature_windows(signal, features)


%% Continuous wavelet transform




%% Estimate the spectrum using the short-time Fourier transform

%make_spectrogram(signal_parts.part2_iv,'acc_length')


%% Make time domain plots

%make_time_plots(signal_parts.part2_iv,'acc_length')


%% Calc FFT
% Remove the static effect of gravity in the in vitro setup?
%   - no need for acc_length
%   - perhaps requiured when looking at a 2-D plane
% Adjust time to comparable intervention windows

%make_fft_plots(signal_parts.part2)


%% Make RPM order maps

% make_rpm_order_map(signal_parts.part1)
% make_rpm_order_map(signal_parts.part2)
% make_rpm_order_map(signal_parts.part3)

