%% User inputs

% Experiment sequence ID
seq = 'IV2_Seq14';
seq_subdir = 'Seq14 - LVAD7';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
labChart_fileNames = {
    'IV2_Seq14 - F1 [pEff,pAff].mat'
    'IV2_Seq14 - F1 [accA].mat'
%     'IV2_Seq14 - F1 [accB].mat'
    'IV2_Seq14 - F2 [pEff,pAff].mat'
    'IV2_Seq14 - F2 [accA].mat'
%     'IV2_Seq14 - F2 [accB].mat'
    'IV2_Seq14 - F3 [pEff,pAff].mat'
    'IV2_Seq14 - F3 [accA].mat'
%     'IV2_Seq14 - F3 [accB].mat'
    'IV2_Seq14 - F4 [pEff,pAff].mat'
    'IV2_Seq14 - F4 [accA].mat'
%     'IV2_Seq14 - F4 [accB].mat'
    'IV2_Seq14 - F5 [pEff,pAff].mat'
    'IV2_Seq14 - F5 [accA].mat'
%     'IV2_Seq14 - F5 [accB].mat'
    'IV2_Seq14 - F6 [pEff,pAff].mat'
    'IV2_Seq14 - F6 [accA].mat'
%     'IV2_Seq14 - F6 [accB].mat'
    'IV2_Seq14 - F7 [pEff,pAff].mat'
    'IV2_Seq14 - F7 [accA].mat'
%     'IV2_Seq14 - F7 [accB].mat'
    'IV2_Seq14 - F8 [pEff,pAff].mat'
    'IV2_Seq14 - F8 [accA].mat'
%     'IV2_Seq14 - F8 [accB].mat'
    'IV2_Seq14 - F9 [pEff,pAff].mat'
    'IV2_Seq14 - F9 [accA].mat'
%     'IV2_Seq14 - F9 [accB].mat'
    'IV2_Seq14 - F10 [pEff,pAff].mat'
    'IV2_Seq14 - F10 [accA].mat'
%     'IV2_Seq14 - F10 [accB].mat'
    'IV2_Seq14 - F11 [pEff,pAff].mat'
    'IV2_Seq14 - F11 [accA].mat'
%     'IV2_Seq14 - F11 [accB].mat'
    };
notes_fileName = 'IV2_Seq14 - Notes IV2 v1.0.0 - Rev4.xlsm';
ultrasound_fileNames = {
    'ECM_2020_09_12__18_18_23.wrf'
    'ECM_2020_09_14__11_45_57.wrf'
    };

% Correction input
pc.US_offsets = {};
pc.US_drifts = {14, 42};
pc.accChannelToSwap = {'accA_y','accA_z'};
pc.blocksForAccChannelSwap = [];
pc.pChannelToSwap = {};
pc.pChannelSwapBlocks = [];
pc.PL_offset = [];
pc.PL_offset_files = {};