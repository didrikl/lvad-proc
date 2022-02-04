%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
seq_subdir = ['IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer'];
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
cb_driveline_subdir = 'Recorded\Cardibox - Driveline';
cb_lvad_subdir = 'Recorded\Cardibox - LVAD';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
labChart_fileNames = {
    'IV2_NewAccelerometer_Teguar_ch1-2.mat'
    };
cb_driveline_fileNames = {
    'monitor-20200626-152417\monitor-20200626-152424.txt'
    };
cb_lvad_fileNames = {
    'monitor-20200626-141929\monitor-20200626-142203.txt'
    };
notes_fileName = 'IV2_NewAccelerometer_Teguar - Notes ver3.10 - Rev1.xlsm';
ultrasound_fileNames = {
    'ECM_2020_06_26__15_36_58.wrf'
    };

% Add subdir specification to filename lists
read_path = 'C:\Data\IVS\Didrik\IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer\Recorded';
save_path = 'C:\Data\IVS\Didrik\IV2 - Simulated pre-pump thrombosis in 5pst glucose\Testing\NewAccelerometer\Processed';
ultrasound_filePaths  = fullfile(basePath,seq_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,seq_subdir,powerlab_subdir,labChart_fileNames);
cb_driveline_filePaths = fullfile(basePath,seq_subdir,cb_driveline_subdir,cb_driveline_fileNames);
cb_lvad_filePaths = fullfile(basePath,seq_subdir,cb_lvad_subdir,cb_lvad_fileNames);
notes_filePath = fullfile(basePath, seq_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Max frequency  Type        Continuity
    'Trykk1'         'p_eff'       1000           'single'    'continuous'
    'Trykk2'         'p_aff'       1000           'single'    'continuous'
    %'SensorAAccX'    'accA_x'     700            'numeric'   'continuous'
    %'SensorAAccY'    'accA_y'     700            'numeric'   'continuous'
    %'SensorAAccZ'    'accA_z'     700            'numeric'   'continuous'
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

% Read driveline accelerometer data
CB_LVAD = init_cardibox_raw_txtfile(cb_lvad_filePaths,'','accA');
%CB_DL = init_cardibox_raw_txtfile(cb_driveline_filePaths,'','accB');
CB_DL = init_cardibox_raw_txtfile(cb_driveline_filePaths,'','accB');

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

CB_LVAD.time = CB_LVAD.time + minutes(2) + seconds(59)  +  hours(1)+minutes(2)-seconds(20);
S_CB = fuse_data(notes,CB_LVAD,US);
S_CB_parts = split_into_parts(S_CB);
S_CB_parts = add_spatial_norms(S_CB_parts,2);
S_CB_parts = add_moving_statistics(S_CB_parts);
S_CB_parts = add_moving_statistics(S_CB_parts,{'accA_x'});
S_CB_parts = add_moving_statistics(S_CB_parts,{'accA_y'});
S_CB_parts = add_moving_statistics(S_CB_parts,{'accA_z'});
% %S_parts = add_moving_statistics(S_parts,{'p_aff','p_eff'});

CB_DL.time = CB_DL.time + minutes(2) + seconds(59);
S_CB_DL = fuse_data(notes,CB_DL,US);
S_CB_DL_parts = split_into_parts(S_CB_DL);
S_CB_DL_parts = add_spatial_norms(S_CB_DL_parts,2,{'accB_x','accB_y','accB_z'},'accB_norm');
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts,{'accB_norm'});
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts,{'accB_x'});
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts,{'accB_y'});
S_CB_DL_parts = add_moving_statistics(S_CB_DL_parts,{'accB_z'});

%ask_to_save({'S_parts','notes','feats'},sequence);
