%% Defaults settings
function Config =  get_processing_config_defaults_G1B1
	
	% Experiment info
	% --------------------------------------------------------------------------
	
	Config.experimentType = 'Porcine model G1B1, injections with driveline accelerometer';
	Config.experimentID = 'G1B1';
	Config.seq = '';
	

	% Signal processing settings
	% --------------------------------------------------------------------------
	
	Config.fs = 750;
	Config.harmCut = 1.25;
	Config.harmCutFreqShift = 0;
	Config.cutFreq = 40;
	Config.harmonicNotchFreqWidth = [1,1,1,2.5,1,1,1,1,1,1];
	Config.outlierStdevFactor = 2;
	Config.movStdWin = 10;
	
	% For RPM order map
	Config.rpmOrderMapRes = 0.011;
	Config.rpmOrderMapOverlapPst = 80;
	%Config.rpmOrdersToTrack = [2.95, 3, 3.05];
	
	% For RPM order map visualization
	Config.rpmOrderMapScale = [-85, -55];
	Config.rpmOrderMapColorMapName = 'batlowW';
    %Config.h3YLims = [-5,35];


	% Misc. settings
	% --------------------------------------------------------------------------
	
	Config.inletInnerDiamLVAD = 12.7;
	Config.balLevDiamLims = [2,7.4,9,10.2,11,11.6,12.7];
	
	Config.defFigRes = 300;
	Config.speeds = [2200,2400,2600];
	Config.partSpec = {
		%   BL    parts   Label
		[],   [],   'RPM'
		[],   [],   'Clamp'
		[],   [],   'RPM #2'
		[],   [],   'Balloon'
		[],   [],   'Balloon'
		[],   [],   'Balloon'
		};

	% How to init and fuse data
	% --------------------------------------------------------------------------
	
	Config.askToReInit = true;
	Config.interNoteInclSpec = 'nearest';
	Config.outsideNoteInclSpec = 'none';

	Config.labChart_varMapFile = 'VarMap_LabChart_G1B';
	Config.systemM_varMapFile = 'VarMap_SystemM_G1';
	Config.notes_varMapFile = 'VarMap_Notes_G1_v1_0_0';

	Config.pGradVars = {'pMillar','pGraft'};
    
	Config.remEchoRows = true;


	% List of possible fixes and ajustments
	% ----------------------------------------------------------------------- ---
	
	Config.US_offsets = {}; % negative number: shift graph towards right
	Config.US_drifts = {};
	Config.PL_offset = [];
	Config.PL_offset_files = {};
	
	Config.accChannelToSwap = {};
	Config.blocksForAccChannelSwap = [];
	Config.pChannelToSwap = {};
	Config.pChannelSwapBlocks = [];
	Config.channelToExcl = {};
	Config.channelExclRanges = {};


	% Paths
	% --------------------------------------------------------------------------
	
	Config.code_basePath = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab';
	Config.data_basePath = 'C:\Data\IVS\Didrik\G1 - Data';

	% Output folder structure for each sequence
	Config.powerlab_subdir = 'Recorded\PowerLab';
	Config.ultrasound_subdir = 'Recorded\SystemM';
	Config.notes_subdir = 'Noted';

	Config.proc_subdir = 'Processed\';
	Config.proc_plot_subdir = 'Figures\G1B1';
	
	Config.feats_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\G1B1 - Features';
	Config.stats_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\G1B1 - Statistics';
	Config.fig_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Figures\G1B1 - Figures';
	
    Config.idSpecs_path = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\G1 - ID Specifications.xlsx';