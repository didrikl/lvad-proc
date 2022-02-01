Config.fs = 750;
Config.defFigRes = 300;
Config.experimentType = 'In vitro, model 2';
Config.experimentID = 'IV2';
Config.inletInnerDiamLVAD = 12.7;

% Reading/storage of each sequences
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

Config.idSpecs = init_id_specifications(Config.idSpecs_path);

Data.IV2.Config = Config;
