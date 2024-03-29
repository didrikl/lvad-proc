%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1_Seq7';

% Folder in base path
Config.seq_subdir = 'Seq7 - LVAD11';

% Which files to input from input directory
Config.labChart_fileNames = {
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
Config.notes_fileName = 'G1_Seq7 - Notes G1 v1.0.0 - Rev9.xlsm';
Config.ultrasound_fileNames = {'ECM_2020_11_05__12_27_25.wrf'};

% Correction input
Config.US_offsets = {3600-0.5};
Config.US_drifts = {[]}; %5??
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};


% Parts (or combined parts) for assessments
Config.partSpec = {
	% BL      parts         label
	% ---------------------------------
 	[],       [2],     'RPM change'
 	[],       [4],     'Balloon'
 	[],       [5],     'Balloon'
    [],       [6],     'Balloon'
    [],       [7],     'Clamping'
 	[],       [19]     'Anticoagulant reversal'
	};
