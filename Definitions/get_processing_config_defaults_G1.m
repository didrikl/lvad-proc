%% Defaults settings
function pc = get_processing_config_defaults_G1
	
	pc.experimentType = 'In vivo, porcine model 1';
	pc.experimentType = 'G1';

	pc.inletInnerDiamLVAD = 12.7;

	pc.fs = 750;
	pc.harmCut = 1;
	pc.harmCutFreqShift = 1;
	pc.cutFreq = 40;
	
	pc.defFigRes = 300;

	%Data.G1.Config = pc;
	
	% How to fuse data
	pc.interNoteInclSpec = 'nearest';
	pc.outsideNoteInclSpec = 'none';

	pc.labChart_varMapFile = 'VarMap_LabChart_G1';
	pc.systemM_varMapFile = 'VarMap_SystemM_G1';
	pc.notes_varMapFile = 'VarMap_Notes_G1_v1_0_0';

	pc.pGradVars = {'pMillar','pGraft'};

	pc.US_offsets = {};
	pc.US_drifts = {};
	pc.accChannelToSwap = {};
	pc.blocksForAccChannelSwap = [];
	pc.pChannelToSwap = {};
	pc.pChannelSwapBlocks = [];

	pc.data_basePath = 'D:\Data\IVS\Didrik\G1 - Data';

	% Output folder structure for each sequence
	pc.powerlab_subdir = 'Recorded\PowerLab';
	pc.ultrasound_subdir = 'Recorded\SystemM';
	pc.notes_subdir = 'Noted';

	pc.proc_subdir = 'Processed\';
	pc.proc_plot_subdir = 'Figures';
	pc.proc_stats_subdir = 'Processed\Statistics';

	pc.feats_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\G1 - Features';
	pc.stats_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\G1 - Statistics';
	pc.fig_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Figures\G1 - Figures';
	pc.idSpecs_path = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\G1 - ID Specifications.xlsx';