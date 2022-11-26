%% User inputs

% Experiment sequence ID
Config.seq = 'IV2_Seq7';
Config.seq_subdir = 'Seq7 - LVAD1';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
Config.labChart_fileNames = {
	'IV2_Seq7 - F1 [accA].mat'
	%'IV2_Seq7 - F1 [accB].mat'
	%'IV2_Seq7 - F1 [pEff,pAff].mat'
	'IV2_Seq7 - F2 [accA].mat'
	%'IV2_Seq7 - F2 [accB].mat'
	%'IV2_Seq7 - F2 [pEff,pAff].mat'
	'IV2_Seq7 - F3 [accA].mat'
	%'IV2_Seq7 - F3 [accB].mat'
	%'IV2_Seq7 - F3 [pEff,pAff].mat'
	'IV2_Seq7 - F4 [accA].mat'
	%'IV2_Seq7 - F4 [accB].mat'
	%'IV2_Seq7 - F4 [pEff,pAff].mat'
	'IV2_Seq7 - F5 [accA].mat'
	%'IV2_Seq7 - F5 [accB].mat'
	%'IV2_Seq7 - F5 [pEff,pAff].mat'
	'IV2_Seq7 - F6 [accA].mat'
	%'IV2_Seq7 - F6 [accB].mat'
	%'IV2_Seq7 - F6 [pEff,pAff].mat'
	'IV2_Seq7 - F7 [accA].mat'
	%'IV2_Seq7 - F7 [accB].mat'
	%'IV2_Seq7 - F7 [pEff,pAff].mat'
	'IV2_Seq7 - F8 [accA].mat'
	%'IV2_Seq7 - F8 [accB].mat'
	%'IV2_Seq7 - F8 [pEff,pAff].mat'
	'IV2_Seq7 - F9 [accA].mat'
	%'IV2_Seq7 - F9 [accB].mat'
	%'IV2_Seq7 - F9 [pEff,pAff].mat'
	'IV2_Seq7 - F10 [accA].mat'
	%'IV2_Seq7 - F10 [accB].mat'
	%'IV2_Seq7 - F10 [pEff,pAff].mat'
	'IV2_Seq7 - F11 [accA].mat'
	%'IV2_Seq7 - F11 [accB].mat'
	%'IV2_Seq7 - F11 [pEff,pAff].mat'
	'IV2_Seq7 - F12 [accA].mat'
	%'IV2_Seq7 - F12 [accB].mat'
	%'IV2_Seq7 - F12 [pEff,pAff].mat'
	'IV2_Seq7 - F13 [accA].mat'
	%'IV2_Seq7 - F13 [accB].mat'
	%'IV2_Seq7 - F13 [pEff,pAff].mat'
	'IV2_Seq7 - F14 [accA].mat'
	%'IV2_Seq7 - F14 [accB].mat'
	%'IV2_Seq7 - F14 [pEff,pAff].mat'
	'IV2_Seq7 - F15 [accA].mat'
	%'IV2_Seq7 - F15 [accB].mat'
	%'IV2_Seq7 - F15 [pEff,pAff].mat'
	'IV2_Seq7 - F16 [accA].mat'
	%'IV2_Seq7 - F16 [accB].mat'
	%'IV2_Seq7 - F16 [pEff,pAff].mat'
	};
Config.notes_fileName = 'IV2_Seq7 - Notes IV2 v1.0.0 - Rev5.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_08_19__13_04_02.wrf'
    'ECM_2020_08_19__13_28_05.wrf'
    'ECM_2020_08_20__12_11_36.wrf'
    'ECM_2020_09_12__15_08_02.wrf'  
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {3, 33.5, 46, []};
Config.accChannelToSwap = {'accA_y','accA_z'};
Config.blocksForAccChannelSwap = [14:16];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

% Part mapping for quality control and description
Config.partSpec = {
%   BL    Parts   Label
	[],   [1],   'RPM change #1'
 	[],   [2],   'Balloon, 4.0mm X 20mm, extra'
  	[],   [3],   'Balloon, 4.0mm X 20mm, extra'
 	[],   [4],   'Balloon, 4.0mm X 20mm, extra'
 	[],   [5],   'Balloon, 4.0mm X 20mm, extra'
 	[],   [6],   'Balloon, 6.0mm X 20mm'
 	[],   [7],   'Balloon, 6.0mm X 20mm'
 	[],   [8],   'Balloon, 6.0mm X 20mm'
 	[],   [9],   'Balloon, 6.0mm X 20mm'
 	[],   [10],  'Balloon, 8.0mm X 30mm'
 	[],   [11],  'Balloon, 8.0mm X 30mm'
 	[],   [12],  'Balloon, 8.0mm X 30mm'
 	[],   [13],  'Balloon, 8.0mm X 30mm'
 	[],   [14],  'RPM change #2'
 	[],   [15],  'RPM change #3'
 	[],   [16],  'Balloon, 11.0mm'
 	[],   [17],  'Balloon, 11.0mm'
 	[],   [18],  'Balloon, 11.0mm'
 	[],   [19],  'Balloon, 11.0mm'
	[],   [20],  'RPM change #4'
	[20,182],   [21],  'Afterload'
	[20,180],   [22],  'Afterload'
	[20,178],   [23],  'Afterload'
	[20,176],   [24],  'Afterload'
	[],   [25],  'RPM change #5'
	[25,226],   [26],  'Preload'
	[25,224],   [27],  'Preload'
	[25,222],   [28],  'Preload'
	[25,220],   [29],  'Preload'
	[],   [30],  'RPM change #6'
	[],   [31],  'RPM change, extra'
	[],   [32],  'RPM change #7'
	[],   [33],  'Balloon, 4.5mm X 20mm'
  	[],   [34],  'Balloon, 4.5mm X 20mm'
 	[],   [35],  'Balloon, 4.5mm X 20mm'
 	[],   [36],  'Balloon, 4.5mm X 20mm #2'
	[],   [37],  'Balloon, 4.5mm X 20mm'
	};
