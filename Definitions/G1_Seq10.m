%% Sequence definitions and correction inputs

% Experiment sequence ID
seq = 'G1_Seq10';

% Folder in base path
experiment_subdir = 'Seq10 - LVAD14';

% Which files to input from input directory 
labChart_fileNames = {
	'G1_Seq10 - F0 [accA].mat'
	'G1_Seq10 - F0 [pGraft,pLV,ECG].mat'
	%'G1_Seq10 - F0 [accB].mat'
	'G1_Seq10 - F1 [accA].mat'
	'G1_Seq10 - F1 [pGraft,pLV,ECG].mat'
	%'G1_Seq10 - F1 [accB].mat'
	'G1_Seq10 - F2 [accA].mat'
	'G1_Seq10 - F2 [pGraft,pLV,ECG].mat'
	%'G1_Seq10 - F2 [accB].mat'
	};
notes_fileName = 'G1_Seq10 - Notes G1 v1.0.0 - Rev9.xlsm';
ultrasound_fileNames = {
    'ECM_2020_12_03__11_03_35.wrf'
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