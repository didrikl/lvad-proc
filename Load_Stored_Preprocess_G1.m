% Load previously preprocessed and stored data
run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Environment.m')
pc = get_processing_config_defaults_G1;
	
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
Data.G1 = load_processed_sequences(sequences(:,1),...
    fullfile(pc.data_basePath,sequences(:,2),sequences(:,1)));

[Data.G1, F, F_rel, F_del] = load_processed_features(pc, Data.G1);
Data.G1 = load_processed_statistics(pc, Data.G1);
%Data.G1 = load_config(pc, Data.G1);

clear sequences pc
