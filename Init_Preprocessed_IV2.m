% Load previously preprocessed and stored data

run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Environment.m')
Environment_Analysis_IV2
Definitions.idSpecs = init_id_specifications(idSpecs_path);

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
    fullfile(data_basePath,sequences(:,2),sequences(:,1)));

% Load previously calculated features for analysis
load(fullfile(feats_path,'Features'));
load(fullfile(stats_path,'Statistics'));

multiWaitbar('CloseAll');
clear sequences
