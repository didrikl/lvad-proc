%% Defaults settings
function Config =  get_processing_config_defaults_G1
	
	% Experiment info
	% --------------------------------------------------------------------------
	
	Config.experimentType = 'In vivo, porcine model 1';
	Config.experimentID = 'G1';


	% Signal processing settings
	% --------------------------------------------------------------------------
	
	Config.fs = 750;
	Config.harmCut = 1.15;
	Config.harmCutFreqShift = 0;
	Config.cutFreq = 40;
	Config.harmonicNotchFreqWidth = [1,1,1,2.5,1,1,1,1,1,1];

	% Misc. settings
	% --------------------------------------------------------------------------
	
	Config.inletInnerDiamLVAD = 12.7;
	Config.defFigRes = 300;
	Config.speeds = [2200,2400,2600];

	
	% How to init and fuse data
	% --------------------------------------------------------------------------
	
	Config.askToReInit = true;
	Config.interNoteInclSpec = 'nearest';
	Config.outsideNoteInclSpec = 'none';

	Config.labChart_varMapFile = 'VarMap_LabChart_G1';
	Config.systemM_varMapFile = 'VarMap_SystemM_G1';
	Config.notes_varMapFile = 'VarMap_Notes_G1_v1_0_0';

	Config.pGradVars = {'pMillar','pGraft'};
    
	Config.remEchoRows = true;


	% List of possible fixes and ajustments
	% ----------------------------------------------------------------------- ---
	
	Config.US_offsets = {};
	Config.US_drifts = {};
	Config.accChannelToSwap = {};
	Config.blocksForAccChannelSwap = [];
	Config.pChannelToSwap = {};
	Config.pChannelSwapBlocks = [];
	Config.channelToExcl = {};
	Config.channelExclRanges = {};

	Config.levLims = [2,7.4,9,10.2,11,11.70,12.7];
	

	% Paths
	% --------------------------------------------------------------------------
	
	Config.code_basePath = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab';
	Config.data_basePath = 'D:\Data\IVS\Didrik\G1 - Data';

	% Output folder structure for each sequence
	Config.powerlab_subdir = 'Recorded\PowerLab';
	Config.ultrasound_subdir = 'Recorded\SystemM';
	Config.notes_subdir = 'Noted';

	Config.proc_subdir = 'Processed\';
	Config.proc_plot_subdir = 'Figures';
	Config.proc_stats_subdir = 'Processed\Statistics';

	Config.feats_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\G1 - Features';
	Config.stats_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\G1 - Statistics';
	Config.fig_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Figures\G1 - Figures';
	Config.idSpecs_path = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\G1 - ID Specifications.xlsx';