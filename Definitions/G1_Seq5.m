%% Sequence definitions and correction inputs

% Experiment sequence ID
seq = 'G1_Seq5';

% Folder in base path
seq_subdir = 'Seq5 - LVAD12 - Terminated';

% Which files to input from input directory 
labChart_fileNames = {
    'G1_Seq5 - F0.mat'
    'G1_Seq5 - F1_Sel1.mat'
    'G1_Seq5 - F1_Sel2.mat'
    'G1_Seq5 - F1_Sel3.mat'
    };
notes_fileName = 'G1_Seq5 - Notes ver4.13 - Rev2.xlsm';
ultrasound_fileNames = {
     'ECM_2020_10_15__11_20_40.wrf'
     'ECM_2020_10_15__11_34_55.wrf'
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

