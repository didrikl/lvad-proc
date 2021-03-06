%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'D:\Data\IVS\Didrik';
sequence = 'IV2_Seq24';
experiment_subdir = 'IV2 - Simulated pre-pump thrombosis in 5pst glucose\Seq24 - LVAD16 - Pump test';
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
cardibox_subdir = 'Recorded\Cardibox - LVAD';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
labChart_fileNames = {
    'IV2_Seq24 - F1 [accA,pAff,pEff].mat'
    };
notes_fileName = 'IV2_Seq24 - Notes ver4.9 - Rev0.xlsm';
ultrasound_fileNames = {
    'ECM_2021_01_12__18_01_51.wrf'
    };

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,labChart_fileNames);
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

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver4(notes_filePath);


%% Pre-processing
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts
% * resampling to regular sampling intervals of given frequency

welcome('Preprocessing data','module')

fs_new = 750;
interNoteInclSpec = 'nearest';
outsideNoteInclSpec = 'nearest';

secsAhead = 6;
US = adjust_for_linear_time_drift(US,secsAhead);

notes = qc_notes_ver4(notes);

PL = resample_signal(PL, fs_new);

% S = fuse_data_parfor(notes,PL,US);
S = fuse_data(notes,PL,US,fs_new,interNoteInclSpec,outsideNoteInclSpec);

S_parts = split_into_parts(S,fs_new);

% QC of pressure
% ol_ind = S_parts{5}.p_graft>3*S_parts{5}.p_graft_movAvg;
% Keep original data, along with row and col indices

%% Process derived variables

welcome('Processing derived variable','module')

S_parts = add_spatial_norms(S_parts,2,{'accA_x','accA_y','accA_z'},'accA_norm');
S_parts = add_moving_statistics(S_parts,{'accA_norm','accA_x','accA_y','accA_z'},{'std'});


% Add highpass-filtered moving acc statistics



%feats = init_features_from_notes(notes);

%ask_to_save({'S_parts','notes','feats'},sequence,proc_path);
