%% Calculate metrics of intervals tagged in the analysis_id column in Data
% -------------------------------------------------------------------------

% This defines the relevant ids for analysis
Config =  get_processing_config_defaults_IV2;
init_multiwaitbar_calc_stats
	
idSpecs = init_id_specifications(Config.idSpecs_path);
idSpecs = idSpecs(not(idSpecs.extra),:);
idSpecs = idSpecs(not(idSpecs.contingency),:);
idSpecs = idSpecs((ismember(idSpecs.interventionType,{'Control','Effect'})),:);

sequences = {
	'Seq6'
   	'Seq7'
   	'Seq9'
   	'Seq10'
   	'Seq11'
   	'Seq12'
   	'Seq13'
   	'Seq14'
   	'Seq18'
   	'Seq19'
	};


%% Make variable features of each intervention
% ---------------------------------------------

discrVars = {'Q_LVAD','P_LVAD'};
meanVars = {
% 	'p_eff'
% 	'pGrad'
	'Q'
% 	'accA_x'
% 	'accA_y'
% 	'accA_z'
 	'accA_norm_NF'
	'accA_x_NF'
	'accA_y_NF'
	'accA_z_NF'
	};
F = make_intervention_stats(Data.IV2, sequences, discrVars, meanVars, {}, {}, idSpecs);
F.P_LVAD_drop = -F.P_LVAD_mean;

% Add calculate band powers to the features
accVars = {...
	...'accA_x','accA_y','accA_z',...
	'accA_x_NF','accA_y_NF','accA_z_NF'};
hBands =  [1.10,2.9];
isHarmBand = true;
Pxx = make_power_spectra(Data.IV2, sequences, accVars, Config.fs, hBands, idSpecs, isHarmBand);
F = join(F, Pxx.bandMetrics, 'Keys',{'id','analysis_id'});

% Make relative and delta differences from baselines using id tags
nominalAsBaseline = true;
F_rel = calc_relative_feats(F, nominalAsBaseline);
F_del = calc_delta_diff_feats(F, nominalAsBaseline);

Data.IV2.idSpecs = idSpecs;
Data.IV2.Periodograms = Pxx;
Data.IV2.Features.Absolute = F;
Data.IV2.Features.Relative = F_rel;
Data.IV2.Features.Delta = F_del;


%% Descriptive stastistics over group of experiments
% ---------------------------------------------------

G = make_group_stats(F, idSpecs);
G_rel = make_group_stats(F_rel, idSpecs);
G_del = make_group_stats(F_del, idSpecs);

Data.G1.Feature_Statistics.Descriptive_Absolute = G;
Data.G1.Feature_Statistics.Descriptive_Relative = G_rel;
Data.G1.Feature_Statistics.Descriptive_Delta = G_del;


%% Hypothesis test
% -----------------

% Do Wilcoxens pair test and make table of median and p-values
pVars = {
%  	'accA_x_b1_pow'
% 	'accA_y_b1_pow'
% 	'accA_z_b1_pow'
% 	'accA_y_NF_stdev'
	'accA_x_NF_b1_pow'
	'accA_y_NF_b1_pow'
	'accA_z_NF_b1_pow'
	'accA_y_NF_stdev'
	'Q_mean'
	'P_LVAD_mean'
	'Q_LVAD_mean'
% 	'pGrad_mean'
	};

W = make_paired_features_for_signed_rank_test(F, pVars);
W_rel = make_paired_features_for_signed_rank_test(F_rel, pVars);

[P,R] = make_paired_signed_rank_test(W, G, pVars, 'IV2','pumpSpeed');
[P_rel, R_rel] = make_paired_signed_rank_test(W_rel, G_rel, pVars, 'IV2','pumpSpeed');

[balloonResults, clampResults] = compile_results_table_IV2(R, R_rel);

Data.G1.Features.Paired_Absolute = W;
Data.G1.Features.Paired_Relative = W_rel;
Data.G1.Feature_Statistics.Test_P_Values_Absolute = P;
Data.G1.Feature_Statistics.Test_P_Values_Relative = P_rel;
Data.G1.Feature_Statistics.Results = Results;


%% Calculate ROC curves and corresponding confidence intervals
% -------------------------------------------------------------

classifiers = {
%   'accA_y_b1_pow'
%  	'accA_x_b1_pow'
%  	'accA_z_b1_pow'
  	'accA_y_NF_b1_pow'
 	'accA_x_NF_b1_pow'
 	'accA_z_NF_b1_pow'
	'P_LVAD_mean'
	'P_LVAD_drop'
	};

% Input for states of pooled occlusions above a threshold
%{
predStateVar = 'pooledDiam';
predStates = {
	%2, '>= 4.73mm'
	4, '>= 6.6mm'
	6, '>= 8.52mm'
	%7, '>= 9mm'
	%8, '>= 10mm'
	9, '>= 11mm'
	};
pooled = true;
%}
	
% Input for states of concrete occlusions 
predStateVar = 'levelLabel';
predStates = {
	%'Inflated, 4.73 mm', 'Catheter 1'
	'Inflated, 6.60 mm', 'Catheter 2'
	'Inflated, 8.52 mm', 'Catheter 3'
	%'Inflated, 9 mm',    'Catheter 4'
	%'Inflated, 10 mm',   'catheter 4'
	'Inflated, 11 mm',   'Catheter 4'
	};
pooled = false;

[ROC,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
	F, classifiers, predStateVar, predStates, pooled);

% Prepare feature table for ROC analysis in SPSS, and for pooled diameter states
F_ROC_SPSS = make_tables_for_ROC_analysis_in_SPSS(F);
F_ROC = make_table_for_pooled_ROC_analysis(F,F_del);

Data.IV2.Feature_Statistics.ROC = ROC;
Data.IV2.Feature_Statistics.AUC = AUC;
Data.IV2.Features.Absolute_SPSS_ROC = F_ROC_SPSS;
Data.IV2.Features.Absolute_Pooled_ROC = F_ROC;


%% Save
% ------
save_data('Features', Config.feats_path, Data.IV2.Features, {'matlab'});
save_data('Feature_Statistics', Config.stats_path, Data.IV2.Feature_Statistics, {'matlab'});
save_features_as_separate_spreadsheets(Data.IV2.Features, Config.feats_path);
save_statistics_as_separate_spreadsheets(Data.IV2.Feature_Statistics, Config.stats_path);


%% Roundup
% ---------

multiWaitbar('CloseAll');
clear save_data
clear discrVars meanVars accVars hBands isHarmBand G G_rel G_del F F_rel F_del ...
	pVars pooled classifiers predStateVar predStates ROC F_ROC F_ROC_SPSS AUC ...
	idSpecs
