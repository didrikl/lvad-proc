%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1_Seq13';

% Folder in base path
Config.seq_subdir = 'Seq13 - LVAD16';

% Which files to input from input directory
Config.labChart_fileNames = {
    'G1_Seq13 - F1 [accA].mat'
    %'G1_Seq13 - F1 [accB].mat'
    'G1_Seq13 - F1 [pGraft,ECG,pLV].mat'
    %'G1_Seq13 - F1 [V1,V2,V3].mat'
    %'G1_Seq13 - F1 [I1,I2,I3].mat'
    'G1_Seq13 - F2 [accA].mat'
    %'G1_Seq13 - F2 [accB].mat'
    'G1_Seq13 - F2 [pGraft,ECG,pLV].mat'
    %'G1_Seq13 - F2 [V1,V2,V3].mat'
    %'G1_Seq13 - F2 [I1,I2,I3].mat'
    'G1_Seq13 - F3 [accA].mat'
    %'G1_Seq13 - F3 [accB].mat'
    'G1_Seq13 - F3 [pGraft,ECG].mat'
    %'G1_Seq13 - F3 [V1,V2,V3].mat'
    %'G1_Seq13 - F3 [I1,I2,I3].mat'
    'G1_Seq13 - F4 [accA].mat'
    %'G1_Seq13 - F4 [accB].mat'
    'G1_Seq13 - F4 [pGraft,ECG].mat'
    %'G1_Seq13 - F4 [V1,V2,V3].mat'
    %'G1_Seq13 - F4 [I1,I2,I3].mat'
    'G1_Seq13 - F5 [accA].mat'
    %'G1_Seq13 - F5 [accB].mat'
    'G1_Seq13 - F5 [pGraft,ECG].mat'
    %'G1_Seq13 - F5 [V1,V2,V3].mat'
    %'G1_Seq13 - F5 [I1,I2,I3].mat'
    'G1_Seq13 - F6 [accA].mat'
    %'G1_Seq13 - F6 [accB].mat'
    'G1_Seq13 - F6 [pGraft,ECG].mat'
    %'G1_Seq13 - F6 [V1,V2,V3].mat'
    %'G1_Seq13 - F6 [I1,I2,I3].mat'
    };
Config.notes_fileName = 'G1_Seq13 - Notes G1 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2021_01_14__11_41_52.wrf'
    };

% Correction input
Config.US_offsets = {1};
Config.US_drifts = {40};
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};
