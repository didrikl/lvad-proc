            
% Which experiment
seq = 'IV2_Seq12';
experiment_subdir = 'D:\Data\IVS\Didrik\IV2 - Data\Seq12 - LVAD11';

% Output folder structure
proc_subdir = 'Processed\';
proc_plot_subdir = 'Processed\Figures';
proc_stats_subdir = 'Processed\Statistics';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
labChart_fileNames = {
    'IV2_Seq12 - F1 [pEff,pAff].mat'
    'IV2_Seq12 - F1 [accA].mat'
%     'IV2_Seq12 - F1 [accB].mat'
    'IV2_Seq12 - F2 [pEff,pAff].mat'
    'IV2_Seq12 - F2 [accA].mat'
%     'IV2_Seq12 - F2 [accB].mat'
    'IV2_Seq12 - F3 [pEff,pAff].mat'
    'IV2_Seq12 - F3 [accA].mat'
%     'IV2_Seq12 - F3 [accB].mat'
    'IV2_Seq12 - F4 [pEff,pAff].mat'
    'IV2_Seq12 - F4 [accA].mat'
%     'IV2_Seq12 - F4 [accB].mat'
    'IV2_Seq12 - F5 [pEff,pAff].mat'
    'IV2_Seq12 - F5 [accA].mat'
%     'IV2_Seq12 - F5 [accB].mat'
    'IV2_Seq12 - F6 [pEff,pAff].mat'
    'IV2_Seq12 - F6 [accA].mat'
%     'IV2_Seq12 - F6 [accB].mat'
    'IV2_Seq12 - F7 [pEff,pAff].mat'
    'IV2_Seq12 - F7 [accA].mat'
%     'IV2_Seq12 - F7 [accB].mat'
   'IV2_Seq12 - F8 [pEff,pAff].mat'
    'IV2_Seq12 - F8 [accA].mat'
%     'IV2_Seq12 - F8 [accB].mat'
    'IV2_Seq12 - F9 [pEff,pAff].mat'
    'IV2_Seq12 - F9 [accA].mat'
%     'IV2_Seq12 - F9 [accB].mat'
    'IV2_Seq12 - F10 [pEff,pAff].mat'
    'IV2_Seq12 - F10 [accA].mat'
%     'IV2_Seq12 - F10 [accB].mat'
    'IV2_Seq12 - F11 [pEff,pAff].mat'
    'IV2_Seq12 - F11 [accA].mat'
%     'IV2_Seq12 - F11 [accB].mat'
    'IV2_Seq12 - F12 [pEff,pAff].mat'
    'IV2_Seq12 - F12 [accA].mat'
%     'IV2_Seq12 - F12 [accB].mat'
    'IV2_Seq12 - F13 [pEff,pAff].mat'
    'IV2_Seq12 - F13 [accA].mat'
%     'IV2_Seq12 - F13 [accB].mat'
    'IV2_Seq12 - F14 [pEff,pAff].mat'
    'IV2_Seq12 - F14 [accA].mat'
%     'IV2_Seq12 - F14 [accB].mat'
    'IV2_Seq12 - F15 [pEff,pAff].mat'
    'IV2_Seq12 - F15 [accA].mat'
%     'IV2_Seq12 - F15 [accB].mat'
    'IV2_Seq12 - F16 [pEff,pAff].mat'
    'IV2_Seq12 - F16 [accA].mat'
%     'IV2_Seq12 - F16 [accB].mat'
    'IV2_Seq12 - F17 [pEff,pAff].mat'
    'IV2_Seq12 - F17 [accA].mat'
%     'IV2_Seq12 - F17 [accB].mat'
    };
notes_fileName = 'IV2_Seq12 - Notes IV2 v1.0 - Rev5.xlsm';
ultrasound_fileNames = {
    'ECM_2020_09_08__13_18_56.wrf'
    'ECM_2020_09_09__11_46_35.wrf'
    'ECM_2020_09_10__15_40_40.wrf'
    };

fs_new = 750;
US_drifts = {20.5, 62, 3.5};
PL_offset = seconds(60);

%% Initialize
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

init_matlab
welcome(['Initialize ',seq],'module')

% Input file structure map
labChart_varMapFile = 'VarMap_LabChart_IV2';
systemM_varMapFile = 'VarMap_SystemM_IV2';
notes_varMapFile = 'VarMap_Notes_IV2_v1';

% Read PowerLab data in files exported from LabChart
pl_filePaths = fullfile(experiment_subdir,powerlab_subdir,labChart_fileNames);
PL = init_labchart_mat_files(pl_filePaths,'',labChart_varMapFile);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
us_filePaths  = fullfile(experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
US = init_system_m_text_files(us_filePaths,'',systemM_varMapFile);

% Read sequence notes made with Excel file template
notes_filePath = fullfile(experiment_subdir,notes_subdir,notes_fileName);
Notes = init_notes_xlsfile_ver4(notes_filePath,'',notes_varMapFile);

% Quality control and fixes
Notes = qc_notes_ver4(Notes);
US = adjust_for_system_m_time_drift(US,US_drifts);
PL_files_with_time_offset = {...
    'IV2_Seq12 - F7 [pEff,pAff].mat'
    'IV2_Seq12 - F7 [accA].mat'
%     'IV2_Seq12 - F7 [accB].mat'
   'IV2_Seq12 - F8 [pEff,pAff].mat'
    'IV2_Seq12 - F8 [accA].mat'
%     'IV2_Seq12 - F8 [accB].mat'
    'IV2_Seq12 - F9 [pEff,pAff].mat'
    'IV2_Seq12 - F9 [accA].mat'
%     'IV2_Seq12 - F9 [accB].mat'
    'IV2_Seq12 - F10 [pEff,pAff].mat'
    'IV2_Seq12 - F10 [accA].mat'
%     'IV2_Seq12 - F10 [accB].mat'
    'IV2_Seq12 - F11 [pEff,pAff].mat'
    'IV2_Seq12 - F11 [accA].mat'
%     'IV2_Seq12 - F11 [accB].mat'
    'IV2_Seq12 - F12 [pEff,pAff].mat'
    'IV2_Seq12 - F12 [accA].mat'
%     'IV2_Seq12 - F12 [accB].mat'
    'IV2_Seq12 - F13 [pEff,pAff].mat'
    'IV2_Seq12 - F13 [accA].mat'
%     'IV2_Seq12 - F13 [accB].mat'
    'IV2_Seq12 - F14 [pEff,pAff].mat'
    'IV2_Seq12 - F14 [accA].mat'
%     'IV2_Seq12 - F14 [accB].mat'
    'IV2_Seq12 - F15 [pEff,pAff].mat'
    'IV2_Seq12 - F15 [accA].mat'
%     'IV2_Seq12 - F15 [accB].mat'
    'IV2_Seq12 - F16 [pEff,pAff].mat'
    'IV2_Seq12 - F16 [accA].mat'
%     'IV2_Seq12 - F16 [accB].mat'
    };
PL = adjust_for_constant_time_offset(PL,PL_files_with_time_offset,PL_offset);

%% Pre-process
% * Data fusion into given frequency
% * Make regularily sampled timetables of each recording segment parts
% * Add derived/filtered variables in the regular timetables

welcome(['Preprocess ',seq],'module')

US = merge_table_blocks(US);
US = aggregate_effQ_and_affQ(US);

PL = resample_signal(PL, fs_new);

S = fuse_data(Notes,PL,US,fs_new,'nearest','none');
S_parts = split_into_parts(S,fs_new);

S_parts = add_spatial_norms(S_parts,2,{'accA_x','accA_y','accA_z'},'accA_norm');
%S_parts = add_spatial_norms(S_parts,2,{'accB_x','accB_y','accB_z'},'accB_norm');
S_parts = add_harmonics_filtered_variables(S_parts,...
    {'accA_norm','accA_x','accA_y','accA_z'}, 1:5, 1);

S = merge_table_blocks(S_parts);
S = reduce_to_analysis(S);


%% Round-up
% Store data
% Free up memory

S_analysis.(seq) = S;

proc_path = fullfile(experiment_subdir,proc_subdir);
save(fullfile(proc_path,[seq,'_S_parts']),'S_parts')
save(fullfile(proc_path,[seq,'_S']),'S')

clear S PL US
multiWaitbar('CloseAll');
fprintf(['\nInit ',seq,' done.\n'])