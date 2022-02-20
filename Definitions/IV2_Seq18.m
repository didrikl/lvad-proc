%% User inputs

% Experiment sequence ID
Config.seq = 'IV2_Seq18';
Config.seq_subdir = 'Seq18 - LVAD14';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
Config.labChart_fileNames = {
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
Config.notes_fileName = 'IV2_Seq18 - Notes IV2 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_11_30__18_40_16.wrf'
    'ECM_2020_12_01__11_38_06.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {9, 55};
Config.accChannelToSwap = {'accA_y','accA_z'};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};