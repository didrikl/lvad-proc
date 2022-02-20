%% User inputs

% Experiment sequence ID
Config.seq = 'IV2_Seq13';
Config.seq_subdir = 'Seq13 - LVAD12';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
Config.labChart_fileNames = {
    'IV2_Seq13 - F1 [pEff,pAff].mat'
    'IV2_Seq13 - F1 [accA].mat'
%     'IV2_Seq13 - F1 [accB].mat'
    'IV2_Seq13 - F2 [pEff,pAff].mat'
    'IV2_Seq13 - F2 [accA].mat'
%     'IV2_Seq13 - F2 [accB].mat'
    'IV2_Seq13 - F3 [pEff,pAff].mat'
    'IV2_Seq13 - F3 [accA].mat'
%     'IV2_Seq13 - F3 [accB].mat'
    'IV2_Seq13 - F4 [pEff,pAff].mat'
    'IV2_Seq13 - F4 [accA].mat'
%     'IV2_Seq13 - F4 [accB].mat'
    'IV2_Seq13 - F5 [pEff,pAff].mat'
    'IV2_Seq13 - F5 [accA].mat'
%     'IV2_Seq13 - F5 [accB].mat'
    'IV2_Seq13 - F6 [pEff,pAff].mat'
    'IV2_Seq13 - F6 [accA].mat'
%     'IV2_Seq13 - F6 [accB].mat'
    'IV2_Seq13 - F7 [pEff,pAff].mat'
    'IV2_Seq13 - F7 [accA].mat'
%     'IV2_Seq13 - F7 [accB].mat'
    'IV2_Seq13 - F8 [pEff,pAff].mat'
    'IV2_Seq13 - F8 [accA].mat'
%     'IV2_Seq13 - F8 [accB].mat'
    'IV2_Seq13 - F9 [pEff,pAff].mat'
    'IV2_Seq13 - F9 [accA].mat'
%     'IV2_Seq13 - F9 [accB].mat'
    'IV2_Seq13 - F10 [pEff,pAff].mat'
    'IV2_Seq13 - F10 [accA].mat'
%     'IV2_Seq13 - F10 [accB].mat'
    'IV2_Seq13 - F11 [pEff,pAff].mat'
    'IV2_Seq13 - F11 [accA].mat'
%     'IV2_Seq13 - F11 [accB].mat'
    'IV2_Seq13 - F12 [pEff,pAff].mat'
    'IV2_Seq13 - F12 [accA].mat'
%     'IV2_Seq13 - F12 [accB].mat'
    'IV2_Seq13 - F13 [pEff,pAff].mat'
    'IV2_Seq13 - F13 [accA].mat'
%     'IV2_Seq13 - F13 [accB].mat'
    };
Config.notes_fileName = 'IV2_Seq13 - Notes IV2 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_09_11__12_30_59.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {52};
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {'p_eff','p_aff'};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};