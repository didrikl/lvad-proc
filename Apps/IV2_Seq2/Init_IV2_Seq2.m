%% Initialze the processing environment and input file structure
% Add all subfolders to path. To be removed as it gives less control compared to importing packages

% Use code in packages with subfolders prefixed with a '+'
% import Initialize.*
% import Calculate.*
% import Analyze.*
% import Tools.*
init_matlab

% Which experiment
experiment_subdir    = 'IV2_Seq2 - Water simulated HVAD thrombosis - Pre-pump - Pilot';

% Directory structure
powerlab_subdir = 'PowerLab';
spectrum_subdir = 'Spectrum\Blocks';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
    'IV2_Seq2 - B1.mat'
     'IV2_Seq2 - B2.mat' 
      'IV2_Seq2 - B3.mat' 
      %'IV2_Seq2 - B4.mat' % included in B5 by mistake 
      'IV2_Seq2 - B5.mat' 
      'IV2_Seq2 - B6.mat' 
    };
notes_fileName = 'IV2_Seq2 - Notes ver3.5 - Rev4.xlsm';
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

% Settings for Matlab
[raw_basePath, proc_basePath] = init_io_paths(experiment_subdir);

% Add subdir specification to filename lists
ultrasound_fileNames  = fullfile(spectrum_subdir,ultrasound_fileNames);
powerlab_fileNames = fullfile(powerlab_subdir,powerlab_fileNames);
notes_filePath = fullfile(notes_subdir,notes_fileName);


% TODO: Make OO, list files and ask for which version to use
% [notes_filePath] = init_notes(experiment_subdir);
% [pl_filePath] = init_powerlab(experiment_subdir);
% [ul_filePath] = init_spectrum(experiment_subdir);
% [cardiaccs_filePath] = init_cardiaccs(experiment_subdir);

%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files as blocks, stored as into
%   cell arrays
% * Read notes from Excel file

sampleRate = 700;

% Read PowerLab data in files exported from LabChart
PL = init_powerlab_raw_matfiles(powerlab_fileNames,raw_basePath);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_m3_raw_textfile(ultrasound_fileNames,raw_basePath);
    
% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_v3_2(notes_filePath);
feats = init_features_from_notes(notes);


%% Pre-processing
% Transform and extract data for analysis
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency
% * Deriving new variables of:
%      part duration, moving RMS and moving standard deviation

S = fuse_data(notes,PL,US);

% ...syncing here, if needed...

S_parts = split_into_parts(S);

% Muting of non-comparable data (due to wrong setting in LabChart) in baseline
S_parts{1}.gyrA = nan(height(S_parts{1}),3);
S_parts{1}.gyrA_norm = nan(height(S_parts{1}),1);
S_parts{1}.gyrA_norm_movRMS = nan(height(S_parts{1}),1);









