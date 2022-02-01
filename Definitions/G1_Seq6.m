%% Sequence definitions and correction inputs

% Experiment sequence ID
seq = 'G1_Seq6';

% Folder in base path
experiment_subdir = 'Seq6 - LVAD7';

% Which files to input from input directory 
labChart_fileNames = {
	'G1_Seq6 - F1_Sel1 [accA].mat'
	%'G1_Seq6 - F1_Sel1 [accB].mat'
	'G1_Seq6 - F1_Sel1 [pGraft,pLV,ECG].mat'
	'G1_Seq6 - F1_Sel2 [accA].mat'
	%'G1_Seq6 - F1_Sel2 [accB].mat'
	'G1_Seq6 - F1_Sel2 [pGraft,pLV,ECG].mat'
	'G1_Seq6 - F2_Sel1 [accA].mat'
	%'G1_Seq6 - F2_Sel1 [accB].mat'
	'G1_Seq6 - F2_Sel1 [pGraft,pLV,ECG].mat'
	'G1_Seq6 - F2_Sel2 [accA].mat'
	%'G1_Seq6 - F2_Sel2 [accB].mat'
	'G1_Seq6 - F2_Sel2 [pGraft,pLV,ECG].mat'
	};
notes_fileName = 'G1_Seq6 - Notes G1 v1.0.0 - Rev9.xlsm';
ultrasound_fileNames = {
    'ECM_2020_10_22__11_02_46.wrf'
};

% Correction input
US_offsets = {};
US_drifts = {47.5}; % Just an estimate based on previous drifts
accChannelToSwap = {};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];
PL_offset = [];
PL_offset_files = {};