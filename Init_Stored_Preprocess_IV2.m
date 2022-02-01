% Load previously preprocessed and stored data
run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Environment.m')
IV2_Config

sequences = {
    'IV2_Seq6','Seq6 - LVAD8\Processed'
    'IV2_Seq7','Seq7 - LVAD1\Processed'
% 	'IV2_Seq9','Seq9 - LVAD6\Processed'
% 	'IV2_Seq10','Seq10 - LVAD9\Processed'
% 	'IV2_Seq11','Seq11 - LVAD10\Processed'
% 	'IV2_Seq12','Seq12 - LVAD11\Processed'
% 	'IV2_Seq13','Seq13 - LVAD12\Processed'
% 	'IV2_Seq14','Seq14 - LVAD7\Processed'
% 	'IV2_Seq18','Seq18 - LVAD14\Processed'
% 	'IV2_Seq19','Seq19 - LVAD13\Processed'
    };
Data.IV2 = load_processed_sequences(sequences(:,1),...
    fullfile(Config.data_basePath,sequences(:,2),sequences(:,1)));

% Load previously calculated features for analysis
Data.IV2.Features = load(fullfile(Config.feats_path,'Features'),'Features');
Data.IV2.Statistics = load(fullfile(Config.stats_path,'Feature_Statistics'),'Feature_Statistics');

clear sequences
