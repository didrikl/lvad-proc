%% Initialze the processing environment and input file structure

init_matlab
welcome('Initializing data','module')

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
sequence = 'Seq5 - LVAD12 - Pilot';
pc.seq_subdir = 'G1 - Simulated pre-pump and in situ thrombosis\Seq5 - LVAD12';

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
pc.labChart_fileNames = {
    'G1_Seq5 - F0.mat'
    'G1_Seq5 - F1_Sel1.mat'
    'G1_Seq5 - F1_Sel2.mat'
    'G1_Seq5 - F1_Sel3.mat'
    };
pc.notes_fileName = 'G1_Seq5 - Notes ver4.13 - Rev2.xlsm';
pc.ultrasound_fileNames = {
%     'ECM_2020_10_15__11_20_40.wrf'
%     'ECM_2020_10_15__11_34_55.wrf'
};

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,pc.seq_subdir,ultrasound_subdir,pc.ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,pc.seq_subdir,powerlab_subdir,pc.labChart_fileNames);
notes_filePath = fullfile(basePath, pc.seq_subdir,notes_subdir,pc.notes_fileName);
proc_path = fullfile(basePath,pc.seq_subdir,'Processed');

powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    'pGraft'         'p_graft'      'single'    'continuous'
    %'Trykk2'         '...'        'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
%     'SensorBAccX'    'accB_x'      'single'    'continuous'
%      'SensorBAccY'    'accB_y'      'single'    'continuous'
%      'SensorBAccZ'    'accB_z'      'single'    'continuous'
    };

systemM_varMap = {
    % Name in Spectrum   Name in Matlab     SampleRate Type     Continuity   Units
    %'ArtflowLmin'        'effQ'            1          'single' 'continuous' 'L/min'
    'VenflowLmin'        'Q_graft'             1          'single' 'continuous' 'L/min'
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

%feats = init_features_from_notes(notes);

secsAhead = 0.0020*height(US); % Just an estimate based on previous drifts
US = adjust_for_linear_time_drift(US,secsAhead);

% S = fuse_data_parfor(notes,PL,US);
S = fuse_data(notes,PL,US);
S_parts = split_into_parts(S);


S_parts = add_spatial_norms(S_parts,2, {'accA_x','accA_y','accA_z'}, 'accA_norm');
S_parts = add_moving_statistics(S_parts,{'accA_norm','accA_x','accA_y','accA_z'});

S_parts = add_spatial_norms(S_parts, 2, {'accB_x','accB_y','accB_z'}, 'accB_norm');
S_parts = add_moving_statistics(S_parts,{'accB_norm'});

S_parts = add_moving_statistics(S_parts,{'p_graft'});

% Fpass = ([2400]/60)-1;
% Fs = 700;
% for i=1:3
%     S_parts{i}.accA_normHighPass = highpass(S_parts{i}.accA_norm,Fpass(i),Fs);
% end
% S_parts = add_moving_statistics(S_parts,{'accA_normHighPass'});

% QC of pressure
% ol_ind = S_parts{5}.p_graft>3*S_parts{5}.p_graft_movAvg;


% TODO:
% Add MPF, std, RMS and other statistics/indices into feats
% Revise categoric blocks, and put into feats

%ask_to_save({'S_parts','notes','feats'},sequence,proc_path);
ask_to_save({'S_parts','notes'},sequence,proc_path);
