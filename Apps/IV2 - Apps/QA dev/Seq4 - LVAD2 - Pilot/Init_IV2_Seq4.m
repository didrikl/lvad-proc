%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
sequence = 'IV2_Seq4';
experiment_subdir = 'IV2_Seq4 - Water simulated HVAD thrombosis';
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
driveline_subdir = 'Recorded\Teguar';
ultrasound_subdir = 'Recorded\M3';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
labChart_fileNames = {
    'IV2_Seq4 - F1_ch1-5.mat'
    'IV2_Seq4 - F2_ch1-5.mat'
    'IV2_Seq4 - F3_ch1-5.mat'
    'IV2_Seq4 - F4_ch1-5.mat'
    'IV2_Seq4 - F5_ch1-5.mat'
    'IV2_Seq4 - F6_ch1-5.mat'
    'IV2_Seq4 - F7_ch1-5.mat'
    'IV2_Seq4 - F8_ch1-5.mat'
    'IV2_Seq4 - F9_Sel1_ch1-5.mat'
    'IV2_Seq4 - F10_ch1-5.mat'
    'IV2_Seq4 - F11_ch1-5.mat'
    'IV2_Seq4 - F12_ch1-5.mat'
    'IV2_Seq4 - F13_ch1-5.mat'
    'IV2_Seq4 - F14_ch1-5.mat'
    };
driveline_fileNames = {
    'monitor-20200430-171551\monitor-20200430-171615.txt'
    'monitor-20200501-145804\monitor-20200501-151024.txt'
    'monitor-20200501-164801\monitor-20200501-164807.txt'
    'monitor-20200501-164801\monitor-20200501-172633.txt'
    'monitor-20200501-180858\monitor-20200501-180918.txt'
    'monitor-20200501-180858\monitor-20200501-190409.txt'
    'monitor-20200505-120202\monitor-20200505-135648.txt'
    'monitor-20200507-122526\monitor-20200507-140957.txt' % check if needed
    'monitor-20200507-122526\monitor-20200507-142148.txt'
    'monitor-20200508-142644\monitor-20200508-150237.txt'
    'monitor-20200511-161528\monitor-20200511-161551.txt'
    'monitor-20200512-084303\monitor-20200512-115108.txt'
    'monitor-20200512-084303\monitor-20200512-125636.txt'
    };
notes_fileName = 'IV2_Seq4 - Notes ver3.10 - Rev2.xlsm';
ultrasound_fileNames = {
    'ECM_2020_04_30__15_34_00 - Truncated.wrf'
    'ECM_2020_05_01__16_11_43.wrf'
    'ECM_2020_05_01__20_07_47.wrf'
    'ECM_2020_05_04__17_47_31.wrf'
    'ECM_2020_05_05__15_01_10.wrf'
    'ECM_2020_05_07__15_24_58.wrf'
    'ECM_2020_05_08__16_06_03.wrf'
    'ECM_2020_05_11__17_19_22.wrf'
    'ECM_2020_05_12__14_01_19.wrf'
    };

% Add subdir specification to filename lists
[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,labChart_fileNames);
driveline_filePaths = fullfile(basePath,experiment_subdir,driveline_subdir,driveline_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Max frequency  Type        Continuity
    'Trykk1'         'affP'       1000           'single'    'continuous'
    'Trykk2'         'effP'       1000           'single'    'continuous'
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
%DL = init_cardibox_raw_txtfile(driveline_filePaths,'','accC');

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

%notes = qc_notes(notes);

% Correct for unsync'ed clock on driveline monitor
% unsync_inds = DL.time + hours(1)+minutes(3)+seconds(29);

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

% Maybe not a pre-processing thing
%S_parts = add_harmonics_filtered_variables(S_parts);

% TODO:
% Add MPF, std, RMS and other statistics/indices into feats
% Revise categoric blocks, and put into feats

ask_to_save({'S_parts','notes','feats'},sequence);

