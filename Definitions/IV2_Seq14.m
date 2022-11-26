%% User inputs

% Experiment sequence ID
Config.seq = 'IV2_Seq14';
Config.seq_subdir = 'Seq14 - LVAD7';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
Config.labChart_fileNames = {
    'IV2_Seq14 - F1 [accA].mat'
    %'IV2_Seq14 - F1 [accB].mat'
    %'IV2_Seq14 - F1 [pEff,pAff].mat'
    'IV2_Seq14 - F2 [accA].mat'
    %'IV2_Seq14 - F2 [accB].mat'
    %'IV2_Seq14 - F2 [pEff,pAff].mat'
    'IV2_Seq14 - F3 [accA].mat'
    %'IV2_Seq14 - F3 [accB].mat'
    %'IV2_Seq14 - F3 [pEff,pAff].mat'
    'IV2_Seq14 - F4 [accA].mat'
    %'IV2_Seq14 - F4 [accB].mat'
    %'IV2_Seq14 - F4 [pEff,pAff].mat'
    'IV2_Seq14 - F5 [accA].mat'
    %'IV2_Seq14 - F5 [accB].mat'
    %'IV2_Seq14 - F5 [pEff,pAff].mat'
    'IV2_Seq14 - F6 [accA].mat'
    %'IV2_Seq14 - F6 [accB].mat'
    %'IV2_Seq14 - F6 [pEff,pAff].mat'
    'IV2_Seq14 - F7 [accA].mat'
    %'IV2_Seq14 - F7 [accB].mat'
    %'IV2_Seq14 - F7 [pEff,pAff].mat'
    'IV2_Seq14 - F8 [accA].mat'
    %'IV2_Seq14 - F8 [accB].mat'
    %'IV2_Seq14 - F8 [pEff,pAff].mat'
    'IV2_Seq14 - F9 [accA].mat'
    %'IV2_Seq14 - F9 [accB].mat'
    %'IV2_Seq14 - F9 [pEff,pAff].mat'
    'IV2_Seq14 - F10 [accA].mat'
    %'IV2_Seq14 - F10 [accB].mat'
    %'IV2_Seq14 - F10 [pEff,pAff].mat'
    'IV2_Seq14 - F11 [accA].mat'
    %'IV2_Seq14 - F11 [accB].mat'
    %'IV2_Seq14 - F11 [pEff,pAff].mat'
    };
Config.notes_fileName = 'IV2_Seq14 - Notes IV2 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_09_12__18_18_23.wrf'
    'ECM_2020_09_14__11_45_57.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {14, 42};
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
	[],   [6],   'Balloon, 6.0mm X 20mm'
	[],   [7],   'Balloon, 6.0mm X 20mm'
	[],   [8],   'Balloon, 6.0mm X 20mm'
	[],   [9],   'Balloon, 6.0mm X 20mm'
	[],   [10],  'RPM change #2'
	[],   [11],  'RPM change #3'	
	[],   [12],  'Balloon, 8.0mm X 30mm'
 	[],   [13],  'Balloon, 8.0mm X 30mm'
 	[],   [14],  'Balloon, 8.0mm X 30mm'
 	[],   [15],  'Balloon, 8.0mm X 30mm'
	[],   [16],  'Balloon, 11.0mm'
 	[],   [17],  'Balloon, 11.0mm'
	[],   [18],  'Balloon, 11.0mm'
 	[],   [19],  'Balloon, 11.0mm'
	[],   [20],  'RPM change #4'
	[20,183],   [21],  'Afterload'
	[20,181],   [22],  'Afterload'
	[20,179],   [23],  'Afterload'
	[20,177],   [24],  'Afterload'
	[],   [25],  'RPM change #5'
	[25,229],   [26],  'Preload'
	[25,227],   [27],  'Preload'
	[25,225],   [28],  'Preload'
	[25,223],   [29],  'Preload'
	[],   [30],  'RPM change #6'
	[],   [31],  'RPM change, extra'
	};
