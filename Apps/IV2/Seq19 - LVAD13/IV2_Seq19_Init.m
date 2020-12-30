%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'D:\Data\IVS\Didrik';
sequence = 'IV2_Seq19';
experiment_subdir = 'IV2 - Simulated pre-pump thrombosis in 5pst glucose\Seq19 - LVAD13';
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
cardibox_subdir = 'Recorded\Cardibox - LVAD';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
    'IV2_Seq19 - F1.mat'
    'IV2_Seq19 - F2.mat'
    'IV2_Seq19 - F3.mat'
    'IV2_Seq19 - F4.mat'
    'IV2_Seq19 - F5.mat'
    'IV2_Seq19 - F6.mat'
    'IV2_Seq19 - F7.mat'
    'IV2_Seq19 - F8.mat'
    'IV2_Seq19 - F9.mat'
    'IV2_Seq19 - F10.mat'
    'IV2_Seq19 - F11.mat'
    'IV2_Seq19 - F12.mat'
    'IV2_Seq19 - F13.mat'
    };
cardibox_fileNames = { 
    };
notes_fileName = 'IV2_Seq19 - Notes ver4.9 - Rev1.xlsm';
ultrasound_fileNames = {
    'ECM_2020_12_05__16_12_22.wrf'
    'ECM_2020_12_07__14_54_33.wrf'
    'ECM_2020_12_08__13_31_21.wrf'
    };

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,powerlab_fileNames);
driveline_filePaths = fullfile(basePath,experiment_subdir,cardibox_subdir,cardibox_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    'Trykk1'         'affP'        'single'    'continuous'
    'Trykk2'         'effP'        'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
    %'SensorBAccX'    'accB_x'      'single'    'continuous'
    %'SensorBAccY'    'accB_y'      'single'    'continuous'
    %'SensorBAccZ'    'accB_z'      'single'    'continuous'
    };

systemM_varMap = {
    % Name in Spectrum   Name in Matlab     SampleRate Type     Continuity   Units
    'ArtflowLmin'        'effQ'             1          'single' 'continuous' 'L/min'
    'VenflowLmin'        'affQ'             1          'single' 'continuous' 'L/min'
    };

%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

init_matlab
welcome('Initializing data','module')
%if load_workspace({'S_parts','notes','feats'}); return; end

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(powerlab_filePaths,'',powerlab_variable_map);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_system_m_text_files(ultrasound_filePaths,'',systemM_varMap);

% Read 2.and LVAD accelerometer data
%CB = init_cardibox_raw_txtfile(cardibox_filePaths,'','accC');

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver4(notes_filePath);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

notes = qc_notes_ver4(notes);

%feats = init_features_from_notes(notes);

%clear S
% S = fuse_data_parfor(notes,PL,US);
S = fuse_data(notes,PL,US);
%clear PL US
S_parts = split_into_parts(S);
%clear S

S_parts = add_spatial_norms(S_parts,2);
S_parts = add_moving_statistics(S_parts);
S_parts = add_moving_statistics(S_parts,{'accA_x'});
S_parts = add_moving_statistics(S_parts,{'accA_y'});
S_parts = add_moving_statistics(S_parts,{'accA_z'});
S_parts = add_spatial_norms(S_parts, 2, {'accB_x','accB_y','accB_z'}, 'accB_norm');
S_parts = add_moving_statistics(S_parts,{'accB_norm'});

%S_parts = add_moving_statistics(S_parts,{'effP','affP'});


% TODO:
% Add MPF, std, RMS and other statistics/indices into feats
% Revise categoric blocks, and put into feats

ask_to_save({'S_parts','notes','feats'},sequence);
