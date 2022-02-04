%% Sequence definitions and correction inputs

% Experiment sequence ID
seq = 'G1_Seq7';

% Folder in base path
seq_subdir = 'Seq7 - LVAD11';

% Which files to input from input directory
labChart_fileNames = {
	'G1_Seq7 - F1 [accA].mat'
	%'G1_Seq7 - F1 [accB].mat'
	'G1_Seq7 - F1 [pGraft,pLV].mat'
	%'G1_Seq7 - F1 [i1,i2,i3].mat'
	%'G1_Seq7 - F1 [v1,v2,v3].mat'
	'G1_Seq7 - F2 [accA].mat'
	%'G1_Seq7 - F2 [accB].mat'
	'G1_Seq7 - F2 [pGraft,pLV].mat'
	%'G1_Seq7 - F2 [i1,i2,i3].mat'
	%'G1_Seq7 - F2 [v1,v2,v3].mat'
	'G1_Seq7 - F3_Sel1 [accA].mat'
	%'G1_Seq7 - F3_Sel1 [accB].mat'
	'G1_Seq7 - F3_Sel1 [pGraft,pLV].mat'
	%'G1_Seq7 - F3_Sel1 [i1,i2,i3].mat'
	%'G1_Seq7 - F3_Sel1 [v1,v2,v3].mat'
	'G1_Seq7 - F3_Sel2 [accA].mat'
	%'G1_Seq7 - F3_Sel2 [accB].mat'
	'G1_Seq7 - F3_Sel2 [pGraft,pLV].mat'
	%'G1_Seq7 - F3_Sel2 [i1,i2,i3].mat'
	%'G1_Seq7 - F3_Sel2 [v1,v2,v3].mat'
	};
notes_fileName = 'G1_Seq7 - Notes G1 v1.0.0 - Rev7.xlsm';
ultrasound_fileNames = {
	'ECM_2020_11_05__12_27_25.wrf'
	};

% Correction input
pc.US_offsets = {3600};
pc.US_drifts = {5}; % Just an estimate based on previous drifts
pc.accChannelToSwap = {};
pc.blocksForAccChannelSwap = [];
pc.pChannelToSwap = {};
pc.pChannelSwapBlocks = [];
pc.PL_offset = [];
pc.PL_offset_files = {};