%% Sequence definitions and correction inputs

% Experiment sequence ID
Config.seq = 'G1B_Seq13';

% Folder in base path
Config.seq_subdir = 'Seq13 - LVAD16';

% Which files to input from input directory
Config.labChart_fileNames = {
    
    % RPM + Insertion
	% ----------------
    %'G1_Seq13 - F1 [accA].mat'
    %'G1_Seq13 - F1 [accB].mat'
    %'G1_Seq13 - F1 [pGraft,ECG,pLV].mat'
    %'G1_Seq13 - F1 [V1,V2,V3].mat'
    %'G1_Seq13 - F1 [I1,I2,I3].mat'
   
	% Balloon @ 2400 RPM
	% -------------------
	%'G1_Seq13 - F2 [accA].mat'
    %'G1_Seq13 - F2 [accB].mat'
    %'G1_Seq13 - F2 [pGraft,ECG,pLV].mat'
    %'G1_Seq13 - F2 [V1,V2,V3].mat'
    %'G1_Seq13 - F2 [I1,I2,I3].mat'
    
	% Balloon @ [2200,2600]
	% ----------------------
	%'G1_Seq13 - F3 [accA].mat'
    %'G1_Seq13 - F3 [accB].mat'
    %'G1_Seq13 - F3 [pGraft,ECG].mat'
    %'G1_Seq13 - F3 [V1,V2,V3].mat'
    %'G1_Seq13 - F3 [I1,I2,I3].mat'
    
	% Clamping + Injections 1-5
	% --------------------------
	'G1_Seq13 - F4 [accA].mat'
    'G1_Seq13 - F4 [accB].mat'
    %'G1_Seq13 - F4 [pGraft,ECG].mat'
    %'G1_Seq13 - F4 [V1,V2,V3].mat'
    %'G1_Seq13 - F4 [I1,I2,I3].mat'
    
	% Injections 6-11
	% -------------------------
	'G1_Seq13 - F5 [accA].mat'
    'G1_Seq13 - F5 [accB].mat'
    %'G1_Seq13 - F5 [pGraft,ECG].mat'
    %'G1_Seq13 - F5 [V1,V2,V3].mat'
    %'G1_Seq13 - F5 [I1,I2,I3].mat'
    
	% ???
	% ----------------------
	'G1_Seq13 - F6 [accA].mat'
    'G1_Seq13 - F6 [accB].mat'
    %'G1_Seq13 - F6 [pGraft,ECG].mat'
    %'G1_Seq13 - F6 [V1,V2,V3].mat'
    %'G1_Seq13 - F6 [I1,I2,I3].mat'
	
    };
Config.notes_fileName = 'G1_Seq13 - Notes G1 v1.0.0 - Rev4.xlsm';
Config.ultrasound_fileNames = {'ECM_2021_01_14__11_41_52.wrf'};

% Correction input
Config.US_offsets = {-0.5};
Config.US_drifts = {40};
Config.accChannelToSwap = {};
Config.blocksForAccChannelSwap = [];
Config.pChannelToSwap = {};
Config.pChannelSwapBlocks = [];
Config.PL_offset = [];
Config.PL_offset_files = {};

% Parts (or combined parts) for assessments
Config.partSpec = {
 	% BL      Parts          Label 
	% ---------------------------------
	%[],       [2],           'RPM change'
	%[],       [4],           'Balloon'
	%[],       [5],           'Balloon'
	%[],       [6],           'Balloon'
	%[],       [7],           'Clamping'
	%[],       [8,9,10,11],   'Injection [Sal,1,2,3]'
	%[11,121], [12,13,14,15], 'Injection [4,5,6,7]'
	%[15,149], [16,17,18,19], 'Injection [8,9,10,11]'
	[],        [9:19],        'Injection [1-11]'
	};
