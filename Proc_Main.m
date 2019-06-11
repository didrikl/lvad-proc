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
cardiaccs_filename = fullfile('Surface','monitor-20181207-154327.txt');
powerlab_filename = fullfile('PowerLab','test.mat');
notes_filename = fullfile('Notes','IV_LVAD_CARDIACCS_1 - Notes - Rev 2.xlsx');
experiment_subdir = 'IV_LVAD_CARDIACCS_1';
[read_path, save_path] = init_paths(experiment_subdir);

% Read text file and save the initialized as binary file
%signal = init_cardiaccs_raw_txtfile(cardiaccs_filename,read_path);
%save_table('signal.mat', save_path, signal, 'matlab');

% Read mat files
signal = init_signal_file('signal.mat', save_path);
%signal = init_signal_file('signal_preproc.mat', save_path);
%p_signal = init_powerlab_raw_matfile(powerlab_filename,read_path);

% Read notes from Excel file and 
notes = init_notes_xlsfile(notes_filename,read_path);



%% Pre-process signal
% * Resample signal
% * Add note columns that have given VariableContinuity properties
% * Clip to signal to notes range

signal = resample_signal(signal);

% Init notes, then signal and notes fusion (after resampling)
signal = merge_signal_and_notes(signal,notes);
signal = clip_to_experiment(signal,notes);

% Vector length
signal.acc_length = sqrt(sum(signal.acc.^2,2));
    
% Moving RMS, variance and standard deviation for 3 comp. length
signal = calc_moving(signal);

% After new variable have been calculated, then split the prepared data
signal_parts = split_into_experiment_parts(signal,notes);
signal_parts.part2_iv = signal_parts.part2(signal_parts.part2.event~='Baseline',:);

features = extract_features_from_notes(notes);

save_table('signal_preproc.mat', save_path, signal, 'matlab');


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

make_fft_plots(signal_parts.part2)


%% Make RPM order maps

make_rpm_order_map(signal_parts.part1)
make_rpm_order_map(signal_parts.part2)
make_rpm_order_map(signal_parts.part3)

