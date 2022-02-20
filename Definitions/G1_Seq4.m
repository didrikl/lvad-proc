%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1_Seq4';

% Folder in base path
Config.seq_subdir = 'Seq4 - LVAD9 - Terminated';

% Which files to input from input directory 
Config.labChart_fileNames = {
    'G1_Seq4 - F1.mat'
    'G1_Seq4 - F2.mat'
    };
Config.notes_fileName = 'G1_Seq4 - Notes ver4.10 - Rev2.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_10_08__12_30_15.wrf'
};

% Correction input
Config.US_offsets = {};
Config.US_drifts = {[]}; 
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};
