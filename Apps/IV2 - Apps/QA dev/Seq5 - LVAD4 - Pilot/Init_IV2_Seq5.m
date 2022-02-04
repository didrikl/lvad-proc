%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
sequence = 'IV2_Seq5';
seq_subdir = [sequence,' - Water simulated HVAD thrombosis'];
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
driveline_subdir = 'Recorded\Teguar';
ultrasound_subdir = 'Recorded\M3';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
labChart_fileNames = {
    'IV2_Seq5 - F1_ch1-5.mat'
    'IV2_Seq5 - F2_ch1-5.mat'
    'IV2_Seq5 - F3_ch1-5.mat'
    'IV2_Seq5 - F4_ch2-5.mat'
    'IV2_Seq5 - F5_ch1-5.mat'
    'IV2_Seq5 - F6_ch1-5.mat'
    'IV2_Seq5 - F7_ch1-5.mat'
    'IV2_Seq5 - F8_ch1-5.mat'
    'IV2_Seq5 - F9_ch1-5.mat'
    };
driveline_fileNames = {
    'monitor-20200512-084303\monitor-20200512-180822.txt'
    };
notes_fileName = 'IV2_Seq5 - Notes ver3.10 - Rev0.xlsm';
ultrasound_fileNames = {
    'ECM_2020_05_12__19_14_11.wrf'
    'ECM_2020_05_25__18_14_34.wrf'
    'ECM_2020_05_26__17_32_36.wrf'
    'ECM_2020_05_27__13_31_01.wrf'
    'ECM_2020_05_27__15_28_33.wrf'
    'ECM_2020_05_27__17_18_04.wrf'
    };

% Add subdir specification to filename lists
[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,seq_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,seq_subdir,powerlab_subdir,labChart_fileNames);
driveline_filePaths = fullfile(basePath,seq_subdir,driveline_subdir,driveline_fileNames);
notes_filePath = fullfile(basePath, seq_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Max frequency  Type        Continuity
    'Trykk1'         'p_eff'       1000           'single'    'continuous'
    'Trykk2'         'p_aff'       1000           'single'    'continuous'
    'SensorAAccX'    'accA_x'     700            'numeric'   'continuous'
    'SensorAAccY'    'accA_y'     700            'numeric'   'continuous'
    'SensorAAccZ'    'accA_z'     700            'numeric'   'continuous'
    };

%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

init_matlab
welcome('Initializing data','module')
if load_workspace({'S_parts','notes','feats'}); return; end

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(powerlab_filePaths,'',powerlab_variable_map);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_system_m_text_files(ultrasound_filePaths);

% Read driveline accelerometer data
%DL_seq5 = init_cardibox_raw_txtfile(driveline_filePaths,'','accC');

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

notes = qc_notes(notes);

feats = init_features_from_notes(notes);

clear S
%S = fuse_data_parfor(notes,PL,US);
S = fuse_data(notes,PL,US);
%clear PL US
S_parts = split_into_parts(S);
clear S

S_parts = add_spatial_norms(S_parts,2);
S_parts = add_moving_statistics(S_parts);
S_parts = add_moving_statistics(S_parts,{'accA_x'});
S_parts = add_moving_statistics(S_parts,{'accA_y'});
S_parts = add_moving_statistics(S_parts,{'accA_z'});
S_parts = add_moving_statistics(S_parts,{'p_aff','p_eff'});

% Maybe not a pre-processing thing
%S_parts = add_harmonics_filtered_variables(S_parts);

% TODO:
% Add MPF, std, RMS and other statistics/indices into feats
% Revise categoric blocks, and put into feats

ask_to_save({'S_parts','notes','feats'},sequence);
