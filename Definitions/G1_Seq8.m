%% Sequence definitions and correction inputs

% Experiment sequence ID
seq = 'G1_Seq8';

% Folder in base path
experiment_subdir = 'Seq8 - LVAD1';

% Which files to input from input directory
labChart_fileNames = {
	'G1_Seq8 - F1 [accA].mat'
	%'G1_Seq8 - F1 [accB].mat'
	'G1_Seq8 - F1 [pGraft,ECG,pLV].mat'
	%'G1_Seq8 - F1 [i1,i2,i3].mat'
	%'G1_Seq8 - F1 [v1,v2,v3].mat'
	'G1_Seq8 - F2 [accA].mat'
	%'G1_Seq8 - F2 [accB].mat'
	'G1_Seq8 - F2 [pGraft,ECG,pLV].mat'
	%'G1_Seq8 - F2 [i1,i2,i3].mat'
	%'G1_Seq8 - F2 [v1,v2,v3].mat'
	'G1_Seq8 - F3_Sel1 [accA].mat'
	%'G1_Seq8 - F3_Sel1 [accB].mat'
	'G1_Seq8 - F3_Sel1 [pGraft,ECG,pLV].mat'
	%'G1_Seq8 - F3_Sel1 [i1,i2,i3].mat'
	%'G1_Seq8 - F3_Sel1 [v1,v2,v3].mat'
	'G1_Seq8 - F3_Sel2 [accA].mat'
	%'G1_Seq8 - F3_Sel2 [accB].mat'
	'G1_Seq8 - F3_Sel2 [pGraft,ECG,pLV].mat'
	%'G1_Seq8 - F3_Sel2 [i1,i2,i3].mat'
	%'G1_Seq8 - F3_Sel2 [v1,v2,v3].mat'
	};
notes_fileName = 'G1_Seq8 - Notes G1 v1.0.0 - Rev9.xlsm';
ultrasound_fileNames = {
	'ECM_2020_11_12__11_04_40.wrf'
	};

% Correction input
US_offsets = {};
US_drifts = {49}; % Just an estimate based on previous drifts
accChannelToSwap = {};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];
PL_offset = [];
PL_offset_files = {};