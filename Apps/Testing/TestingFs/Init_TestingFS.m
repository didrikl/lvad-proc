%% Initialze the processing environment and input file structure
% Add all subfolders to path. To be removed as it gives less control compared to importing packages

% Use code in packages with subfolders prefixed with a '+'
% import Initialize.*
% import Calculate.*
% import Analyze.*
% import Tools.*
init_matlab


%% Initilize data from TestingFs

% Which experiment
raw_basePath    = 'C:\Data\IVS\Didrik\Temp\recordingTesting';
testFs_notes_fileName = 'Noted\testFs - Notes ver3.5 - Rev1.xlsm';
powerlab_fileNames = {
    'testingFS - B1.mat' % 1000 Hz
    'testingFS - B2.mat' % 2000 Hz
    };
powerlab_fileNames = fullfile('Recorded','PowerLab',powerlab_fileNames);

testFs_sampleRate = 1000;

testFs_PL = init_labchart_mat_files(powerlab_fileNames,raw_basePath);
testFs_notes = init_notes_xlsfile_v3_2(testFs_notes_fileName,raw_basePath);

%% Pre-processing of data from IV2_Seq1

testFs_S = fuse_data(testFs_notes,testFs_PL);
testFs_S_parts = split_into_parts(testFs_S, testFs_sampleRate);


%% Initilize data from IV2_Seq1

% Which experiment
IV2_Seq1_subdir    = 'IV2_Seq2 - Water simulated HVAD thrombosis - Pre-pump - Pilot';
spectrum_subdir = 'Spectrum\Blocks';
notes_subdir = 'Noted';

powerlab_fileNames = {
    'IV2_Seq2 - B1.mat'
     'IV2_Seq2 - B2.mat' 
      'IV2_Seq2 - B3.mat' 
      ...'IV2_Seq2 - B5.mat' 
      ...'IV2_Seq2 - B6.mat' 
    };
IV2S1_notes_fileName = 'IV2_Seq2 - Notes ver3.5 - Rev4.xlsm';
IV2S1_ultrasound_fileNames = {
    'ECM_2020_01_08__11_06_21.wrf'
    'ECM_2020_01_09__16_14_36.wrf'
    'ECM_2020_01_09__17_05_19.wrf'
    'ECM_2020_01_14__11_41_39.wrf'
    'ECM_2020_01_14__13_34_12.wrf'
    ...'ECM_2020_01_20__12_36_17.wrf'
    ...'ECM_2020_01_22__12_59_46.wrf'
    ...'ECM_2020_01_22__15_50_05.wrf'
    };

[raw_basePath, proc_basePath] = init_io_paths(IV2_Seq1_subdir);
IV2S1_ultrasound_fileNames  = fullfile(spectrum_subdir,IV2S1_ultrasound_fileNames);
powerlab_fileNames = fullfile('PowerLab',powerlab_fileNames);
notes_filePath = fullfile(notes_subdir,IV2S1_notes_fileName);

IV2S1_sampleRate = 1000;

IV2S1_PL = init_labchart_mat_files(powerlab_fileNames,raw_basePath);
IV2S1_US = init_system_m_text_files(IV2S1_ultrasound_fileNames,raw_basePath);
IV2S1_notes = init_notes_xlsfile_v3_2(notes_filePath);

%% Pre-processing of data from IV2_Seq1

IV2S1_S = fuse_data(IV2S1_notes,IV2S1_PL,IV2S1_US);
IV2S1_S_parts = split_into_parts(IV2S1_S, IV2S1_sampleRate);


%% Initilize data from IV1_Seq1

IV1S1_path = 'C:\Data\IVS\Didrik\IV1_Seq1 - Thrombi injection into HVAD';
IV1S1_accA_fileName = 'Recorded\Cardiaccs\Surface\monitor-20181207-154327.txt';
IV1S1_accB_fileName = 'Recorded\Cardiaccs\Teguar\monitor-20181207-153752.txt';
IV1S1_notes_fileName = 'Noted\IV1 - Seq1 - Notes.xlsx';
accVarName = 'accA';

IV1S1_accA = init_cardiaccs_raw_txtfile(IV1S1_accA_fileName,IV1S1_path,'accA');
IV1S1_accB = init_cardiaccs_raw_txtfile(IV1S1_accB_fileName,IV1S1_path,'accA');
IV1_Seq1_notes = init_notes_xlsfile(IV1S1_notes_fileName,IV1S1_path);


%%  Pre-processing of data from IV1_Seq1

IV1S1_SA = fuse_data(IV1_Seq1_notes,IV1S1_accA);
IV1S1_SA_parts = split_into_parts(IV1S1_SA, 540);

% Manual sync of the two tables
ts_start_diff = IV1S1_accB.time(1) - IV1S1_accA.time(1);
IV1S1_accB.time = IV1S1_accB.time - ts_start_diff;
lvad_signal_sync_point = datetime('7-Dec-2018 17:24:12.865','InputFormat','dd-MMM-yyyy HH:mm:ss.SSS','Format','dd-MMM-uuuu HH:mm:ss.SSS');
lead_signal_sync_point = datetime('7-Dec-2018 17:29:49.540','InputFormat','dd-MMM-yyyy HH:mm:ss.SSS','Format','dd-MMM-uuuu HH:mm:ss.SSS');
ts_data_diff = lead_signal_sync_point - lvad_signal_sync_point;
IV1S1_accB.time = IV1S1_accB.time - ts_data_diff;

IV1S1_SB = fuse_data(IV1_Seq1_notes,IV1S1_accB);
IV1S1_SB_parts = split_into_parts(IV1S1_SB, 540);



