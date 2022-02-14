%% Sequence definitions and correction inputs

% Experiment sequence ID
pc.seq = 'G1_Seq8';

% Folder in base path
pc.seq_subdir = 'Seq8 - LVAD1';

% Which files to input from input directory
pc.labChart_fileNames = {
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
pc.notes_fileName = 'G1_Seq8 - Notes G1 v1.0.0 - Rev9.xlsm';
pc.ultrasound_fileNames = {
	'ECM_2020_11_12__11_04_40.wrf'
	};

% Correction input
pc.US_offsets = {};
pc.US_drifts = {49}; % Just an estimate based on previous drifts
pc.accChannelToSwap = {};
pc.blocksForAccChannelSwap = [];
pc.pChannelToSwap = {};
pc.pChannelSwapBlocks = [];
pc.PL_offset = [];
pc.PL_offset_files = {};