Config.experimentType = 'In vivo, porcine model 1';
Config.experimentID = 'G1';

Config.inletInnerDiamLVAD = 12.7;

Config.fs = 750;
Config.harmCut = 1;
Config.harmCutFreqShift = 1;
Config.cutFreq = 40;
Config.defFigRes = 300;

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

Config.idSpecs = init_id_specifications(Config.idSpecs_path);

Data.G1.Config = Config;
