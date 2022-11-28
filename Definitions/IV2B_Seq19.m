%% User inputs

% Experiment sequence ID
Config.seq = 'IV2B_Seq19';
Config.seq_subdir = 'Seq19 - LVAD13';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
Config.labChart_fileNames = {
	%'IV2_Seq19 - F1 [accA].mat'
	'IV2_Seq19 - F1 [accB].mat'
	%'IV2_Seq19 - F1 [pEff,pAff].mat'
	% 'IV2_Seq19 - F2 [accA].mat'      % Overlapping with F3 block
	% 'IV2_Seq19 - F2 [accB].mat'      % Overlapping with F3 block
	% 'IV2_Seq19 - F2 [pEff,pAff].mat' % Overlapping with F3 block
	%'IV2_Seq19 - F3 [accA].mat'
	'IV2_Seq19 - F3 [accB].mat'
	%'IV2_Seq19 - F3 [pEff,pAff].mat'
	%'IV2_Seq19 - F4 [accA].mat'
	'IV2_Seq19 - F4 [accB].mat'
	%'IV2_Seq19 - F4 [pEff,pAff].mat'
	% 'IV2_Seq19 - F5 [accA].mat'      % Overlapping with F6 block
	% 'IV2_Seq19 - F5 [accB].mat'      % Overlapping with F6 block
	% 'IV2_Seq19 - F5 [pEff,pAff].mat' % Overlapping with F6 block
	%'IV2_Seq19 - F6 [accA].mat'
	'IV2_Seq19 - F6 [accB].mat'
	%'IV2_Seq19 - F6 [pEff,pAff].mat'
	%'IV2_Seq19 - F7 [accA].mat'
	'IV2_Seq19 - F7 [accB].mat'
	%'IV2_Seq19 - F7 [pEff,pAff].mat'
	%'IV2_Seq19 - F8 [accA].mat'
	'IV2_Seq19 - F8 [accB].mat'
	%'IV2_Seq19 - F8 [pEff,pAff].mat'
	%'IV2_Seq19 - F9 [accA].mat'
	'IV2_Seq19 - F9 [accB].mat'
	%'IV2_Seq19 - F9 [pEff,pAff].mat'
	%'IV2_Seq19 - F10 [accA].mat'
	'IV2_Seq19 - F10 [accB].mat'
	%'IV2_Seq19 - F10 [pEff,pAff].mat'
	%'IV2_Seq19 - F11 [accA].mat'
	'IV2_Seq19 - F11 [accB].mat'
	%'IV2_Seq19 - F11 [pEff,pAff].mat'
	%'IV2_Seq19 - F12 [accA].mat'
	'IV2_Seq19 - F12 [accB].mat'
	%'IV2_Seq19 - F12 [pEff,pAff].mat'
	%'IV2_Seq19 - F13 [accA].mat'
	'IV2_Seq19 - F13 [accB].mat'
	%'IV2_Seq19 - F13 [pEff,pAff].mat'
    };Config.notes_fileName = 'IV2_Seq19 - Notes IVS v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_12_05__16_12_22.wrf'
    'ECM_2020_12_07__14_54_33.wrf'
    'ECM_2020_12_08__13_31_21.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {8, 36, 30};
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

Config.partSpec = {
%   BL    Parts   Label
	[],   [1,2],  'RPM change #1 and extra'
	[],   [3],   'Balloon, 4.5mm X 20mm'
  	[],   [4],   'Balloon, 4.5mm X 20mm'
 	[],   [5],   'Balloon, 4.5mm X 20mm'
 	[],   [6],   'Balloon, 4.5mm X 20mm'
	[],   [7],   'Balloon, 6.0mm X 20mm'
	[],   [8],   'Balloon, 6.0mm X 20mm'
	[],   [9],   'Balloon, 6.0mm X 20mm'
	[],   [10],  'Balloon, 6.0mm X 20mm'
	[],   [11],  'Balloon, 8.0mm X 30mm - Bursted'
 	[],   [12],  'RPM change #2'
	[],   [13],  'Balloon, 11.0mm'
 	[],   [14],  'Balloon, 11.0mm'
	[],   [15],  'Balloon, 11.0mm'
 	[],   [16],  'Balloon, 11.0mm'
	[],   [17],  'RPM change #3'
	[17,179],   [18],  'Afterload'
	[17,177],   [19],  'Afterload'
	[17,175],   [20],  'Afterload'
	[17,173],   [21],  'Afterload'
	[],   [22],  'RPM change #4'
	[22,226],   [23],  'Preload'
	[22,224],   [24],  'Preload'
	[22,222],   [25],  'Preload'
	[22,220],   [26],  'Preload'
 	[],   [27],  'RPM change #5'
 	[],   [28],  'RPM change, extra'
	};