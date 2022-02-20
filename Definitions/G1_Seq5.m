%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1_Seq5';

% Folder in base path
Config.seq_subdir = 'Seq5 - LVAD12 - Terminated';

% Which files to input from input directory 
Config.labChart_fileNames = {
    'G1_Seq5 - F0.mat'
    'G1_Seq5 - F1_Sel1.mat'
    'G1_Seq5 - F1_Sel2.mat'
    'G1_Seq5 - F1_Sel3.mat'
    };
Config.notes_fileName = 'G1_Seq5 - Notes ver4.13 - Rev2.xlsm';
Config.ultrasound_fileNames = {
     'ECM_2020_10_15__11_20_40.wrf'
     'ECM_2020_10_15__11_34_55.wrf'
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

