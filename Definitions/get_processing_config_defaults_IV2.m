%% Defaults settings
function Config =  get_processing_config_defaults_IV2

	% Experiment info
	% --------------------------------------------------------------------------
	
	Config.experimentType = 'In vitro, model 2';
	Config.experimentID = 'IV2';


	% Constants
	% --------------------------------------------------------------------------
	
	Config.inletInnerDiamLVAD = 12.7;
	

	% Signal processing settings
	% --------------------------------------------------------------------------
	
	Config.fs = 750;
	

	% Misc. settings
	% --------------------------------------------------------------------------
	
	Config.defFigRes = 300;

	
	% How to init and fuse data
	% --------------------------------------------------------------------------
	
	Config.askToReInit = true;
	Config.interNoteInclSpec = 'nearest';
	Config.outsideNoteInclSpec = 'none';

	Config.pGradVars = {'p_aff', 'p_eff'};

	Config.labChart_varMapFile = 'VarMap_LabChart_IV2';
	Config.systemM_varMapFile = 'VarMap_SystemM_IV2';
	Config.notes_varMapFile = 'VarMap_Notes_IV2_v1_0_0';


	% Paths
	% --------------------------------------------------------------------------
	
	Config.code_basePath = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab';
	Config.data_basePath = 'D:\Data\IVS\Didrik\IV2 - Data';

	% Output folder structure for each sequence
	Config.powerlab_subdir = 'Recorded\PowerLab';
	Config.ultrasound_subdir = 'Recorded\SystemM';
	Config.notes_subdir = 'Noted';

	Config.proc_subdir = 'Processed\';
	Config.proc_plot_subdir = 'Figures';
	Config.proc_stats_subdir = 'Processed\Statistics';

	Config.feats_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\IV2 - Features';
	Config.stats_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\IV2 - Statistics';
	Config.fig_path      = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Figures\IV2 - Figures';
	Config.idSpecs_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\IV2 - ID Specifications.xlsx';