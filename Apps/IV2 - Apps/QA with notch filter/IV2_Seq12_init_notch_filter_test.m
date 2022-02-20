%% Initialze the processing environment and input file structure

% Experiment sequence ID
basePath = 'D:\Data\IVS\Didrik';
Config.seq_subdir = 'IV2 - In vitro pre-pump thrombosis simulation\Seq12 - LVAD11';
proc_path = fullfile(basePath,Config.seq_subdir,'Processed');

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% NOTE: Could be implemented to be selected interactively using uigetfiles
Config.labChart_fileNames = {
%     'IV2_Seq12 - F1.mat'
%     'IV2_Seq12 - F2.mat'
%     'IV2_Seq12 - F3.mat'
%     'IV2_Seq12 - F4.mat'
%     'IV2_Seq12 - F5.mat'
%     'IV2_Seq12 - F6.mat'
%     'IV2_Seq12 - F7.mat'
%     'IV2_Seq12 - F8.mat'
%     'IV2_Seq12 - F9.mat'
%     'IV2_Seq12 - F10.mat'
%     'IV2_Seq12 - F11.mat'
%     'IV2_Seq12 - F12.mat'
%     'IV2_Seq12 - F13.mat'
%     'IV2_Seq12 - F14.mat'
%     'IV2_Seq12 - F15.mat'
%    'IV2_Seq12 - F16.mat'
    'IV2_Seq12 - F17.mat'
    };
Config.notes_fileName = 'IV2_Seq12 - Notes ver4.9 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_09_08__13_18_56.wrf'
    'ECM_2020_09_09__11_46_35.wrf'
    'ECM_2020_09_10__15_40_40.wrf'
    };

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,Config.seq_subdir,ultrasound_subdir,Config.ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,Config.seq_subdir,powerlab_subdir,Config.labChart_fileNames);
notes_filePath = fullfile(basePath, Config.seq_subdir,notes_subdir,Config.notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    'Trykk1'         'p_eff'        'single'    'continuous'
    'Trykk2'         'p_aff'        'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
%     'SensorBAccX'    'accB_x'      'single'    'continuous'
%     'SensorBAccY'    'accB_y'      'single'    'continuous'
%     'SensorBAccZ'    'accB_z'      'single'    'continuous'
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
US1 = init_system_m_text_files(ultrasound_filePaths(1),'',systemM_varMap);
US2 = init_system_m_text_files(ultrasound_filePaths(2),'',systemM_varMap);
US3 = init_system_m_text_files(ultrasound_filePaths(3),'',systemM_varMap);

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver4(notes_filePath,'','VarMap_IV2_Notes_Ver4p9');


%% Pre-processing
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts
% * resampling to regular sampling intervals of given frequency

welcome('Preprocessing data','module')

fs_new = 750;

US1 = adjust_for_linear_time_drift(US1,20.5);
US2 = adjust_for_linear_time_drift(US2,62);
US3 = adjust_for_linear_time_drift(US3,3.5);
US = [US1;US2;US3];
US = aggregate_effQ_and_affQ(US);

notes = qc_notes_ver4(notes);

PL = resample_signal(PL, fs_new);

PL_filesOffset = {...
    'IV2_Seq12 - F7.mat'
    'IV2_Seq12 - F8.mat'
    'IV2_Seq12 - F9.mat'
    'IV2_Seq12 - F10.mat'
    'IV2_Seq12 - F11.mat'
    'IV2_Seq12 - F12.mat'
    'IV2_Seq12 - F13.mat'
    'IV2_Seq12 - F14.mat'
    'IV2_Seq12 - F15.mat'
    'IV2_Seq12 - F16.mat'
    };
PL = adjust_for_constant_time_offset_for_filenames(...
	PL, PL_filesOffset, seconds(60));

PL = add_spatial_norms(PL,2,{'accA_x','accA_y','accA_z'},'accA_norm');
%PL = add_spatial_norms(PL,2,{'accB_x','accB_y','accB_z'},'accB_norm');

interNoteInclSpec = 'nearest';
Config.outsideNoteInclSpec = 'none';
S = fuse_data(notes,PL,US,fs_new,interNoteInclSpec,Config.outsideNoteInclSpec);

S_parts = split_into_parts(S,fs_new);

S_parts = add_harmonics_filtered_variables(S_parts, {'accA_norm',}, 1:5, 1);
S_parts = add_harmonics_filtered_variables(S_parts, {'accA_x','accA_y','accA_z'}, 1:5, 1);
%S_parts = add_harmonics_filtered_variables(S_parts, {'accB_norm',}, 1);
