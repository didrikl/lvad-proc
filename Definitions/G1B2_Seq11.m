%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1B2_Seq11';

% Folder in base path
Config.seq_subdir = 'Seq11 - LVAD13';

% Which files to input from input directory
Config.labChart_fileNames = {
    
    % RPM + Baseline
    % ---------------
	%'G1_Seq11 - F1_Sel1 [accA].mat'      
    'G1_Seq11 - F1_Sel1 [accB].mat'
    %'G1_Seq11 - F1_Sel1 [pGraft,ECG,pLV].mat'
    %'G1_Seq11 - F1_Sel1 [V1,V2,V3].mat'
    %'G1_Seq11 - F1_Sel1 [I1,I2,I3].mat'

    % Insertion #1
    % -------------
	%'G1_Seq11 - F2 [accA].mat'      
    'G1_Seq11 - F2 [accB].mat'      
    %'G1_Seq11 - F2 [pGraft,ECG,pLV].mat'      
    %'G1_Seq11 - F3 [accA].mat'
    %'G1_Seq11 - F3 [accB].mat'      
    %'G1_Seq11 - F3 [pGraft,ECG,pLV].mat'      
    %'G1_Seq11 - F3 [V1,V2,V3].mat'
    %'G1_Seq11 - F3 [I1,I2,I3].mat'
    
    % Clamping + Insertion #2 + Balloon 
    % ----------------------------------
	%'G1_Seq11 - F5 [accA].mat'      
    'G1_Seq11 - F5 [accB].mat'      
    %'G1_Seq11 - F5 [pGraft,ECG,pLV].mat'
    %'G1_Seq11 - F5 [V1,V2,V3].mat'
    %'G1_Seq11 - F5 [I1,I2,I3].mat'
    %'G1_Seq11 - F7 [accA].mat'      
    'G1_Seq11 - F7 [accB].mat'      
    %'G1_Seq11 - F7 [pGraft,ECG,pLV].mat'
    %'G1_Seq11 - F7 [V1,V2,V3].mat'
    %'G1_Seq11 - F7 [I1,I2,I3].mat'
     
     % Injections
     % -----------
	 'G1_Seq11 - F8 [accA].mat'      
     %'G1_Seq11 - F8 [accB].mat'
     %'G1_Seq11 - F8 [pGraft,ECG,pLV].mat'
     %'G1_Seq11 - F8 [V1,V2,V3].mat'
     %'G1_Seq11 - F8 [I1,I2,I3].mat'
     %'G1_Seq11 - F9 [accA].mat'
     %'G1_Seq11 - F9 [accB].mat'
     %'G1_Seq11 - F9 [pGraft,ECG,pLV].mat'
     %'G1_Seq11 - F9 [V1,V2,V3].mat'
     %'G1_Seq11 - F9 [I1,I2,I3].mat'
    
    }; 
Config.notes_fileName = 'G1_Seq11 - Notes G1 v1.0.0 - Rev7.xlsm';
Config.ultrasound_fileNames = {'ECM_2020_12_10__11_07_03.wrf'};

% Correction input
Config.US_offsets = {};
Config.US_drifts = {50}; % times 2???
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

% Parts (or combined parts) for assessments
Config.partSpec = {
 	% BL      Parts      Label 
	% ---------------------------------
	  [],     [2],      'RPM change'
	  [],     [3],      'Clamping'
	  [],     [5],      'Balloon'
	  [],     [6],      'Balloon'
	  [],     [7],      'Balloon'
	};

% All injections part combined in wider spectrogram figures
% Config.partSpec = {
% 	% BL      parts         label
% 	% ---------------------------------
% 	};