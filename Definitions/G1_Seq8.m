%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1_Seq8';

% Folder in base path
Config.seq_subdir = 'Seq8 - LVAD1';

% Which files to input from input directory
Config.labChart_fileNames = {
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
Config.notes_fileName = 'G1_Seq8 - Notes G1 v1.0.0 - Rev9.xlsm';
Config.ultrasound_fileNames = {
	'ECM_2020_11_12__11_04_40.wrf'
	};

% Correction input
Config.US_offsets = {-1};
Config.US_drifts = {49}; % Just an estimate based on previous drifts
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};
Config.channelToExcl = {'accA_y'};
Config.channelExclRanges = {	
	'11/12/2020 12:06:55', '11/12/2020 12:45:00' % RPM changes
    '11/12/2020 12:53:07', '11/12/2020 12:57:16' % clamp
    '11/12/2020 13:27:50', '11/12/2020 13:58:42' % balloon, 2400 RPM 
	'11/12/2020 14:08:27', '11/12/2020 14:13:00' % balloon, 2200 RPM
    '11/12/2020 14:21:35', '11/12/2020 14:48:05' % balloon, 2200-2600 RPM
	};

% Parts (or combined parts) for quality control and description
Config.partSpec = {
%   BL    parts   Label
	[],        [2],      'RPM change'
	[],        [3],      'Clamping'
	[],        [5],      'Balloon'
	[],        [6],      'Balloon'
	[],        [7],      'Balloon'
  	[],        [8:11],   'Thrombus [1,Sal,2,3]'
%   	[11,141],  [12:14],  'Thrombus [4,5,6]'
%   	[14,157],  [15:18],  'Thrombus [7,8,9,10]'
%   	[14,157],  [19:22],  'Fat [1,2,3,4]'
%    	[],        [23]      'Anticoagulant reversal'
	};