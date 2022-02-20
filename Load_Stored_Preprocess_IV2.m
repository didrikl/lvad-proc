% Load previously preprocessed and stored data
run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Environment.m')
Config =  get_processing_config_defaults_IV2;

sequences = {
    'IV2_Seq6','Seq6 - LVAD8\Processed'
    'IV2_Seq7','Seq7 - LVAD1\Processed'
 	'IV2_Seq9','Seq9 - LVAD6\Processed'
 	'IV2_Seq10','Seq10 - LVAD9\Processed'
 	'IV2_Seq11','Seq11 - LVAD10\Processed'
 	'IV2_Seq12','Seq12 - LVAD11\Processed'
 	'IV2_Seq13','Seq13 - LVAD12\Processed'
 	'IV2_Seq14','Seq14 - LVAD7\Processed'
 	'IV2_Seq18','Seq18 - LVAD14\Processed'
 	'IV2_Seq19','Seq19 - LVAD13\Processed'
    };
Data.IV2 = load_processed_sequences(sequences(:,1),...
    fullfile(Config.data_basePath,sequences(:,2),sequences(:,1)));

[Data.IV2, F, F_rel, F_del] = load_processed_features(Config, Data.IV2);
Data.IV2 = load_processed_statistics(Config, Data.IV2);
Data.IV2 = load_config(Config, Data.IV2);

clear sequences
