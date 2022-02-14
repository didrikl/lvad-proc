%% Initialze the processing environment and input file structure
% Use package...
init_matlab

welcome('Initializing user-input','module')

% Which experiment
basePath = 'D:\Data\IVS\Didrik';
sequence = 'Seq12 - LVAD13';
pc.seq_subdir = 'G1 - In vivo pre-pump thrombosis simulation\Seq12 - LVAD17';

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory
% NOTE: Could be implemented to be selected interactively using uigetfiles
pc.labChart_fileNames = {
    'G1_Seq12 - F1 [accA].mat'
    'G1_Seq12 - F1 [accB].mat'
    'G1_Seq12 - F1 [pGraft,ECG,pLV].mat'
    'G1_Seq12 - F1 [V1,V2,V3].mat'
    'G1_Seq12 - F1 [I1,I2,I3].mat'
    'G1_Seq12 - F2 [accA].mat'
    'G1_Seq12 - F2 [accB].mat'
    'G1_Seq12 - F2 [pGraft,ECG,pLV].mat'
    'G1_Seq12 - F2 [V1,V2,V3].mat'
    'G1_Seq12 - F2 [I1,I2,I3].mat'
    'G1_Seq12 - F3 [accA].mat'
    'G1_Seq12 - F3 [accB].mat'
    'G1_Seq12 - F3 [pGraft,ECG,pLV].mat'
    'G1_Seq12 - F3 [V1,V2,V3].mat'
    'G1_Seq12 - F3 [I1,I2,I3].mat'
    'G1_Seq12 - F4 [accA].mat'
    'G1_Seq12 - F4 [accB].mat'
    'G1_Seq12 - F4 [pGraft,ECG,pLV].mat'
    'G1_Seq12 - F4 [V1,V2,V3].mat'
    'G1_Seq12 - F4 [I1,I2,I3].mat'
    'G1_Seq12 - F5 [accA].mat'
    'G1_Seq12 - F5 [accB].mat'
    'G1_Seq12 - F5 [pGraft,ECG,pLV].mat'
    'G1_Seq12 - F5 [V1,V2,V3].mat'
    'G1_Seq12 - F5 [I1,I2,I3].mat'
    };
pc.notes_fileName = 'G1_Seq12 - Notes ver4.16 - Rev6.xlsm';
pc.ultrasound_fileNames = {
    'ECM_2021_01_07__12_08_22.wrf'
    };

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,pc.seq_subdir,ultrasound_subdir,pc.ultrasound_fileNames);
notes_filePath = fullfile(basePath, pc.seq_subdir,notes_subdir,pc.notes_fileName);
proc_path = fullfile(basePath,pc.seq_subdir,'Processed');
powerlab_filePaths = fullfile(basePath,pc.seq_subdir,powerlab_subdir,pc.labChart_fileNames);

powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    'pGraft'         'p_graft'      'single'    'continuous'
    'pMillarLV'      'p_LV'         'single'    'continuous'
    'ECG'            'ecg'         'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
    'SensorBAccX'    'accB_x'      'single'    'continuous'
    'SensorBAccY'    'accB_y'      'single'    'continuous'
    'SensorBAccZ'    'accB_z'      'single'    'continuous'
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
pc.outsideNoteInclSpec = 'nearest';

secsAhead = 52;
US = adjust_for_linear_time_drift(US,secsAhead);

%PL = resample_signal(PL, fs_new);

% S = fuse_data_parfor(notes,PL,US);
S = fuse_data(notes,PL,US,fs_new,interNoteInclSpec,pc.outsideNoteInclSpec);

S_parts = split_into_parts(S,fs_new);


%% Process derived variables

welcome('Processing derived variable','module')

S_parts = add_spatial_norms(S_parts,2,{'accA_x','accA_y','accA_z'},'accA_norm');
S_parts = add_spatial_norms(S_parts,2,{'accB_x','accB_y','accB_z'},'accB_norm');
% S_parts = add_spatial_norms(S_parts,2,{'i1','i2_shifted','i3_shifted'},'i_norm_shifted');
% S_parts = add_spatial_norms(S_parts,2,{'v1','v2_shifted','v3_shifted'},'v_norm_shifted');
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