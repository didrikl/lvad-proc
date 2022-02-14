%% Sequence definitions and correction inputs

% Experiment sequence ID
pc.seq = 'G1_Seq12';

% Folder in base path
pc.seq_subdir = 'Seq12 - LVAD17';

% Which files to input from input directory
pc.labChart_fileNames = {
    'G1_Seq12 - F1 [accA].mat'
    %'G1_Seq12 - F1 [accB].mat'
    'G1_Seq12 - F1 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F1 [V1,V2,V3].mat'
    %'G1_Seq12 - F1 [I1,I2,I3].mat'
    'G1_Seq12 - F2 [accA].mat'
    %'G1_Seq12 - F2 [accB].mat'
    'G1_Seq12 - F2 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F2 [V1,V2,V3].mat'
    %'G1_Seq12 - F2 [I1,I2,I3].mat'
    'G1_Seq12 - F3 [accA].mat'
    %'G1_Seq12 - F3 [accB].mat'
    'G1_Seq12 - F3 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F3 [V1,V2,V3].mat'
    %'G1_Seq12 - F3 [I1,I2,I3].mat'
    'G1_Seq12 - F4 [accA].mat'
    %'G1_Seq12 - F4 [accB].mat'
    'G1_Seq12 - F4 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F4 [V1,V2,V3].mat'
    %'G1_Seq12 - F4 [I1,I2,I3].mat'
    'G1_Seq12 - F5 [accA].mat'
    %'G1_Seq12 - F5 [accB].mat'
    'G1_Seq12 - F5 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F5 [V1,V2,V3].mat'
    %'G1_Seq12 - F5 [I1,I2,I3].mat'
    };
pc.notes_fileName = 'G1_Seq12 - Notes G1 v1.0.0 - Rev7.xlsm';
pc.ultrasound_fileNames = {
    'ECM_2021_01_07__12_08_22.wrf'
    };

% Correction input
pc.US_offsets = {};
pc.US_drifts = {52};
pc.accChannelToSwap = {};
pc.blocksForAccChannelSwap = [];
pc.pChannelToSwap = {};
pc.pChannelSwapBlocks = [];
pc.PL_offset = [];
pc.PL_offset_files = {};