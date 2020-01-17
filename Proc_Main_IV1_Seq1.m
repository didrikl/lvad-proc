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
% Get data as it is stored on disc (with some processing to get the data
% into timetables)

% User inputs
lvad_signal_filename = fullfile('Cardiaccs','Surface','monitor-20181207-154327.txt');
lead_signal_filename = fullfile('Cardiaccs','Teguar','monitor-20181207-153752.txt');
notes_filename       = fullfile('Notes','In Vitro 1 - HVAD - THROMBI SPEED IV.xlsx');
powerlab_filename    = fullfile('PowerLab','test.mat');
ultrasound_filename  = fullfile('M3','ECM_2019_06_28__15_58_28.wrf');

experiment_subdir    = 'Preparations';
[read_path, save_path] = init_io_paths(experiment_subdir);

% Initialization of Cardiaccs text files (incl. saving to binary .mat file)
% lvad_signal = init_cardiaccs_raw_txtfile(lvad_signal_filename,read_path);
% lead_signal = init_cardiaccs_raw_txtfile(lead_signal_filename,read_path);
% save_table('lvad_signal.mat', save_path, lvad_signal, 'matlab');
% save_table('lead_signal.mat', save_path, lead_signal, 'matlab');
lvad_signal = init_signal_proc_matfile('lvad_signal.mat', save_path);
lead_signal = init_signal_proc_matfile('lead_signal.mat', save_path);

% Initialization of Powerlab file(s)
%powerlab_signals = init_powerlab_raw_matfile(powerlab_filename,read_path);

% Read experiment notes in Excel file template
notes = init_notes_xlsfile(notes_filename,read_path);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
%ultrasound = init_m3_raw_textfile(ultrasound_filename,read_path);

features = init_features_from_notes(notes);


%% Pre-process signal
% Changing signal and deriving new variables

lvad_signal = resample_signal(lvad_signal, 520);
lead_signal = resample_signal(lead_signal, 520);

% Vector length
lvad_signal = calc_norm(lvad_signal, 'acc');
lead_signal = calc_norm(lead_signal, 'acc');

% Moving RMS, variance and standard deviation for 3 comp. length
lvad_signal = calc_moving(lvad_signal, 'accNorm');
lead_signal = calc_moving(lead_signal, 'accNorm');

% Merge LVAD and lead accelerometers
lead_signal = sync_lead_with_lvad_acc(lead_signal, lvad_signal);
signal = synchronize(lvad_signal,lead_signal,'regular','SampleRate',lvad_signal.Properties.SampleRate);

% Init notes, then signal and notes fusion (after resampling and syncing)
signal = merge_signal_and_notes(signal,notes);
lvad_signal = merge_signal_and_notes(lvad_signal,notes);
lead_signal = merge_signal_and_notes(lead_signal,notes);

signal = clip_to_experiment(signal,notes);
lvad_signal = clip_to_experiment(lvad_signal,notes);
lead_signal = clip_to_experiment(lead_signal,notes);

% Manual assessment of each intervention segments
features = make_feature_windows(signal, features);

%save_table('signal_preproc.mat', save_path, signal, 'matlab');


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scripts to make use of initialized and preprocessed data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Look at RPM order plots as well: Should result in flat/stratified lines
make_rpm_order_map(lvad_signal(lvad_signal.experimentPartNo=='1',:)) %
make_rpm_order_map(lvad_signal(lvad_signal.experimentPartNo=='2',:)) %
make_rpm_order_map(lvad_signal(lvad_signal.experimentPartNo=='3',:)) %
pause
make_rpm_order_map(lead_signal(lead_signal.experimentPartNo=='1',:)) %'Order Map for Driveline Accelerometer - RPM Changes Prior to Thrombi Injections'
make_rpm_order_map(lead_signal(lead_signal.experimentPartNo=='2',:)) %
make_rpm_order_map(lead_signal(lead_signal.experimentPartNo=='3',:)) %

%% Make average order spectrogram and extract relevant features

Average_Order_Spectrum_For_Intervention_Segments

%%

figure
hold on
make_average_order_spectrum(lvad_signal(lvad_signal.experimentPartNo=='1',:));
make_average_order_spectrum(lead_signal(lead_signal.experimentPartNo=='1',:));
make_average_order_spectrum(lvad_signal(lvad_signal.experimentPartNo=='3',:));
spec = make_average_order_spectrum(lead_signal(lead_signal.experimentPartNo=='3',:));
legend({'LVAD, before injections','Driveline, before injections','LVAD, after injections','Driveline, after injections'})


%%

% Init notes, then signal and notes fusion (after resampling)
signals = merge_signal_and_notes(lvad_signal,notes);
signals = clip_to_experiment(signals,notes);

% After new variable have been calculated, then split the prepared data
signal_parts = split_into_experiment_parts(signals,notes);
signal_parts.part2_iv = signal_parts.part2(signal_parts.part2.event~='Baseline',:);





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


