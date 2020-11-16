%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
sequence = 'IV2_Seq2';
experiment_subdir = 'IV2_Seq2 - Water simulated HVAD thrombosis - Pilot';
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
spectrum_subdir = 'Recorded\M3\Blocks';
notes_subdir = 'Noted';

% Which files to input from input directory 
powerlab_fileNames = {
%     'IV2_Seq2 - B1.mat'
%      'IV2_Seq2 - B2.mat' 
%       'IV2_Seq2 - B3.mat' 
      %'IV2_Seq2 - B4.mat' % included in B5 by mistake 
      'IV2_Seq2 - B5.mat' 
      'IV2_Seq2 - B6.mat' 
    };
notes_fileName = 'IV2_Seq2 - Notes ver3.9 - Rev5';
ultrasound_fileNames = {
    'ECM_2020_01_08__11_06_21.wrf'
    'ECM_2020_01_09__16_14_36.wrf'
    'ECM_2020_01_09__17_05_19.wrf'
    'ECM_2020_01_14__11_41_39.wrf'
    'ECM_2020_01_14__13_34_12.wrf'
    'ECM_2020_01_20__12_36_17.wrf'
    'ECM_2020_01_22__12_59_46.wrf'
    'ECM_2020_01_22__15_50_05.wrf'
    };

% Add subdir specification to filename lists
[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,spectrum_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,powerlab_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Max frequency  Type        Continuity
    'Trykk1'         'affP'       1000           'single'    'continuous'
    'Trykk2'         'effP'       1000           'single'    'continuous'
    'SensorAAccX'    'accA_x'     700            'numeric'   'continuous'
    'SensorAAccY'    'accA_y'     700            'numeric'   'continuous'
    'SensorAAccZ'    'accA_z'     700            'numeric'   'continuous'
    };

%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

init_matlab
welcome('Initializing data','module')
if load_workspace; return; end

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(powerlab_filePaths,'',powerlab_variable_map);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_m3_raw_textfile(ultrasound_filePaths);
    
% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);



%% Pre-processing
% Transform and extract data for analysis
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency
% * Deriving new variables of:
%      part duration, moving RMS and moving standard deviation

notes = qc_notes(notes);

% Correct for unsync'ed M3 clock
unsync_inds = US.time>'22-Mar-2020 22:19:14.00' & US.time<'22-Mar-2020 22:52:13.00';
US.time(unsync_inds) = US.time(unsync_inds)+seconds(42);

S = fuse_data(notes,PL,US);
clear PL US

% Merge balloon level 0 into level 1 (as it actually was the same as level 1)
S.balloonLevel = mergecats(S.balloonLevel,{'0','1'},'1');

S_parts = split_into_parts(S);
clear S

feats = init_features_from_notes(notes);

S_parts = add_spatial_norms(S_parts,2);
S_parts = add_moving_statistics(S_parts);
S_parts = add_moving_statistics(S_parts,{'accA_x'});
S_parts = add_moving_statistics(S_parts,{'accA_z'});

% Maybe not a pre-processing thing
S_parts = add_harmonics_filtered_variables(S_parts);

% TODO:
% Add MPF, std, RMS and other statistics/indices into feats
% Revise categoric blocks, and put into feats
 
% % Muting of non-comparable data (due to wrong setting in LabChart) in baseline
S_parts{1}.gyrA = nan(height(S_parts{1}),3);
S_parts{1}.gyrA_norm = nan(height(S_parts{1}),1);
S_parts{1}.gyrA_norm_movRMS = nan(height(S_parts{1}),1);

ask_to_save({'S_parts','notes','feats'},sequence);

