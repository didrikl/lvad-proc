%% User inputs

% Which experiment
seq = 'IV2_Seq18';
experiment_subdir = 'Seq18 - LVAD14';

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
    'IV2_Seq18 - F1 [pEff,pAff].mat'
    'IV2_Seq18 - F1 [accA].mat'
%     'IV2_Seq18 - F1 [accB].mat'
    'IV2_Seq18 - F2 [pEff,pAff].mat'
    'IV2_Seq18 - F2 [accA].mat'    
%      'IV2_Seq18 - F2 [accB].mat'    
     'IV2_Seq18 - F3 [pEff,pAff].mat'
     'IV2_Seq18 - F3 [accA].mat'
%       'IV2_Seq18 - F3 [accB].mat'
     'IV2_Seq18 - F4 [pEff,pAff].mat'
     'IV2_Seq18 - F4 [accA].mat'
%       'IV2_Seq18 - F4 [accB].mat'
     'IV2_Seq18 - F5 [pEff,pAff].mat' 
     'IV2_Seq18 - F5 [accA].mat'      
%       'IV2_Seq18 - F5 [accB].mat'      
      'IV2_Seq18 - F6 [pEff,pAff].mat'
      'IV2_Seq18 - F6 [accA].mat'
%        'IV2_Seq18 - F6 [accB].mat'
     'IV2_Seq18 - F7 [pEff,pAff].mat'
     'IV2_Seq18 - F7 [accA].mat'
%       'IV2_Seq18 - F7 [accB].mat'
     'IV2_Seq18 - F8 [pEff,pAff].mat'
     'IV2_Seq18 - F8 [accA].mat'
%       'IV2_Seq18 - F8 [accB].mat'
     'IV2_Seq18 - F9 [pEff,pAff].mat'
     'IV2_Seq18 - F9 [accA].mat'
%       'IV2_Seq18 - F9 [accB].mat'
    };
notes_fileName = 'IV2_Seq18 - Notes IV2 v1.0 - Rev4.xlsm';
ultrasound_fileNames = {
    'ECM_2020_11_30__18_40_16.wrf'
    'ECM_2020_12_01__11_38_06.wrf'
    };

fs_new = 750;
US_drifts = {9, 55};
channelsToSwap = {'accA_y','accA_z'};
restrictBlockChannelSwap = [];


%% Initialize

Environment_Init_IV2
Init_Data_Raw
Init_Data_Preprocess
Init_Data_Save
Init_Data_Roundup