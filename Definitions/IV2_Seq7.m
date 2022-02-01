            
% Experiment sequence ID
seq = 'IV2_Seq7';
experiment_subdir = 'Seq7 - LVAD1';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
labChart_fileNames = {
    'IV2_Seq7 - F1 [pEff,pAff].mat'
    'IV2_Seq7 - F1 [accA].mat'
%     'IV2_Seq7 - F1 [accB].mat'
    'IV2_Seq7 - F2 [pEff,pAff].mat'
    'IV2_Seq7 - F2 [accA].mat'
%     'IV2_Seq7 - F2 [accB].mat'
    'IV2_Seq7 - F3 [pEff,pAff].mat'
    'IV2_Seq7 - F3 [accA].mat'
%     'IV2_Seq7 - F3 [accB].mat'
    'IV2_Seq7 - F4 [pEff,pAff].mat'
    'IV2_Seq7 - F4 [accA].mat'
%     'IV2_Seq7 - F4 [accB].mat'
    'IV2_Seq7 - F5 [pEff,pAff].mat'
    'IV2_Seq7 - F5 [accA].mat'
%     'IV2_Seq7 - F5 [accB].mat'
    'IV2_Seq7 - F6 [pEff,pAff].mat'
    'IV2_Seq7 - F6 [accA].mat'
%     'IV2_Seq7 - F6 [accB].mat'
    'IV2_Seq7 - F7 [pEff,pAff].mat'
    'IV2_Seq7 - F7 [accA].mat'
%     'IV2_Seq7 - F7 [accB].mat'
    'IV2_Seq7 - F8 [pEff,pAff].mat'
    'IV2_Seq7 - F8 [accA].mat'
%     'IV2_Seq7 - F8 [accB].mat'
    'IV2_Seq7 - F9 [pEff,pAff].mat'
    'IV2_Seq7 - F9 [accA].mat'
%     'IV2_Seq7 - F9 [accB].mat'
    'IV2_Seq7 - F10 [pEff,pAff].mat'
    'IV2_Seq7 - F10 [accA].mat'
%     'IV2_Seq7 - F10 [accB].mat'
    'IV2_Seq7 - F11 [pEff,pAff].mat'
    'IV2_Seq7 - F11 [accA].mat'
%     'IV2_Seq7 - F11 [accB].mat'
    'IV2_Seq7 - F12 [pEff,pAff].mat'
    'IV2_Seq7 - F12 [accA].mat'
%     'IV2_Seq7 - F12 [accB].mat'
    'IV2_Seq7 - F13 [pEff,pAff].mat'
    'IV2_Seq7 - F13 [accA].mat'
%     'IV2_Seq7 - F13 [accB].mat'
    'IV2_Seq7 - F14 [pEff,pAff].mat'
    'IV2_Seq7 - F14 [accA].mat'
%     'IV2_Seq7 - F14 [accB].mat'
    'IV2_Seq7 - F15 [pEff,pAff].mat'
    'IV2_Seq7 - F15 [accA].mat'
%     'IV2_Seq7 - F15 [accB].mat'
    'IV2_Seq7 - F16 [pEff,pAff].mat'
    'IV2_Seq7 - F16 [accA].mat'
%     'IV2_Seq7 - F16 [accB].mat'
    };
notes_fileName = 'IV2_Seq7 - Notes IV2 v1.0.0 - Rev5.xlsm';
ultrasound_fileNames = {
    'ECM_2020_08_19__13_04_02.wrf'
    'ECM_2020_08_19__13_28_05.wrf'
    'ECM_2020_08_20__12_11_36.wrf'
    'ECM_2020_09_12__15_08_02.wrf'  
    };

% Correction input
US_offsets = {};
US_drifts = {3, 33.5, 46, []};
accChannelToSwap = {'accA_y','accA_z'};
blocksForAccChannelSwap = [14:16];
pChannelToSwap = {};
pChannelSwapBlocks = [];
PL_offset = [];
PL_offset_files = {};