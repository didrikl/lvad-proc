%% Initialze the processing environment and input file structure
% Add all subfolders to path. To be removed as it gives less control compared to importing packages

% Use code in packages with subfolders prefixed with a '+'
% import Initialize.*
% import Calculate.*
% import Analyze.*
% import Tools.*
init_matlab

% Which experiment
experiment_subdir    = 'IV2_Seq3 - Water simulated HVAD thrombosis - Pre-pump - Pilot';

% Directory structure
powerlab_subdir = 'PowerLab';
spectrum_subdir = 'Spectrum\Blocks';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
    'IV2_Seq3 - B1_Sel1_ch1-5.mat'
    'IV2_Seq3 - B1_Sel2_ch1-5.mat'
    'IV2_Seq3 - B1_Sel3_ch1-5.mat'
    'IV2_Seq3 - B1_Sel4_ch1-5.mat'
    'IV2_Seq3 - B2_Sel1_ch1-5.mat'
    'IV2_Seq3 - B2_Sel2_ch1-5.mat'
    'IV2_Seq3 - B2_Sel3_ch1-5.mat'
    'IV2_Seq3 - B2_Sel4_ch1-5.mat'
    'IV2_Seq3 - B3_ch1-5.mat'
    'IV2_Seq3 - B4_ch1-5.mat'
    'IV2_Seq3 - B5_ch1-5.mat'
    'IV2_Seq3 - B6_ch1-5.mat'
    'IV2_Seq3 - B7_ch1-5.mat'
    'IV2_Seq3 - B8_ch1-5.mat'
    'IV2_Seq3 - B9_ch1-5.mat'
    'IV2_Seq3 - B10_ch1-5.mat'
    'IV2_Seq3 - B11_ch1-5.mat'
    'IV2_Seq3 - B12_ch1-5.mat'
    };
notes_fileName = 'IV2_Seq3 - Notes ver3.8 - Rev1.xlsm';
ultrasound_fileNames = {                         
    'ECM_2020_03_17__17_01_50.wrf'
    'ECM_2020_03_18__18_33_45.wrf'
    'ECM_2020_03_19__19_03_38.wrf'
    'ECM_2020_03_19__20_34_11.wrf'
    'ECM_2020_03_20__20_05_59.wrf'
    'ECM_2020_03_20__20_57_04.wrf'
    'ECM_2020_03_22__22_19_15.wrf'
    'ECM_2020_03_23__18_25_13.wrf'
    'ECM_2020_03_24__22_38_46.wrf'
    'ECM_2020_03_26__01_51_14.wrf'
    'ECM_2020_03_26__01_54_55.wrf'
    'ECM_2020_03_26__21_31_35.wrf'
    'ECM_2020_03_26__21_54_23.wrf'
    'ECM_2020_03_26__22_13_44.wrf'
    };

% Settings for Matlab
[raw_basePath, proc_basePath] = init_io_paths(experiment_subdir);

% Add subdir specification to filename lists
ultrasound_fileNames  = fullfile(spectrum_subdir,ultrasound_fileNames);
powerlab_fileNames = fullfile(powerlab_subdir,powerlab_fileNames);
notes_filePath = fullfile(notes_subdir,notes_fileName);


%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

% Sample rate for re-sampling down to highest signal content frequency 
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

S = fuse_data(notes,PL,US);

% ...syncing here, if needed...

S_parts = preprocess_sequence_parts(S, sampleRate);

% Saving memory:
clear S PL US








