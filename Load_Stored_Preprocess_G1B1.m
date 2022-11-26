%% Load previously preprocessed and stored data

run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Initialize\Environment.m')
Config =  get_processing_config_defaults_G1B1;

sequences = {
 	'G1B1_Seq6', 'Seq6 - LVAD7\Processed'
 	'G1B1_Seq7', 'Seq7 - LVAD11\Processed'
 	'G1B1_Seq8', 'Seq8 - LVAD1\Processed'
 	'G1B1_Seq10','Seq10 - LVAD14 - Terminated\Processed'
 	'G1B1_Seq11','Seq11 - LVAD13\Processed'
 	'G1B1_Seq12','Seq12 - LVAD17\Processed'
 	'G1B1_Seq13','Seq13 - LVAD16\Processed'
	};

whatToLoad = {'S','S_parts','Notes','Config'};

if not(exist('Data', 'var')), Data = struct; end
if not(isfield(Data, 'G1B1')), Data.G1B1 = struct; end
Data.G1B1 = load_processed_sequences(Data.G1B1, sequences(:,1),...
	fullfile(Config.data_basePath,sequences(:,2),sequences(:,1)), whatToLoad);

% [Data.G1B1, F, F_rel, F_del] = load_processed_features(Config, Data.G1B1);
% Data.G1B1 = load_processed_statistics(Config, Data.G1B1);

clear sequences pc whatToLoad
