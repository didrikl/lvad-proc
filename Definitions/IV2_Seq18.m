%% User inputs

% Experiment sequence ID
Config.seq = 'IV2_Seq18';
Config.seq_subdir = 'Seq18 - LVAD14';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
Config.labChart_fileNames = {
	'IV2_Seq18 - F1 [accA].mat'
	%'IV2_Seq18 - F1 [accB].mat'
	%'IV2_Seq18 - F1 [pEff,pAff].mat'
	'IV2_Seq18 - F2 [accA].mat'
	%'IV2_Seq18 - F2 [accB].mat'
	%'IV2_Seq18 - F2 [pEff,pAff].mat'
	'IV2_Seq18 - F3 [accA].mat'
	%'IV2_Seq18 - F3 [accB].mat'
	%'IV2_Seq18 - F3 [pEff,pAff].mat'
	'IV2_Seq18 - F4 [accA].mat'
	%'IV2_Seq18 - F4 [accB].mat'
	%'IV2_Seq18 - F4 [pEff,pAff].mat'
	'IV2_Seq18 - F5 [accA].mat'
	%'IV2_Seq18 - F5 [accB].mat'
	%'IV2_Seq18 - F5 [pEff,pAff].mat'
	'IV2_Seq18 - F6 [accA].mat'
	%'IV2_Seq18 - F6 [accB].mat'
	%'IV2_Seq18 - F6 [pEff,pAff].mat'
	'IV2_Seq18 - F7 [accA].mat'
	%'IV2_Seq18 - F7 [accB].mat'
	%'IV2_Seq18 - F7 [pEff,pAff].mat'
	'IV2_Seq18 - F8 [accA].mat'
	%'IV2_Seq18 - F8 [accB].mat'
	%'IV2_Seq18 - F8 [pEff,pAff].mat'
	'IV2_Seq18 - F9 [accA].mat'
	%'IV2_Seq18 - F9 [accB].mat'
	%'IV2_Seq18 - F9 [pEff,pAff].mat'
	};
Config.notes_fileName = 'IV2_Seq18 - Notes IV2 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_11_30__18_40_16.wrf'
    'ECM_2020_12_01__11_38_06.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {9, 55};
Config.accChannelToSwap = {'accA_y','accA_z'};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

Config.partSpec = {
%   BL    Parts   Label
	[],   [1],   'RPM change #1'
	[],   [2],   'Balloon, 4.5mm X 20mm'
  	[],   [3],   'Balloon, 4.5mm X 20mm'
 	[],   [4],   'Balloon, 4.5mm X 20mm'
 	[],   [5],   'Balloon, 4.5mm X 20mm'
	[],   [6],   'RPM change #2'
	[],   [7],   'Balloon, 6.0mm X 20mm'
	[],   [8],   'Balloon, 6.0mm X 20mm'
	[],   [9],   'Balloon, 6.0mm X 20mm'
	[],   [10],  'Balloon, 6.0mm X 20mm'
	[],   [11],  'Balloon, 8.0mm X 30mm'
 	[],   [12],  'Balloon, 8.0mm X 30mm'
 	[],   [13],  'Balloon, 8.0mm X 30mm'
 	[],   [14],  'Balloon, 8.0mm X 30mm'
	[],   [15],  'Balloon, 11.0mm'
 	[],   [16],  'Balloon, 11.0mm'
	[],   [17],  'Balloon, 11.0mm'
 	[],   [18],  'Balloon, 11.0mm'
	[],   [19],  'RPM change #3'
	[19,174],   [20],  'Afterload'
	[19,172],   [21],  'Afterload'
	[19,170],   [22],  'Afterload'
	[19,168],   [23],  'Afterload'
	[],   [24],  'RPM change #4'
	[24,223],   [25],  'Preload'
	[24,221],   [26],  'Preload'
	[24,219],   [27],  'Preload'
	[24,217],   [28],  'Preload'
	[],   [29],  'RPM change #5'
	[],   [30],  'RPM change, extra'
	};