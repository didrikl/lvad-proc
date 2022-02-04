%% Sequence definitions and correction inputs

% Experiment sequence ID
seq = 'G1_Seq11';

% Folder in base path
seq_subdir = 'Seq11 - LVAD13';

% Which files to input from input directory
labChart_fileNames = {
    
    % RPM interventions + baseline (incl startup and stablizing)
    'G1_Seq11 - F1_Sel1 [accA].mat'      
    %'G1_Seq11 - F1_Sel1 [accB].mat'
    'G1_Seq11 - F1_Sel1 [pGraft,ECG,pLV].mat'
    %'G1_Seq11 - F1_Sel1 [V1,V2,V3].mat'
    %'G1_Seq11 - F1_Sel1 [I1,I2,I3].mat'

    % Catheter insertion
    'G1_Seq11 - F2 [accA].mat'      
    %'G1_Seq11 - F2 [accB].mat'      
    'G1_Seq11 - F2 [pGraft,ECG,pLV].mat'      
    'G1_Seq11 - F3 [accA].mat'
    %'G1_Seq11 - F3 [accB].mat'      
    'G1_Seq11 - F3 [pGraft,ECG,pLV].mat'      
    %'G1_Seq11 - F3 [V1,V2,V3].mat'
    %'G1_Seq11 - F3 [I1,I2,I3].mat'
    
    % Afterload clamping and
    % Cather re-insertion
    % Balloon interventions
    'G1_Seq11 - F5 [accA].mat'      
    %'G1_Seq11 - F5 [accB].mat'      
    'G1_Seq11 - F5 [pGraft,ECG,pLV].mat'
    %'G1_Seq11 - F5 [V1,V2,V3].mat'
    %'G1_Seq11 - F5 [I1,I2,I3].mat'
    'G1_Seq11 - F7 [accA].mat'      
    %'G1_Seq11 - F7 [accB].mat'      
    'G1_Seq11 - F7 [pGraft,ECG,pLV].mat'
    %'G1_Seq11 - F7 [V1,V2,V3].mat'
    %'G1_Seq11 - F7 [I1,I2,I3].mat'
     
     % Trombus injections
     'G1_Seq11 - F8 [accA].mat'      
     %'G1_Seq11 - F8 [accB].mat'
     'G1_Seq11 - F8 [pGraft,ECG,pLV].mat'
     %'G1_Seq11 - F8 [V1,V2,V3].mat'
     %'G1_Seq11 - F8 [I1,I2,I3].mat'
     'G1_Seq11 - F9 [accA].mat'
     %'G1_Seq11 - F9 [accB].mat'
     'G1_Seq11 - F9 [pGraft,ECG,pLV].mat'
     %'G1_Seq11 - F9 [V1,V2,V3].mat'
     %'G1_Seq11 - F9 [I1,I2,I3].mat'
    
    }; 
notes_fileName = 'G1_Seq11 - Notes G1 v1.0.0 - Rev6.xlsm';
ultrasound_fileNames = {
    'ECM_2020_12_10__11_07_03.wrf'
};

% Correction input
pc.US_offsets = {};
pc.US_drifts = {50}; % times 2???
pc.accChannelToSwap = {};
pc.blocksForAccChannelSwap = [];
pc.pChannelToSwap = {};
pc.pChannelSwapBlocks = [];
pc.PL_offset = [];
pc.PL_offset_files = {};