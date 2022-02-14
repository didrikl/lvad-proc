%% Sequence definitions and correction inputs

% Experiment sequence ID
pc.seq = 'G1_Seq4';

% Folder in base path
pc.seq_subdir = 'Seq4 - LVAD9 - Terminated';

% Which files to input from input directory 
pc.labChart_fileNames = {
    'G1_Seq4 - F1.mat'
    'G1_Seq4 - F2.mat'
    };
pc.notes_fileName = 'G1_Seq4 - Notes ver4.10 - Rev2.xlsm';
pc.ultrasound_fileNames = {
    'ECM_2020_10_08__12_30_15.wrf'
};

% Correction input
pc.US_offsets = {};
pc.US_drifts = {[]}; 
pc.accChannelToSwap = {};
pc.blocksForAccChannelSwap = [];
pc.pChannelToSwap = {};
pc.pChannelSwapBlocks = [];
pc.PL_offset = [];
pc.PL_offset_files = {};
