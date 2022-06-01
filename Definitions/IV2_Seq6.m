% Experiment sequence ID
Config.seq = 'IV2_Seq6';
Config.seq_subdir = 'Seq6 - LVAD8';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% NOTE: Could be implemented to be selected interactively using uigetfiles
Config.labChart_fileNames = {
    'IV2_Seq6 - F1 [pEff,pAff].mat'
    'IV2_Seq6 - F1 [accA].mat'
    %     'IV2_Seq6 - F1 [accB].mat'
    'IV2_Seq6 - F2 [pEff,pAff].mat'
    'IV2_Seq6 - F2 [accA].mat'
    %     'IV2_Seq6 - F2 [accB].mat'
    'IV2_Seq6 - F3 [pEff,pAff].mat'
    'IV2_Seq6 - F3 [accA].mat'
    %     'IV2_Seq6 - F3 [accB].mat'
    'IV2_Seq6 - F4 [pEff,pAff].mat'
    'IV2_Seq6 - F4 [accA].mat'
    %     'IV2_Seq6 - F4 [accB].mat'
    'IV2_Seq6 - F5 [pEff,pAff].mat'
    'IV2_Seq6 - F5 [accA].mat'
    %     'IV2_Seq6 - F5 [accB].mat'
    'IV2_Seq6 - F6 [pEff,pAff].mat'
    'IV2_Seq6 - F6 [accA].mat'
    %     'IV2_Seq6 - F6 [accB].mat'
    'IV2_Seq6 - F7 [pEff,pAff].mat'
    'IV2_Seq6 - F7 [accA].mat'
    %     'IV2_Seq6 - F7 [accB].mat'
    'IV2_Seq6 - F8 [pEff,pAff].mat'
    'IV2_Seq6 - F8 [accA].mat'
    %     'IV2_Seq6 - F8 [accB].mat'
    'IV2_Seq6 - F9 [pEff,pAff].mat'
    'IV2_Seq6 - F9 [accA].mat'
    %     'IV2_Seq6 - F9 [accB].mat'
    'IV2_Seq6 - F10 [pEff,pAff].mat'
    'IV2_Seq6 - F10 [accA].mat'
    %'IV2_Seq6 - F10 [accB].mat'
    };
Config.notes_fileName = 'IV2_Seq6 - Notes IV2 v1.0.0 - Rev3.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_09_02__12_23_38.wrf'
    'ECM_2020_09_03__11_52_50.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {[], 24.5};
Config.accChannelToSwap = {'accA_y','accA_z'};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

% Part mapping for quality control and description
Config.partSpec = {
%   BL    parts   Label
	[],   [1],   'RPM change #1'
 	[],   [2],   'Balloon, 4.5mm X 20mm'
  	[],   [3],   'Balloon, 4.5mm X 20mm'
 	[],   [4],   'Balloon, 4.5mm X 20mm'
 	[],   [5],   'Balloon, 4.5mm X 20mm'
 	[],   [6],   'Balloon, 4.5mm X 20mm'
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
	[],   [19],  'RPM change #2'
	[],   [20],  'Afterload'
	[],   [21],  'Afterload'
	[],   [22],  'Afterload'
	[],   [23],  'Afterload'
	[],   [24],  'RPM change #3'
	[],   [25],  'Preload'
	[],   [26],  'Preload'
	[],   [27],  'Preload'
	[],   [28],  'Preload'
	[],   [29],  'RPM change #4'
	[],   [30],  'RPM change, extra'
	};
