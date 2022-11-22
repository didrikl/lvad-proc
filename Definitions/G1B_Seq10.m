%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1B_Seq10';

% Folder in base path
Config.seq_subdir = 'Seq10 - LVAD14 - Terminated';

% Which files to input from input directory 
Config.labChart_fileNames = {
	%'G1_Seq10 - F0 [accA].mat'
	%'G1_Seq10 - F0 [accB].mat'
	%'G1_Seq10 - F0 [pGraft,pLV,ECG].mat'
	'G1_Seq10 - F1 [accA].mat'
	'G1_Seq10 - F1 [accB].mat'
	%'G1_Seq10 - F1 [pGraft,pLV,ECG].mat'
	'G1_Seq10 - F2 [accA].mat'
	'G1_Seq10 - F2 [accB].mat'
	%'G1_Seq10 - F2 [pGraft,pLV,ECG].mat'
	};
Config.notes_fileName = 'G1_Seq10 - Notes G1 v1.0.0 - Rev3.xlsm';
Config.ultrasound_fileNames = {'ECM_2020_12_03__11_03_35.wrf'};

% Correction input
Config.US_offsets = {};
Config.US_drifts = {37}; % Just an estimate based on previous drifts
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

% Parts (or combined parts) for assessments
Config.partSpec = {
 	% BL      Parts          Label 
	% ---------------------------------
	[],       [5:13],        'Injection [1-8]'
	};
