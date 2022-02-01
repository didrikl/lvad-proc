%% Initialze the processing environment and input file structure

% Experiment sequence ID
basePath = 'D:\Data\IVS\Didrik';
experiment_subdir = 'IV2 - In vitro pre-pump thrombosis simulation\Seq13 - LVAD12';
proc_path = fullfile(basePath,experiment_subdir,'Processed');

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% NOTE: Could be implemented to be selected interactively using uigetfiles
labChart_fileNames = {
    'IV2_Seq13 - F1 [pEff,pAff].mat'
    'IV2_Seq13 - F1 [accA].mat'
    'IV2_Seq13 - F1 [accB].mat'
    'IV2_Seq13 - F2 [pEff,pAff].mat'
    'IV2_Seq13 - F2 [accA].mat'
    'IV2_Seq13 - F2 [accB].mat'
    'IV2_Seq13 - F3 [accA].mat'
    'IV2_Seq13 - F3 [accB].mat'
    'IV2_Seq13 - F3 [pEff,pAff].mat'
    'IV2_Seq13 - F4 [accA].mat'
    'IV2_Seq13 - F4 [accB].mat'
    'IV2_Seq13 - F4 [pEff,pAff].mat'
    'IV2_Seq13 - F5 [accA].mat'
    'IV2_Seq13 - F5 [accB].mat'
    'IV2_Seq13 - F5 [pEff,pAff].mat'
    'IV2_Seq13 - F6 [accA].mat'
    'IV2_Seq13 - F6 [accB].mat'
    'IV2_Seq13 - F6 [pEff,pAff].mat'
    'IV2_Seq13 - F7 [pEff,pAff].mat'
    'IV2_Seq13 - F7 [accA].mat'
    'IV2_Seq13 - F7 [accB].mat'
    'IV2_Seq13 - F8 [pEff,pAff].mat'
    'IV2_Seq13 - F8 [accA].mat'
    'IV2_Seq13 - F8 [accB].mat'
    'IV2_Seq13 - F9 [pEff,pAff].mat'
    'IV2_Seq13 - F9 [accA].mat'
    'IV2_Seq13 - F9 [accB].mat'
    'IV2_Seq13 - F10 [pEff,pAff].mat'
    'IV2_Seq13 - F10 [accA].mat'
    'IV2_Seq13 - F10 [accB].mat'
    'IV2_Seq13 - F11 [pEff,pAff].mat'
    'IV2_Seq13 - F11 [accA].mat'
    'IV2_Seq13 - F11 [accB].mat'
    'IV2_Seq13 - F12 [pEff,pAff].mat'
    'IV2_Seq13 - F12 [accA].mat'
    'IV2_Seq13 - F12 [accB].mat'
    'IV2_Seq13 - F13 [pEff,pAff].mat'
    'IV2_Seq13 - F13 [accA].mat'
    'IV2_Seq13 - F13 [accB].mat'
    };
notes_fileName = 'IV2_Seq13 - Notes ver4.9 - Rev2.xlsm';
ultrasound_fileNames = {
    'ECM_2020_09_11__12_30_59.wrf'
    };

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,labChart_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    'Trykk1'         'p_eff'        'single'    'continuous'
    'Trykk2'         'p_aff'        'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
    'SensorBAccX'    'accB_x'      'single'    'continuous'
    'SensorBAccY'    'accB_y'      'single'    'continuous'
    'SensorBAccZ'    'accB_z'      'single'    'continuous'
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

US = adjust_for_linear_time_drift(US,52);
US = aggregate_effQ_and_affQ(US);

notes = qc_notes_ver4(notes);

PL = resample_signal(PL, fs_new);
PL = add_spatial_norms(PL,2,{'accA_x','accA_y','accA_z'},'accA_norm');
PL = add_spatial_norms(PL,2,{'accB_x','accB_y','accB_z'},'accB_norm');

interNoteInclSpec = 'nearest';
outsideNoteInclSpec = 'none';
S = fuse_data(notes,PL,US,fs_new,interNoteInclSpec,outsideNoteInclSpec);

S_parts = split_into_parts(S,fs_new);

S_parts = add_harmonics_filtered_variables(S_parts, {'accA_norm',}, 1:5, 1);
S_parts = add_harmonics_filtered_variables(S_parts, {'accA_x','accA_y','accA_z'}, 1:5, 1);


