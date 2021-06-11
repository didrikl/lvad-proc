            
% Which experiment
seq = 'IV2_Seq12';
experiment_subdir = 'Seq12 - LVAD11';

% Output folder structure
proc_subdir = 'Processed\';
proc_plot_subdir = 'Figures';
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
notes_fileName = 'IV2_Seq12 - Notes IV2 v1.0 - Rev7.xlsm';
ultrasound_fileNames = {
    'ECM_2020_09_08__13_18_56.wrf'
    'ECM_2020_09_09__11_46_35.wrf'
    'ECM_2020_09_10__15_40_40.wrf'
    };

fs_new = 750;

US_drifts = {20.5, 62, 3.5};
PL_offset = seconds(60);
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

channelsToSwap = {'accA_y','accA_z'};
restrictBlockChannelSwap = [];

%% Initialize

Environment_Init_IV2
Init_Data_Raw
PL = adjust_for_constant_time_offset(PL,PL_files_with_time_offset,PL_offset);
Init_Data_Preprocess
Init_Data_Save
Init_Data_Roundup
