%% Initialze the processing environment and code

% Add all subfolders to path. To be removed as it gives less control compared to importing packages

% Use code in packages with subfolders prefixed with a '+'
% import Initialize.*
% import Calculate.*
% import Analyze.*
% import Tools.*

% Settings for Matlab 
init_matlab


%% Initilize raw signal files and notes from disc

% User inputs
lvad_signal_filename   = fullfile('Cardiaccs','Surface','monitor-20181207-154327.txt');
lead_signal_filename   = fullfile('Cardiaccs','Teguar','monitor-20181207-153752.txt');
notes_filename      = fullfile('Notes','In Vitro 1 - HVAD - THROMBI SPEED IV.xlsx');
powerlab_filename   = fullfile('PowerLab','test.mat');
ultrasound_filename = fullfile('M3','ECM_2019_06_28__15_58_28.wrf');

%experiment_subdir = fullfile('In Vitro 1 - HVAD - THROMBI SPEED IV');
experiment_subdir = fullfile('In Vitro - PREPERATIONS');
[read_path, save_path] = init_paths(experiment_subdir);

% Initialization of Cardiaccs text files (incl. saving to binary .mat file)
%lvad_signal = init_cardiaccs_raw_txtfile(lvad_signal_filename,read_path);
%lead_signal = init_cardiaccs_raw_txtfile(lead_signal_filename,read_path);
%save_table('lvad_signal.mat', save_path, lvad_signal, 'matlab');
%save_table('lead_signal.mat', save_path, lead_signal, 'matlab');
lvad_signal = init_signal_proc_matfile('lvad_signal.mat', save_path);
lead_signal = init_signal_proc_matfile('lead_signal.mat', save_path);

% Initialization of Powerlab file(s)
%powerlab_signals = init_powerlab_raw_matfile(powerlab_filename,read_path);

% Read experiment notes in Excel file template
notes = init_notes_xlsfile(notes_filename,read_path);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
%ultrasound = init_m3_raw_textfile(ultrasound_filename,read_path);


%% Pre-process signal
% * Resample signal
% * Add note columns that have given VariableContinuity properties
% * Clip to signal to notes range

lvad_signal = resample_signal(lvad_signal);
lead_signal = resample_signal(lead_signal);

% Vector length
lvad_signal.accNorm = sqrt(sum(lvad_signal.acc.^2,2));
lead_signal.accNorm = sqrt(sum(lead_signal.acc.^2,2));
    
% Moving RMS, variance and standard deviation for 3 comp. length
lvad_signal = calc_moving(lvad_signal);
lead_signal = calc_moving(lead_signal);

lead_signal = sync_acc(lead_signal, lvad_signal);

% Init notes, then signal and notes fusion (after resampling and syncing)
lvad_signal = merge_signal_and_notes(lvad_signal,notes);
lead_signal = merge_signal_and_notes(lead_signal,notes);
%lead_signal = calc_moving(lead_signal);

lvad_signal = clip_to_experiment(lvad_signal,notes);
lead_signal = clip_to_experiment(lead_signal,notes);


lead_signal = lead_signal(:,1:5);
acc = synchronize(lead_signal,lvad_signal,'regular','SampleRate',lvad_signal.Properties.SampleRate);

% Look at RPM order plots as well: Should result in flat/stratified lines
make_rpm_order_map(lvad_signal(lvad_signal.experimentPartNo=='1',:)) %
make_rpm_order_map(lvad_signal(lvad_signal.experimentPartNo=='2',:)) %
make_rpm_order_map(lvad_signal(lvad_signal.experimentPartNo=='3',:)) %
pause
make_rpm_order_map(lead_signal(lead_signal.experimentPartNo=='1',:)) %'Order Map for Driveline Accelerometer - RPM Changes Prior to Thrombi Injections'
make_rpm_order_map(lead_signal(lead_signal.experimentPartNo=='2',:)) %
make_rpm_order_map(lead_signal(lead_signal.experimentPartNo=='3',:)) %


%%

%signals = merge_lvad_and_lead(lvad_signal,lead_signal);
%lead_signals = merge_signal_and_notes(lead_signal,notes);

% Init notes, then signal and notes fusion (after resampling)
signals = merge_signal_and_notes(lvad_signal,notes);
signals = clip_to_experiment(signals,notes);

% Vector length
signals.accNorm = sqrt(sum(signals.acc.^2,2));
    
% Moving RMS, variance and standard deviation for 3 comp. length
signals = calc_moving(signals);

% After new variable have been calculated, then split the prepared data
signal_parts = split_into_experiment_parts(signals,notes);
signal_parts.part2_iv = signal_parts.part2(signal_parts.part2.event~='Baseline',:);

features = extract_features_from_notes(notes);

%save_table('signal_preproc.mat', save_path, signal, 'matlab');

features = make_feature_windows(lead_signal, features)


%% Continuous wavelet transform




%% Estimate the spectrum using the short-time Fourier transform

%make_spectrogram(signal_parts.part2_iv,'accNorm')


%% Make time domain plots

%make_time_plots(signal_parts.part2_iv,'accNorm')


%% Calc FFT
% Remove the static effect of gravity in the in vitro setup?
%   - no need for accNorm
%   - perhaps requiured when looking at a 2-D plane
% Adjust time to comparable intervention windows

%make_fft_plots(signal_parts.part2)


%% Make RPM order maps

% make_rpm_order_map(signal_parts.part1)
% make_rpm_order_map(signal_parts.part2)
% make_rpm_order_map(signal_parts.part3)

