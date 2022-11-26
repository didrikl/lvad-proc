%% User inputs

% Experiment sequence ID
Config.seq = 'IV2B_Seq10';
Config.seq_subdir = 'Seq10 - LVAD9';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Files to use
% Files to use
Config.labChart_fileNames = {
    %'IV2_Seq10 - F1 [accA].mat'
    'IV2_Seq10 - F1 [accB].mat'
    %'IV2_Seq10 - F1 [pEff,pAff].mat'
    %'IV2_Seq10 - F2 [accA].mat'
    'IV2_Seq10 - F2 [accB].mat'
    %'IV2_Seq10 - F2 [pEff,pAff].mat'
    %'IV2_Seq10 - F3 [accA].mat'
    'IV2_Seq10 - F3 [accB].mat'
    %'IV2_Seq10 - F3 [pEff,pAff].mat'
    %'IV2_Seq10 - F4 [accA].mat'
    'IV2_Seq10 - F4 [accB].mat'
    %'IV2_Seq10 - F4 [pEff,pAff].mat'
    %'IV2_Seq10 - F5 [accA].mat'
    'IV2_Seq10 - F5 [accB].mat'
    %'IV2_Seq10 - F5 [pEff,pAff].mat'
    %'IV2_Seq10 - F6 [accA].mat'
    'IV2_Seq10 - F6 [accB].mat'
    %'IV2_Seq10 - F6 [pEff,pAff].mat'
    %'IV2_Seq10 - F7 [accA].mat'
    'IV2_Seq10 - F7 [accB].mat'
    %'IV2_Seq10 - F7 [pEff,pAff].mat'
    %'IV2_Seq10 - F8 [accA].mat'
    'IV2_Seq10 - F8 [accB].mat'
    %'IV2_Seq10 - F8 [pEff,pAff].mat'
    %'IV2_Seq10 - F9 [accA].mat'
    'IV2_Seq10 - F9 [accB].mat'
    %'IV2_Seq10 - F9 [pEff,pAff].mat'
    %'IV2_Seq10 - F10 [accA].mat'
    'IV2_Seq10 - F10 [accB].mat'
    %'IV2_Seq10 - F10 [pEff,pAff].mat'
    %'IV2_Seq10 - F11 [accA].mat'
    'IV2_Seq10 - F11 [accB].mat'
    %'IV2_Seq10 - F11 [pEff,pAff].mat'
    %'IV2_Seq10 - F12 [accA].mat'
    'IV2_Seq10 - F12 [accB].mat'
    %'IV2_Seq10 - F12 [pEff,pAff].mat'
    %'IV2_Seq10 - F13 [accA].mat'
    'IV2_Seq10 - F13 [accB].mat'
    %'IV2_Seq10 - F13 [pEff,pAff].mat'
    %'IV2_Seq10 - F14 [accA].mat'
    'IV2_Seq10 - F14 [accB].mat'
    %'IV2_Seq10 - F14 [pEff,pAff].mat'
    };
Config.notes_fileName = 'IV2_Seq10 - Notes IV2 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2020_09_03__16_20_48.wrf'
    'ECM_2020_09_04__10_34_31.wrf'
    };

% Correction input
Config.US_offsets = {};
Config.US_drifts = {[],40.5};
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
% 	[],   [8],   'Balloon, 6.0mm X 20mm'
% 	[],   [9],   'Balloon, 6.0mm X 20mm'
% 	[],   [10],  'Balloon, 8.0mm X 30mm'
%  	[],   [11],  'Balloon, 8.0mm X 30mm'
%  	[],   [12],  'Balloon, 8.0mm X 30mm'
%  	[],   [13],  'Balloon, 8.0mm X 30mm'
% 	[],   [14],  'RPM change #2'
% 	[],   [16],  'Balloon, 8.0mm X 30mm #2'
%  	[],   [17],  'Balloon, 11.0mm'
%  	[],   [18],  'Balloon, 11.0mm'
% 	[],   [19],  'Balloon, 11.0mm'
%  	[],   [20],  'Balloon, 11.0mm'
	[],   [21],  'RPM change #3'
	[],   [22],  'Afterload'
	[],   [23],  'Afterload'
	[],   [24],  'Afterload'
	[],   [25],  'Afterload'
	[],   [26],  'RPM change #4'
	[],   [27],  'Preload'
	[],   [28],  'Preload'
	[],   [20],  'Preload'
	[],   [30],  'Preload'
% 	[],   [31],  'RPM change #5'
% 	[],   [32],  'RPM change, extra'
	};