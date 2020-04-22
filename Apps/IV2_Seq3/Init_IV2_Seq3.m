%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
sequence = 'IV2_Seq3';
experiment_subdir = 'IV2_Seq3 - Water simulated HVAD thrombosis - Pre-pump - Pilot';
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
spectrum_subdir = 'Recorded\Spectrum\Blocks';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
%     'IV2_Seq3 - B1_Sel1_ch1-5.mat'
%     'IV2_Seq3 - B1_Sel2_ch1-5.mat'
%     'IV2_Seq3 - B1_Sel3_ch1-5.mat'
%     'IV2_Seq3 - B1_Sel4_ch1-5.mat'
    'IV2_Seq3 - B2_Sel1_ch1-5.mat'
    'IV2_Seq3 - B2_Sel2_ch1-5.mat'
     'IV2_Seq3 - B2_Sel3_ch1-5.mat'
%     'IV2_Seq3 - B2_Sel4_ch1-5.mat'
%     %'IV2_Seq3 - B3_ch1-5.mat'
%     'IV2_Seq3 - B4_ch1-5.mat'
%     %'IV2_Seq3 - B5_ch1-5.mat'
%     'IV2_Seq3 - B6_ch1-5.mat'
%     'IV2_Seq3 - B7_ch1-5.mat'
%     'IV2_Seq3 - B8_ch1-5.mat'
%     'IV2_Seq3 - B9_ch1-5.mat'
%     'IV2_Seq3 - B10_ch1-5.mat'
%     'IV2_Seq3 - B11_ch1-5.mat'
%     'IV2_Seq3 - B12_ch1-5.mat'
%     'IV2_Seq3 - B13_ch1-5.mat'
    };
notes_fileName = 'IV2_Seq3 - Notes ver3.9 - Rev3.xlsm';
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
    %'ECM_2020_04_01__22_15_22.wrf'
    'ECM_2020_04_01__22_15_22-shifted1Hour.wrf'
    };

% Add subdir specification to filename lists
[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,spectrum_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,powerlab_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);


%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

init_matlab
welcome('Initializing data','module')
if load_workspace({'S_parts','notes','feats'}); return; end

% Read PowerLab data in files exported from LabChart
PL = init_powerlab_raw_matfiles(powerlab_filePaths);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_m3_raw_textfile(ultrasound_filePaths);
    
% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

notes = qc_notes(notes);

% Correct for unsync'ed M3 clock
unsync_inds = US.time>'22-Mar-2020 22:19:14.00' & US.time<'22-Mar-2020 22:52:13.00';
US.time(unsync_inds) = US.time(unsync_inds)-seconds(42);

% Shift 1 hours due to summer daylight saving time
% unsync_inds = US.time>'01-Apr-2020 22:15:22.00' & US.time<'01-Apr-2020 23:12:53';
% US.time(unsync_inds) = US.time(unsync_inds)+hours(1);

feats = init_features_from_notes(notes);

S = fuse_data(notes,PL,US);
clear PL US

S_parts = split_into_parts(S);
clear S

S_parts = add_spatial_norms(S_parts,2);
S_parts = add_moving_statistics(S_parts);

S_parts = add_spatial_norms(S_parts,2,{'accA_x','accA_z'},'accA_xz_norm');
S_parts = add_moving_statistics(S_parts,{'accA_xz_norm'});

% Maybe not a pre-processing thing
S_parts = add_harmonics_filtered_variables(S_parts);

% TODO:
% Add MPF, std, RMS and other statistics/indices into feats
% Revise categoric blocks, and put into feats

ask_to_save({'S_parts','notes','feats'},sequence);
