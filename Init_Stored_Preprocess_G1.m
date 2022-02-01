% Load previously preprocessed and stored data
run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Environment.m')
G1_Config

sequences = {
    'G1_Seq3', 'Seq3 - LVAD6 - Pilot\Processed'
    'G1_Seq6', 'Seq6 - LVAD7\Processed'
 	'G1_Seq7', 'Seq7 - LVAD11\Processed'
 	'G1_Seq8', 'Seq8 - LVAD1\Processed'
 	'G1_Seq11','Seq11 - LVAD13\Processed'
 	'G1_Seq12','Seq12 - LVAD17\Processed'
 	'G1_Seq13','Seq13 - LVAD16\Processed'
 	'G1_Seq14','Seq14 - LVAD9\Processed'
 	};
Data.IV2 = load_processed_sequences(sequences(:,1),...
    fullfile(Config.data_basePath,sequences(:,2),sequences(:,1)));

% Load previously calculated features for analysis
Data.IV2.Features = load(fullfile(Config.feats_path,'Features'),'Features');
Data.IV2.Statistics = load(fullfile(Config.stats_path,'Feature_Statistics'),'Feature_Statistics');

clear sequences
