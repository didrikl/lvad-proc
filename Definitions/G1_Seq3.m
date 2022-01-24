%% Sequence definitions and correction inputs

% ID
seq = 'G1_Seq3';

% Folder in base path
experiment_subdir = 'Seq3 - LVAD6 - Pilot';

% Which files to input from input directory 
labChart_fileNames = {
    'G1_Seq3 - F1 [accA].mat'
    %'G1_Seq3 - F1 [accB].mat'
    'G1_Seq3 - F1 [pGraft].mat'
    'G1_Seq3 - F2 [accA].mat'
    %'G1_Seq3 - F2 [accB].mat'
    'G1_Seq3 - F2 [pGraft].mat'
    'G1_Seq3 - F3_Sel1 [accA].mat'
    %'G1_Seq3 - F3_Sel1 [accB].mat'
    'G1_Seq3 - F3_Sel1 [pGraft].mat'
    'G1_Seq3 - F3_Sel2 [accA].mat'
    %'G1_Seq3 - F3_Sel2 [accB].mat'
    'G1_Seq3 - F3_Sel2 [pGraft].mat'
    };
notes_fileName = 'G1_Seq3 - Notes G1 v1.0.0 - Rev6.xlsm';
ultrasound_fileNames = {
    'ECM_2020_09_17__12_26_32.wrf'
    };

% Override defaults
labChart_varMapFile = 'VarMap_LabChart_G1_Seq3';
pGradVars = {};

% Correction input
US_drifts = {50}; % Just an estimate based on previous drifts
US_drifts = {[]};
accChannelToSwap = {};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];
