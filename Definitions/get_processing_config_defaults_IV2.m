%% Defaults settings
function pc = get_processing_config_defaults_IV2
	pc.experimentID = 'IV2';

	% How to fuse data
	pc.interNoteInclSpec = 'nearest';
	pc.outsideNoteInclSpec = 'none';

	pc.pGradVars = {'p_aff', 'p_eff'};

	pc.labChart_varMapFile = 'VarMap_LabChart_IV2';
	pc.systemM_varMapFile = 'VarMap_SystemM_IV2';
	pc.notes_varMapFile = 'VarMap_Notes_IV2_v1_0_0';

	% Reading/storage of each sequences
	pc.data_basePath = 'D:\Data\IVS\Didrik\IV2 - Data';

	% Output folder structure for each sequence
	pc.powerlab_subdir = 'Recorded\PowerLab';
	pc.ultrasound_subdir = 'Recorded\SystemM';
	pc.notes_subdir = 'Noted';

	pc.proc_subdir = 'Processed\';
	pc.proc_plot_subdir = 'Figures';
	pc.proc_stats_subdir = 'Processed\Statistics';

	pc.feats_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\IV2 - Features';
	pc.stats_path    = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\IV2 - Statistics';
	pc.fig_path      = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Figures\IV2 - Figures';
	pc.idSpecs_path  = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\IV2 - ID Specifications.xlsx';