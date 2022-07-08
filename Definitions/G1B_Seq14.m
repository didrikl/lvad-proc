%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1B_Seq14';

% Folder in base path
Config.seq_subdir = 'Seq14 - LVAD9';

% Which files to input from input directory
Config.labChart_fileNames = {
	%'G1_Seq14 - F1 [accA].mat'
	'G1_Seq14 - F1 [accB].mat'
	%'G1_Seq14 - F1 [pGraft,ECG,pLV].mat'
	%'G1_Seq14 - F1 [V1,V2,V3].mat'
	%'G1_Seq14 - F1 [I1,I2,I3].mat'
	%'G1_Seq14 - F2 [accA].mat'
	'G1_Seq14 - F2 [accB].mat'
	%'G1_Seq14 - F2 [pGraft,ECG,pLV].mat'
	%'G1_Seq14 - F2 [V1,V2,V3].mat'
	%'G1_Seq14 - F2 [I1,I2,I3].mat'
	%'G1_Seq14 - F3 [accA].mat'
	'G1_Seq14 - F3 [accB].mat'
	%'G1_Seq14 - F3 [pGraft,ECG,pLV].mat'
	%'G1_Seq14 - F3 [V1,V2,V3].mat'
	%'G1_Seq14 - F3 [I1,I2,I3].mat'
	%'G1_Seq14 - F4 [accA].mat'
	'G1_Seq14 - F4 [accB].mat'
	%'G1_Seq14 - F4 [pGraft,ECG,pLV].mat'
	%%'G1_Seq14 - F4 [V1,V2,V3].mat' % no recording
	%%'G1_Seq14 - F4 [I1,I2,I3].mat' % no recording
	%'G1_Seq14 - F5 [accA].mat'
	'G1_Seq14 - F5 [accB].mat'
	%'G1_Seq14 - F5 [pGraft,ECG,pLV].mat'
	%'G1_Seq14 - F5 [V1,V2,V3].mat'
	%'G1_Seq14 - F5 [I1,I2,I3].mat'
    }; 
Config.notes_fileName = 'G1_Seq14 - Notes G1 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {
    'ECM_2021_01_21__11_01_24.wrf'
    'ECM_2021_01_21__16_48_16.wrf'
};

% Correction input
Config.US_offsets = {0.5,0.5};
Config.US_drifts = {[],[]}; % 47 sec drift in total --> must check!
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

parts = {
    [],   [2],  [],   '1. RPM changes'
    [],   [8],  [],   '1. RPM changes - Second time'
    [],   [3],  [],   '2. Graft clamping'
    {},   [5],  [],   '3. Balloon inflation'
    {},   [6],  [],   '4. Balloon inflation'
    [],   [7],  [],   '5. Balloon inflation'
    [],   [9],  [],   '6. Saline bolus injections'
    };

% Parts (or combined parts) for quality control and description
Config.partSpec = {
%   BL    parts   Label
	[],   [2],    'RPM change'
	[],   [3],    'Clamping'
	[],   [5],    'Balloon'
	[],   [6],    'Balloon'
	[],   [7],    'Balloon'
	[],   [8],    'RPM change #2'
	[],   [9],    'Injection [Sal]'
	};