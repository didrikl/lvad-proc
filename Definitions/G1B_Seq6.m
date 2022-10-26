%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1B_Seq6';

% Folder in base path
Config.seq_subdir = 'Seq6 - LVAD7';

% Which files to input from input directory 
Config.labChart_fileNames = {
	
    % RPM + Insertion + Balloon @2400 RPM
	% ----------------------------------------------
	%'G1_Seq6 - F1_Sel1 [accA].mat'
	%'G1_Seq6 - F1_Sel1 [accB].mat'
	%'G1_Seq6 - F1_Sel1 [pGraft,pLV,ECG].mat'
    %'G1_Seq6 - F1_Sel2 [accA].mat'
	%'G1_Seq6 - F1_Sel2 [accB].mat'
	%'G1_Seq6 - F1_Sel2 [pGraft,pLV,ECG].mat'
	
	% Balloon @[2200,2600] RPM + Clamping + Injections
	% -------------------------------------------------
	'G1_Seq6 - F2_Sel1 [accA].mat'
	'G1_Seq6 - F2_Sel1 [accB].mat'
	%'G1_Seq6 - F2_Sel1 [pGraft,pLV,ECG].mat'
	'G1_Seq6 - F2_Sel2 [accA].mat'
	'G1_Seq6 - F2_Sel2 [accB].mat'
	%'G1_Seq6 - F2_Sel2 [pGraft,pLV,ECG].mat'

	};
Config.notes_fileName = 'G1_Seq6 - Notes G1 v1.0.0 - Rev10.xlsm';
Config.ultrasound_fileNames = {'ECM_2020_10_22__11_02_46.wrf'};

% Correction input
Config.US_offsets = {-0.5};
Config.US_drifts = {47.5};
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};
Config.channelToExcl = {};
Config.channelExclRanges = {};

% Parts (or combined parts) for assessments
% Config.partSpec = {
% 	% BL      parts         label
% 	% ---------------------------------
% 	%  [],       [1],        'RPM change'
% 	%  [],       [2],        'Balloon'
% 	%  [],       [3],        'Balloon'
% 	%  [],       [4],        'Balloon'
% 	%  [],       [5],        'RPM change #2'
% 	%  [],       [6],        'Clamping'
% 	%  [],       [7,8,9],    'Injection [1,2,3]'
% 	%  [9,117],  [10,11,12], 'Injection [4,5,6]'
% 	%  [12,132], [13,14,15], 'Injection [7,8,9]'
% 	};

% All injections part combined in wider spectrogram figures
Config.partSpec = {
 	% BL      parts         label
 	% ---------------------------------
 	 [],   7:15,       'Injection [1-9]'	
 	};