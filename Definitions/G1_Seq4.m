%% Sequence definitions and correction inputs

% Experiment sequence ID
seq = 'G1_Seq4';

% Folder in base path
experiment_subdir = 'Seq4 - LVAD9 - Terminated';

% Which files to input from input directory 
labChart_fileNames = {
    'G1_Seq4 - F1.mat'
    'G1_Seq4 - F2.mat'
    };
notes_fileName = 'G1_Seq4 - Notes ver4.10 - Rev2.xlsm';
ultrasound_fileNames = {
    'ECM_2020_10_08__12_30_15.wrf'
};

% Correction input
US_offsets = {};
US_drifts = {[]}; 
accChannelToSwap = {};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];
PL_offset = [];
PL_offset_files = {};
