%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
experiment_subdir = ['IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer'];
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
    'IV2_NewAccelerometer_PowerLab.mat'
    };
notes_fileName = 'IV2_NewAccelerometer_PowerLab - Notes ver3.10 - Rev0.xlsm';
ultrasound_fileNames = {
    'ECM_2020_06_30__17_17_05.wrf'
    };

% Add subdir specification to filename lists
read_path = 'C:\Data\IVS\Didrik\IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer\Recorded';
save_path = 'C:\Data\IVS\Didrik\IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer\Processed';
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,powerlab_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Max frequency  Type        Continuity
    'Trykk1'         'affP'       1500           'single'    'continuous'
    'Trykk2'         'effP'       1500           'single'    'continuous'
    'SensorAAccX'    'accA_x'     1500            'numeric'   'continuous'
    'SensorAAccY'    'accA_y'     1500            'numeric'   'continuous'
    'SensorAAccZ'    'accA_z'     1500            'numeric'   'continuous'
    'SensorBAccX'    'accB_x'     1500            'numeric'   'continuous'
    'SensorBAccY'    'accB_y'     1500            'numeric'   'continuous'
    'SensorBAccZ'    'accB_z'     1500            'numeric'   'continuous'
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
US = init_system_m_text_files(ultrasound_filePaths);

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

notes = qc_notes(notes);

US = removevars(US, {'affEmboliVol','affEmboliCount','effEmboliVol','effEmboliCount'});

S_PL = fuse_data(notes,PL,US);
S_PL_parts = split_into_parts(S_PL);
S_PL_parts = add_spatial_norms(S_PL_parts,2);
S_PL_parts = add_spatial_norms(S_PL_parts,2,{'accB_x','accB_y','accB_z'},'accB_norm');
S_PL_parts = add_moving_statistics(S_PL_parts);
S_PL_parts = add_moving_statistics(S_PL_parts,{'accB_norm'});
S_PL_parts = add_moving_statistics(S_PL_parts,{'accA_x'});
S_PL_parts = add_moving_statistics(S_PL_parts,{'accA_y'});
S_PL_parts = add_moving_statistics(S_PL_parts,{'accA_z'});
S_PL_parts = add_moving_statistics(S_PL_parts,{'accB_x'});
S_PL_parts = add_moving_statistics(S_PL_parts,{'accB_y'});
S_PL_parts = add_moving_statistics(S_PL_parts,{'accB_z'});

%ask_to_save({'S_parts','notes','feats'},sequence);
