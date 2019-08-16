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
lvad_acc_filename   = fullfile('Cardiaccs','Surface','monitor-20181207-154327.txt');
lead_acc_filename   = fullfile('Cardiaccs','Teguar','monitor-20181207-153752.txt');
notes_filename      = fullfile('Notes','In Vitro 1 - HVAD - THROMBI SPEED IV.xlsx');
powerlab_filename   = fullfile('PowerLab','test.mat');
ultrasound_filename = fullfile('M3','ECM_2019_06_28__15_58_28.wrf');

%experiment_subdir = fullfile('In Vitro 1 - HVAD - THROMBI SPEED IV');
experiment_subdir = fullfile('In Vitro - PREPERATIONS');
[read_path, save_path] = init_paths(experiment_subdir);

% Initialization of Cardiaccs text files (incl. saving to binary .mat file)
%lvad_acc = init_cardiaccs_raw_txtfile(lvad_acc_filename,read_path);
%lead_acc = init_cardiaccs_raw_txtfile(lead_acc_filename,read_path);
%save_table('lvad_acc.mat', save_path, lvad_acc, 'matlab');
%save_table('lead_acc.mat', save_path, lead_acc, 'matlab');
lvad_acc = init_signal_proc_matfile('lvad_acc.mat', save_path);
lead_acc = init_signal_proc_matfile('lead_acc.mat', save_path);

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

lvad_acc = resample_signal(lvad_acc);
lead_acc = resample_signal(lead_acc);

% Vector length
lvad_acc.acc_length = sqrt(sum(lvad_acc.acc.^2,2));
lead_acc.acc_length = sqrt(sum(lead_acc.acc.^2,2));
    
% Moving RMS, variance and standard deviation for 3 comp. length
lvad_acc = calc_moving(lvad_acc);
lead_acc = calc_moving(lead_acc);

lead_acc = sync_acc(lead_acc, lvad_acc);

% Init notes, then signal and notes fusion (after resampling and syncing)
lvad_acc = merge_signal_and_notes(lvad_acc,notes);
lead_acc = merge_signal_and_notes(lead_acc,notes);
lead_acc.acc_length = sqrt(sum(lead_acc.acc.^2,2));
lead_acc = calc_moving(lead_acc);

lvad_acc = clip_to_experiment(lvad_acc,notes);
lead_acc = clip_to_experiment(lead_acc,notes);


lead_acc = lead_acc(:,1:5);
acc = synchronize(lead_acc,lvad_acc,'regular','SampleRate',lvad_acc.Properties.SampleRate);

% Look at RPM order plots as well: Should result in flat/stratified lines
make_rpm_order_map(lvad_acc(lvad_acc.experimentPartNo=='1',:)) %
make_rpm_order_map(lvad_acc(lvad_acc.experimentPartNo=='2',:)) %
make_rpm_order_map(lvad_acc(lvad_acc.experimentPartNo=='3',:)) %
pause
make_rpm_order_map(lead_acc(lead_acc.experimentPartNo=='1',:)) %'Order Map for Driveline Accelerometer - RPM Changes Prior to Thrombi Injections'
make_rpm_order_map(lead_acc(lead_acc.experimentPartNo=='2',:)) %
make_rpm_order_map(lead_acc(lead_acc.experimentPartNo=='3',:)) %


%%

%signals = merge_lvad_and_lead(lvad_acc,lead_acc);
%lead_signals = merge_signal_and_notes(lead_acc,notes);

% Init notes, then signal and notes fusion (after resampling)
signals = merge_signal_and_notes(lvad_acc,notes);
signals = clip_to_experiment(signals,notes);

% Vector length
signals.acc_length = sqrt(sum(signals.acc.^2,2));
    
% Moving RMS, variance and standard deviation for 3 comp. length
signals = calc_moving(signals);

% After new variable have been calculated, then split the prepared data
signal_parts = split_into_experiment_parts(signals,notes);
signal_parts.part2_iv = signal_parts.part2(signal_parts.part2.event~='Baseline',:);

features = extract_features_from_notes(notes);

%save_table('signal_preproc.mat', save_path, signal, 'matlab');

features = make_feature_windows(lead_acc, features)


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

