%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
experiment_subdir = ['IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer2'];
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';
cb_driveline_subdir = 'Recorded\Cardibox - Driveline';
cb_lvad_subdir = 'Recorded\Cardibox - LVAD';


% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
%      'IV2_NewAccelerometer2_PowerLab - F1.mat'
%      'IV2_NewAccelerometer2_PowerLab - F2.mat'
%      'IV2_NewAccelerometer2_PowerLab - F3_Sel1.mat'
%      'IV2_NewAccelerometer2_PowerLab - F3_Sel2.mat'
%      'IV2_NewAccelerometer2_PowerLab - F4.mat'
     'IV2_NewAccelerometer2_PowerLab - F5_Sel1.mat'
     'IV2_NewAccelerometer2_PowerLab - F5_Sel2.mat'
     'IV2_NewAccelerometer2_PowerLab - F6.mat'
     'IV2_NewAccelerometer2_PowerLab - F7.mat'
    };
notes_fileName = 'IV2_NewAccelerometer2 - Notes ver3.10 - Rev1.xlsm';
ultrasound_fileNames = {
%    'ECM_2020_08_13__13_58_56.wrf'
%    'ECM_2020_08_14__15_17_16.wrf'
    'ECM_2020_08_17__12_01_46.wrf'
    'ECM_2020_08_18__13_33_40.wrf'
    };
cb_driveline_fileNames = {
    'monitor-20200813-125442\monitor-20200813-135659.txt'
    'monitor-20200814-150828\monitor-20200814-172335.txt'
    'monitor-20200817-115541\monitor-20200817-115711.txt'
    };
cb_lvad_fileNames = {
    'monitor-20200814-132822\monitor-20200814-141207.txt'
    };

% Add subdir specification to filename lists
read_path = 'C:\Data\IVS\Didrik\IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer2\Recorded';
save_path = 'C:\Data\IVS\Didrik\IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer2\Processed';
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,powerlab_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);
cb_driveline_filePaths = fullfile(basePath,experiment_subdir,cb_driveline_subdir,cb_driveline_fileNames);
cb_lvad_filePaths = fullfile(basePath,experiment_subdir,cb_lvad_subdir,cb_lvad_fileNames);

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
PL = init_powerlab_raw_matfiles(powerlab_filePaths,'',powerlab_variable_map);

% Read driveline accelerometer data
% CB_LVAD = init_cardibox_raw_txtfile(cb_lvad_filePaths,'','accA');
% CB_DL = init_cardibox_raw_txtfile(cb_driveline_filePaths,'','accA');

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_m3_raw_textfile(ultrasound_filePaths);

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);

US = removevars(US, {'affEmboliVol','affEmboliCount','effEmboliVol','effEmboliCount'});

% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

notes = qc_notes(notes);

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
% S_PL_parts = add_harmonics_filtered_variables(S_PL_parts, {'accA_norm','accA_x'}, [1,2,4]);
% S_PL_parts = add_harmonics_filtered_variables(S_PL_parts, {'accA_y','accA_z'}, [1,2,4]);

%%

CB_LVAD.time = CB_LVAD.time + hours(1)+minutes(4)+seconds(57);
S_CB = fuse_data(notes,CB_LVAD,US);
S_CB_parts = split_into_parts(S_CB);
S_CB_parts = add_spatial_norms(S_CB_parts,2);
S_CB_parts = add_moving_statistics(S_CB_parts);
S_CB_parts = add_moving_statistics(S_CB_parts,{'accA_x'});
S_CB_parts = add_moving_statistics(S_CB_parts,{'accA_y'});
S_CB_parts = add_moving_statistics(S_CB_parts,{'accA_z'});

CB_DL.time = CB_DL.time + minutes(3) + seconds(47);
S_CB_DL = fuse_data(notes,CB_DL,US);
S_CB_DL_parts = split_into_parts(S_CB_DL);
S_CB_DL_parts = add_spatial_norms(S_CB_DL_parts,2);
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts);
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts,{'accA_x'});
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts,{'accA_y'});
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts,{'accA_z'});

%ask_to_save({'S_parts','notes','feats'},sequence);
