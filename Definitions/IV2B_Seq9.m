%% User inputs

% Experiment sequence ID
Config.seq = 'IV2B_Seq9';
Config.seq_subdir = 'Seq9 - LVAD6';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
Config.labChart_fileNames = {
	%'IV2_Seq9 - F1 [accA].mat'
	'IV2_Seq9 - F1 [accB].mat'
	%'IV2_Seq9 - F1 [pEff,pAff].mat'
	%'IV2_Seq9 - F2 [accA].mat'
	'IV2_Seq9 - F2 [accB].mat'
	%'IV2_Seq9 - F2 [pEff,pAff].mat'
	%'IV2_Seq9 - F3 [accA].mat'
	'IV2_Seq9 - F3 [accB].mat'
	%'IV2_Seq9 - F3 [pEff,pAff].mat'
	%'IV2_Seq9 - F4 [accA].mat'
	'IV2_Seq9 - F4 [accB].mat'
	%'IV2_Seq9 - F4 [pEff,pAff].mat'
	%'IV2_Seq9 - F5 [accA].mat'
	'IV2_Seq9 - F5 [accB].mat'
	%'IV2_Seq9 - F5 [pEff,pAff].mat'
	%'IV2_Seq9 - F6 [accA].mat'
	'IV2_Seq9 - F6 [accB].mat'
	%'IV2_Seq9 - F6 [pEff,pAff].mat'
	%'IV2_Seq9 - F7 [accA].mat'
	'IV2_Seq9 - F7 [accB].mat'
	%'IV2_Seq9 - F7 [pEff,pAff].mat'
	%'IV2_Seq9 - F8 [accA].mat'
	'IV2_Seq9 - F8 [accB].mat'
	%'IV2_Seq9 - F8 [pEff,pAff].mat'
	%'IV2_Seq9 - F9 [accA].mat'
	'IV2_Seq9 - F9 [accB].mat'
	%'IV2_Seq9 - F9 [pEff,pAff].mat'
	%'IV2_Seq9 - F10 [accA].mat'
	'IV2_Seq9 - F10 [accB].mat'
	%'IV2_Seq9 - F10 [pEff,pAff].mat'
	%'IV2_Seq9 - F11 [accA].mat'
	'IV2_Seq9 - F11 [accB].mat'
	%'IV2_Seq9 - F11 [pEff,pAff].mat'
	%'IV2_Seq9 - F12 [accA].mat'
	'IV2_Seq9 - F12 [accB].mat'
	%'IV2_Seq9 - F12 [pEff,pAff].mat'
	%'IV2_Seq9 - F13 [accA].mat'
	'IV2_Seq9 - F13 [accB].mat'
	%'IV2_Seq9 - F13 [pEff,pAff].mat'
	};
Config.notes_fileName = 'IV2_Seq9 - Notes IV2 v1.0.0 - Rev3.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_08_31__12_20_52.wrf'
    'ECM_2020_08_31__14_33_40.wrf'
    'ECM_2020_09_01__11_04_20.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {[], [], 45};
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

Config.partSpec = {
%   BL    Parts   Label
% 	[],   [1],   'RPM change #1'
% 	[],   [2],   'Balloon, 4.5mm X 20mm'
%   	[],   [3],   'Balloon, 4.5mm X 20mm'
%  	[],   [4],   'Balloon, 4.5mm X 20mm'
%  	[],   [5],   'Balloon, 4.5mm X 20mm'
% 	[],   [6],   'Balloon, 6.0mm X 20mm'
% 	[],   [7],   'Balloon, 6.0mm X 20mm'
% 	[],   [8],   'Balloon, 8.0mm X 30mm'
%  	[],   [9],   'Balloon, 8.0mm X 30mm'
%  	[],   [10],  'Balloon, 8.0mm X 30mm'
%  	[],   [11],  'Balloon, 8.0mm X 30mm'
%  	[],   [12],  'Balloon, 11.0mm #1'
%  	[],   [13],  'Balloon, 11.0mm #1'
% 	[],   [14],  'RPM change #2'
% 	[],   [15],  'Balloon, 11.0mm #2 - Bursted'
%  	[],   [16],  'Balloon, 11.0mm #2'
% 	[],   [17],  'Balloon, 11.0mm #2'
%  	[],   [18],  'Balloon, 11.0mm #2'
% 	[],   [19],  'Balloon, 11.0mm #2'
% 	[],   [20],  'Balloon, 6.0mm X 20mm'
% 	[],   [21],  'Balloon, 6.0mm X 20mm'
	[],   [22],  'RPM change #3'
	[22,206],   [23],  'Afterload'
	[22,204],   [24],  'Afterload'
	[22,202],   [25],  'Afterload'
	[22,200],   [26],  'Afterload'
	[],   [27],  'RPM change #4'
	[27,249],   [28],  'Preload'
	[27,247],   [29],  'Preload'
	[27,245],   [30],  'Preload'
	[27,243],   [31],  'Preload'
% 	[],   [32],  'RPM change #5'
% 	[],   [33],  'RPM change, extra'
	};