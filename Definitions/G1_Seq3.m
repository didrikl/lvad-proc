%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1_Seq3';

% Folder in base path
Config.seq_subdir = 'Seq3 - LVAD6 - Pilot';

% Which files to input from input directory 
Config.labChart_fileNames = {
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
Config.notes_fileName = 'G1_Seq3 - Notes G1 v1.0.0 - Rev8.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_09_17__12_26_32.wrf'
    };

% Override defaults
Config.labChart_varMapFile = 'VarMap_LabChart_G1_Seq3';
Config.pGradVars = {};
Config.outsideNoteInclSpec = 'none';

% Correction input
Config.US_offsets = {};
Config.US_drifts = {[]}; 
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

% Part mapping for quality control and description
Config.partSpec = {
%   BL    parts   Label
	[],   [1],   'RPM change'
	[],   [2],   'Clamping'
	[],   [3],   'Clamping'
	[],   [4],   'RPM change #2'
	[],   [5],   'Balloon'
	[],   [6],   'Balloon'
	[],   [7],   'Balloon' 
	[],   [8],   'Balloon'
	};