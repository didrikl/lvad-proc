%% Load previously preprocessed and stored data

run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Initialize\Environment.m')
Config =  get_processing_config_defaults_IV2;

sequences = {
	'IV2B_Seq6','Seq6 - LVAD8\Processed'
	'IV2B_Seq7','Seq7 - LVAD1\Processed'
	'IV2B_Seq9','Seq9 - LVAD6\Processed'
	'IV2B_Seq10','Seq10 - LVAD9\Processed'
	'IV2B_Seq11','Seq11 - LVAD10\Processed'
	'IV2B_Seq12','Seq12 - LVAD11\Processed'
	'IV2B_Seq13','Seq13 - LVAD12\Processed'
	'IV2B_Seq14','Seq14 - LVAD7\Processed'
	'IV2B_Seq18','Seq18 - LVAD14\Processed'
   	'IV2B_Seq19','Seq19 - LVAD13\Processed'
    };

whatToLoad = {'S','S_parts','Notes','Config'};

if not(exist('Data', 'var')), Data = struct; end
if not(isfield(Data, 'IV2B')), Data.IV2B = struct; end
Data.IV2B = load_processed_sequences(Data.IV2B, sequences(:,1),...
    fullfile(Config.data_basePath,sequences(:,2),sequences(:,1)), whatToLoad);

% [Data.IV2B, F, F_rel, F_del] = load_processed_features(Config, Data.IV2B);
% Data.IV2B = load_processed_statistics(Config, Data.IV2B);

clear sequences whatToLoad
