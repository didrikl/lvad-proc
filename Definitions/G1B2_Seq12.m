1%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1B2_Seq12';

% Folder in base path
Config.seq_subdir = 'Seq12 - LVAD17';

% Which files to input from input directory
Config.labChart_fileNames = {
    
    % RPM #1 + Clamping #1
	% ---------------------
    %'G1_Seq12 - F1 [accA].mat'
    'G1_Seq12 - F1 [accB].mat'
    %'G1_Seq12 - F1 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F1 [V1,V2,V3].mat'
    %'G1_Seq12 - F1 [I1,I2,I3].mat'
    
	% Insertion #1 + Balloon @2400 RPM #1 (aborted)
	% ----------------------------------------------
	%'G1_Seq12 - F2 [accA].mat'
    'G1_Seq12 - F2 [accB].mat'
    %'G1_Seq12 - F2 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F2 [V1,V2,V3].mat'
    %'G1_Seq12 - F2 [I1,I2,I3].mat'

	% Insertion #2 + Balloon @2400 RPM #2
	% ------------------------------------
	%'G1_Seq12 - F3 [accA].mat'
    'G1_Seq12 - F3 [accB].mat'
    %'G1_Seq12 - F3 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F3 [V1,V2,V3].mat'
    %'G1_Seq12 - F3 [I1,I2,I3].mat'

	% Balloon @ [2200,2600] + RPM #2 + Clamping #2
	% ---------------------------------------------
	%'G1_Seq12 - F4 [accA].mat'
    'G1_Seq12 - F4 [accB].mat'
    %'G1_Seq12 - F4 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F4 [V1,V2,V3].mat'
    %'G1_Seq12 - F4 [I1,I2,I3].mat'
    
	% Injections
	% -----------
	%'G1_Seq12 - F5 [accA].mat'
    %'G1_Seq12 - F5 [accB].mat'
    %'G1_Seq12 - F5 [pGraft,ECG,pLV].mat'
    %'G1_Seq12 - F5 [V1,V2,V3].mat'
    %'G1_Seq12 - F5 [I1,I2,I3].mat'

    };
Config.notes_fileName = 'G1_Seq12 - Notes G1 v1.0.0 - Rev9.xlsm';
Config.ultrasound_fileNames = {'ECM_2021_01_07__12_08_22.wrf'};

% Correction input
Config.US_offsets = {};
Config.US_drifts = {52};
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};
% Config.channelToExcl = {'accA_x','accA_y','accA_z'};
% Config.channelExclRanges = {	
% 	'01/07/2021 17:50:46', '01/07/2021 17:50:51' % Signal loss during clamp reversal
%    };

% Parts (or combined parts) for assessments
Config.partSpec = {
 	% BL      Parts      Label 
	% ---------------------------------
	  [],     [2],       'RPM change, CO below 50%'
	  [],     [3],       'Clamping, CO below 50%'
	  [],     [5],       'Balloon, aborted'
	  [],     [7],       'Balloon'
	  [],     [8],       'Balloon'
	  [],     [9],       'Balloon'
	  [],     [10],      'RPM change'
	  [],     [11],      'Clamping'
  	};
