% Which experiment
seq = 'G1_Seq3';
experiment_subdir = 'Seq3 - LVAD6 - Pilot';
%sequence = 'Seq3 - LVAD6';

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% NOTE: Could be implemented to be selected interactively using uigetfiles
labChart_fileNames = {
    'G1_Seq3 - F1 [accA].mat'
    'G1_Seq3 - F1 [accB].mat'
    'G1_Seq3 - F1 [pGraft].mat'
    'G1_Seq3 - F2 [accA].mat'
    'G1_Seq3 - F2 [accB].mat'
    'G1_Seq3 - F2 [pGraft].mat'
    'G1_Seq3 - F3_Sel1 [accA].mat'
    'G1_Seq3 - F3_Sel1 [accB].mat'
    'G1_Seq3 - F3_Sel1 [pGraft].mat'
    'G1_Seq3 - F3_Sel2 [accA].mat'
    'G1_Seq3 - F3_Sel2 [accB].mat'
    'G1_Seq3 - F3_Sel2 [pGraft].mat'
    };
notes_fileName = 'G1_Seq3 - Notes G1 v1.0.0 - Rev6.xlsm';
ultrasound_fileNames = {
    'ECM_2020_09_17__12_26_32.wrf'
    };

% Override defaults
labChart_varMapFile = 'VarMap_LabChart_G1_Seq3';
systemM_varMapFile = 'VarMap_SystemM_G1_Seq3';
notes_varMapFile = 'VarMap_Notes_G1_v1_0_0'; %'VarMap_G1_Notes_Ver4p16';
pGradVars = {};

% Correction input
US_drifts = {50}; % Just an estimate based on previous drifts
US_drifts = {[]};
accChannelToSwap = {};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];
