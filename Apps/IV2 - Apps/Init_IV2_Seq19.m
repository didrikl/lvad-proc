%% User inputs

% Which experiment
seq = 'IV2_Seq19';
experiment_subdir = 'Seq19 - LVAD13';

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
    'IV2_Seq19 - F1 [pEff,pAff].mat'
    'IV2_Seq19 - F1 [accA].mat'
%     'IV2_Seq19 - F1 [accB].mat'
%     % 'IV2_Seq19 - F2 [pEff,pAff].mat' % Overlapping with F3 block
%     % 'IV2_Seq19 - F2 [accA].mat'      % Overlapping with F3 block
%     % 'IV2_Seq19 - F2 [accB].mat'      % Overlapping with F3 block
     'IV2_Seq19 - F3 [pEff,pAff].mat'
     'IV2_Seq19 - F3 [accA].mat'
%      'IV2_Seq19 - F3 [accB].mat'
     'IV2_Seq19 - F4 [pEff,pAff].mat'
     'IV2_Seq19 - F4 [accA].mat'
%      'IV2_Seq19 - F4 [accB].mat'
%    % 'IV2_Seq19 - F5 [accA].mat'      % Overlapping with F6 block
%    % 'IV2_Seq19 - F5 [accB].mat'      % Overlapping with F6 block
%    % 'IV2_Seq19 - F5 [pEff,pAff].mat' % Overlapping with F6 block
      'IV2_Seq19 - F6 [pEff,pAff].mat'
      'IV2_Seq19 - F6 [accA].mat'
%       'IV2_Seq19 - F6 [accB].mat'
     'IV2_Seq19 - F7 [pEff,pAff].mat'
     'IV2_Seq19 - F7 [accA].mat'
%      'IV2_Seq19 - F7 [accB].mat'
     'IV2_Seq19 - F8 [pEff,pAff].mat'
     'IV2_Seq19 - F8 [accA].mat'
%      'IV2_Seq19 - F8 [accB].mat'
     'IV2_Seq19 - F9 [pEff,pAff].mat'
     'IV2_Seq19 - F9 [accA].mat'
%      'IV2_Seq19 - F9 [accB].mat'
      'IV2_Seq19 - F10 [pEff,pAff].mat'
      'IV2_Seq19 - F10 [accA].mat'
%       'IV2_Seq19 - F10 [accB].mat'
     'IV2_Seq19 - F11 [pEff,pAff].mat'
     'IV2_Seq19 - F11 [accA].mat'
%      'IV2_Seq19 - F11 [accB].mat'
     'IV2_Seq19 - F12 [pEff,pAff].mat'
     'IV2_Seq19 - F12 [accA].mat'
%      'IV2_Seq19 - F12 [accB].mat'
     'IV2_Seq19 - F13 [pEff,pAff].mat'
     'IV2_Seq19 - F13 [accA].mat'
%      'IV2_Seq19 - F13 [accB].mat'
    };
notes_fileName = 'IV2_Seq19 - Notes IVS v1.0 - Rev4.xlsm';
ultrasound_fileNames = {
    'ECM_2020_12_05__16_12_22.wrf'
    'ECM_2020_12_07__14_54_33.wrf'
    'ECM_2020_12_08__13_31_21.wrf'
    };

fs_new = 750;
US_drifts = {8, 36, 30};
channelsToSwap = {};
restrictBlockChannelSwap = [];

%% Initialize

Environment_Init_IV2
Init_Data_Raw
Init_Data_Preprocess
Init_Data_Save
Init_Data_Roundup