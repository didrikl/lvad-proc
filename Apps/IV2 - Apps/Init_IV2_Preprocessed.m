
%% Load previously preprocessed and stored data

idSpecs = init_id_specifications(idSpecs_path);

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
Data = load_processed_sequences(sequences(:,1),...
    fullfile(data_basePath,sequences(:,2),sequences(:,1)),'S');

Data = load_processed_sequences(sequences(:,1),...
    fullfile(data_basePath,sequences(:,2),sequences(:,1)),'S_parts');

% Load previously calculated features for analysis
load(fullfile(feats_path,'Features'))
load(fullfile(feats_path,'Features - All'))
load(fullfile(feats_path,'Features - ROC'))
load(fullfile(feats_path,'Features - Relative'))
load(fullfile(feats_path,'Features - Delta'))
load(fullfile(feats_path,'Features - Paired for Wilcoxens signed rank test'));

load(fullfile(stats_path,'Group stats tables - Relative'));
load(fullfile(stats_path,'Group stats tables'));
load(fullfile(stats_path,'Group stats tables - Relative'));
load(fullfile(stats_path,'Results - p-values - Wilcoxon paired signed rank test'));
load(fullfile(stats_path,'Results - Median and p-values - Wilcoxon paired signed rank test'));
load(fullfile(stats_path,'Results - Selected median and p-values - Wilcoxon paired signed rank test'));
multiWaitbar('CloseAll');
