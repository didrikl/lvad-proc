%% Defaults settings
function Config =  get_processing_config_defaults_IV2B

	% Experiment info
	% --------------------------------------------------------------------------
	
	Config.experimentType = 'In vitro, model 2 - With driveline accelerometer';
	Config.experimentID = 'IV2B';


	% Signal processing settings
	% --------------------------------------------------------------------------
	
	Config.fs = 750;
	Config.harmCut = 0.1;
	Config.harmCutFreqShift = 0;
	Config.cutFreq = 0;
	Config.harmonicNotchFreqWidth = [1,1,1,2.5,1,1,1,1,1,1];
	Config.outlierStdevFactor = 2;
	Config.movStdWin = 10;
	
	% For RPM order map
	Config.rpmOrderMapRes = 0.011;
	Config.rpmOrderMapOverlapPst = 80;
	Config.rpmOrdersToTrack = [1 2 3 4 5];
	
	% For RPM order map visualization
	Config.rpmOrderMapScale = [-80, -45];
	Config.rpmOrderMapColorMapName = 'batlowW';
	Config.h3YLims = [-5,35];
	Config.curveYLims = [-100,85];
	Config.mapYLims = [0.75, 5.75];


	% Misc. settings
	% --------------------------------------------------------------------------
	
	Config.inletInnerDiamLVAD = 12.7;
	Config.defFigRes = 300;
	Config.speeds = [2200,2500,2800,3100];
	
	% How to init and fuse data
	% --------------------------------------------------------------------------
	
	Config.askToReInit = true;
	Config.interNoteInclSpec = 'nearest';
	Config.outsideNoteInclSpec = 'none';

	Config.pGradVars = {'p_aff', 'p_eff'};

	Config.labChart_varMapFile = 'VarMap_LabChart_IV2B';
	Config.systemM_varMapFile = 'VarMap_SystemM_IV2';
	Config.notes_varMapFile = 'VarMap_Notes_IV2_v1_0_0';


	% Paths
	% --------------------------------------------------------------------------
	
	Config.code_basePath = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab';
	Config.data_basePath = 'C:\Data\IVS\Didrik\IV2 - Data';

	% Output folder structure for each sequence
	Config.powerlab_subdir = 'Recorded\PowerLab';
	Config.ultrasound_subdir = 'Recorded\SystemM';
	Config.notes_subdir = 'Noted';

	Config.proc_subdir = 'Processed\';
	Config.proc_plot_subdir = 'Figures\';
	Config.proc_stats_subdir = 'Processed\Statistics';

	Config.feats_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\IV2B - Features';
	Config.stats_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\IV2B - Statistics';
	Config.fig_path      = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Figures\IV2B - Figures';
	Config.idSpecs_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\IV2 - ID Specifications.xlsx';