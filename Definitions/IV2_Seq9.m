            
% Which experiment
seq = 'IV2_Seq9';
experiment_subdir = 'Seq9 - LVAD6';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
labChart_fileNames = {
    'IV2_Seq9 - F1 [pEff,pAff].mat'
    'IV2_Seq9 - F1 [accA].mat'
%     'IV2_Seq9 - F1 [accB].mat'
    'IV2_Seq9 - F2 [pEff,pAff].mat'
    'IV2_Seq9 - F2 [accA].mat'
%     'IV2_Seq9 - F2 [accB].mat'
    'IV2_Seq9 - F3 [accA].mat'
%     'IV2_Seq9 - F3 [accB].mat'
    'IV2_Seq9 - F3 [pEff,pAff].mat'
    'IV2_Seq9 - F4 [accA].mat'
%     'IV2_Seq9 - F4 [accB].mat'
    'IV2_Seq9 - F4 [pEff,pAff].mat'
    'IV2_Seq9 - F5 [accA].mat'
%     'IV2_Seq9 - F5 [accB].mat'
    'IV2_Seq9 - F5 [pEff,pAff].mat'
    'IV2_Seq9 - F6 [accA].mat'
%     'IV2_Seq9 - F6 [accB].mat'
    'IV2_Seq9 - F6 [pEff,pAff].mat'
    'IV2_Seq9 - F7 [pEff,pAff].mat'
    'IV2_Seq9 - F7 [accA].mat'
%     'IV2_Seq9 - F7 [accB].mat'
    'IV2_Seq9 - F8 [pEff,pAff].mat'
    'IV2_Seq9 - F8 [accA].mat'
%     'IV2_Seq9 - F8 [accB].mat'
    'IV2_Seq9 - F9 [pEff,pAff].mat'
    'IV2_Seq9 - F9 [accA].mat'
%     'IV2_Seq9 - F9 [accB].mat'
    'IV2_Seq9 - F10 [pEff,pAff].mat'
    'IV2_Seq9 - F10 [accA].mat'
%     'IV2_Seq9 - F10 [accB].mat'
    'IV2_Seq9 - F11 [pEff,pAff].mat'
    'IV2_Seq9 - F11 [accA].mat'
%     'IV2_Seq9 - F11 [accB].mat'
    'IV2_Seq9 - F12 [pEff,pAff].mat'
    'IV2_Seq9 - F12 [accA].mat'
%     'IV2_Seq9 - F12 [accB].mat'
    'IV2_Seq9 - F13 [pEff,pAff].mat'
    'IV2_Seq9 - F13 [accA].mat'
%     'IV2_Seq9 - F13 [accB].mat'
    };
notes_fileName = 'IV2_Seq9 - Notes IV2 v1.0.0 - Rev3.xlsm';
ultrasound_fileNames = {
    'ECM_2020_08_31__12_20_52.wrf'
    'ECM_2020_08_31__14_33_40.wrf'
    'ECM_2020_09_01__11_04_20.wrf'
    };

% Correction input
US_drifts = {[], [], 45};
accChannelToSwap = {'accA_y','accA_z'};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];
