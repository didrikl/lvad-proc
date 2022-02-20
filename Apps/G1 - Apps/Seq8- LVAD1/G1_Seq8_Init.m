%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'D:\Data\IVS\Didrik';
sequence = 'Seq8 - LVAD1';
Config.seq_subdir = 'G1 - In vivo pre-pump thrombosis simulation\Seq8 - LVAD1';

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
Config.labChart_fileNames = {
     'G1_Seq8 - F1 [accA].mat'
     'G1_Seq8 - F1 [accB].mat'
     'G1_Seq8 - F1 [pGraft,ECG,pLV].mat'
     'G1_Seq8 - F1 [i1,i2,i3].mat'
     'G1_Seq8 - F1 [v1,v2,v3].mat'
     'G1_Seq8 - F2 [accA].mat'
     'G1_Seq8 - F2 [accB].mat'
     'G1_Seq8 - F2 [pGraft,ECG,pLV].mat'
     'G1_Seq8 - F2 [i1,i2,i3].mat'
     'G1_Seq8 - F2 [v1,v2,v3].mat'
     'G1_Seq8 - F3_Sel1 [accA].mat'
     'G1_Seq8 - F3_Sel1 [accB].mat'
     'G1_Seq8 - F3_Sel1 [pGraft,ECG,pLV].mat'  
     'G1_Seq8 - F3_Sel1 [i1,i2,i3].mat'
     'G1_Seq8 - F3_Sel1 [v1,v2,v3].mat'
     'G1_Seq8 - F3_Sel2 [accA].mat'
     'G1_Seq8 - F3_Sel2 [accB].mat'
     'G1_Seq8 - F3_Sel2 [pGraft,ECG,pLV].mat'  
     'G1_Seq8 - F3_Sel2 [i1,i2,i3].mat'
     'G1_Seq8 - F3_Sel2 [v1,v2,v3].mat'
};

%Config.labChart_fileNames = {'G1_Seq8 - F3_Sel1.txt'}      % 

Config.notes_fileName = 'G1_Seq8 - Notes ver4.16 - Rev7.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_11_12__11_04_40.wrf'
};

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,Config.seq_subdir,ultrasound_subdir,Config.ultrasound_fileNames);
notes_filePath = fullfile(basePath, Config.seq_subdir,notes_subdir,Config.notes_fileName);
proc_path = fullfile(basePath,Config.seq_subdir,'Processed');
powerlab_filePaths = fullfile(basePath,Config.seq_subdir,powerlab_subdir,Config.labChart_fileNames);

powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    'pGraft'         'p_graft'     'single'    'continuous'
    'ECG'            'ecg'         'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
    'SensorBAccX'    'accB_x'      'single'    'continuous'
    'SensorBAccY'    'accB_y'      'single'    'continuous'
    'SensorBAccZ'    'accB_z'      'single'    'continuous'
    'pMillarLV'      'pLV'         'single'    'continuous'
    'V1'             'v1'          'single'    'continuous'
    'V2'             'v2'          'single'    'continuous'
    'V3'             'v3'          'single'    'continuous'
    'I1'             'i1'          'single'    'continuous'
    'I2'             'i2'          'single'    'continuous'
    'I3'             'i3'          'single'    'continuous'
    };

systemM_varMap = {
    % Name in Spectrum   Name in Matlab     SampleRate Type     Continuity   Units
    'VenflowLmin'        'Q_graft'          1          'single' 'continuous' 'L/min'
    };

%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

welcome('Initializing data','module')
if load_workspace({'S_parts','notes','feats'},proc_path); return; end

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(powerlab_filePaths,'',powerlab_variable_map);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_system_m_text_files(ultrasound_filePaths,'',systemM_varMap);

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver4(notes_filePath);
notes = qc_notes_ver4(notes);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

welcome('Preprocessing data','module')

fs_new = 500;
interNoteInclSpec = 'nearest';
Config.outsideNoteInclSpec = 'nearest';

secsAhead = 49; % ...Not 51 as noted
US = adjust_for_linear_time_drift(US,secsAhead);

%PL = resample_signal(PL, fs_new);

% S = fuse_data_parfor(notes,PL,US);
S = fuse_data(notes,PL,US,fs_new,interNoteInclSpec,Config.outsideNoteInclSpec);

S_parts = split_into_parts(S,fs_new);


%% Process derived variables

welcome('Processing derived variable','module')

S_parts = add_spatial_norms(S_parts,2,{'accA_x','accA_y','accA_z'},'accA_norm');
S_parts = add_spatial_norms(S_parts,2,{'accB_x','accB_y','accB_z'},'accB_norm');
S_parts = add_spatial_norms(S_parts,2,{'i1','i2','i3'},'i_norm');
S_parts = add_spatial_norms(S_parts,2,{'v1','v2','v3'},'v_norm');
%S_parts = remove_variables(S_parts,{'accB_x','accB_y','accB_z'});

% Add highpass-filtered moving acc statistics
S_parts = add_highpass_RPM_filter_variables(S_parts,{'accA_norm'},'accA_norm_HP',1,'harm',1);
%S_parts = add_highpass_RPM_filter_variables(S_parts,{'accA_norm'},'accA_norm_1.5HP',1.5,'harm',0);
S_parts = add_highpass_RPM_filter_variables(S_parts,{'accA_x','accA_y','accA_z'},{'accA_x_HP','accA_y_HP','accA_z_HP'},1,'harm',1);
%S_parts = add_highpass_RPM_filter_variables(S_parts,{'accA_x','accA_y','accA_z'},{'accA_x_1.5HP','accA_y_1.5HP','accA_z_1.5HP'},1.5,'harm',0);

% S_parts = add_moving_statistics(S_parts,{'accA_norm','accA_x','accA_y','accA_z'},{'std'});
% S_parts = add_moving_statistics(S_parts,{'i1','v1','i_norm','v_norm'},{'std'});
% S_parts = add_moving_statistics(S_parts,{'p_graft'},{'avg','max','min'});
% S_parts = add_moving_statistics(S_parts,{'accB_norm'},{'std'});

%feats = init_features_from_notes(notes);


%% Saving and clean up

save_for_FJP(proc_path,S,notes,sequence)
%ask_to_save({'S','notes'},sequence,proc_path);
