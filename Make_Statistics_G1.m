+%% Calculate metrics of intervals tagged in the analysis_id column in Data

% This defines the relevant ids for analysis
Config =  get_processing_config_defaults_G1;
init_multiwaitbar_calc_stats
	
idSpecs = init_id_specifications(Config.idSpecs_path);
idSpecs = idSpecs(not(idSpecs.extra),:);
idSpecs = idSpecs(not(contains(string(idSpecs.analysis_id),{'E'})),:);
idSpecs = idSpecs(not(contains(string(idSpecs.categoryLabel),{'Injection'})),:);
%idSpecs = idSpecs((ismember(idSpecs.interventionType,{'Control','Effect'})),:);

sequences = {
	'Seq3' % (pilot)
 	'Seq6'
  	'Seq7'
  	'Seq8'
  	'Seq11'
	'Seq12'
  	'Seq13'
  	'Seq14'
	};

Data.G1.Features.idSpecs = idSpecs;
Data.G1.Features.sequences = sequences;

%% Make variable features of each intervention
% -----------------------------------------------------------

discrVars = {
	'Q_LVAD'
	'P_LVAD'
 	'balDiam_xRay'
 	'balHeight_xRay'
 	'arealObstr_xRay_pst' 
	'p_maxArt'
	'p_minArt'
	'MAP'
	'p_maxPulm'
	'p_minPulm'
	'HR'
	'CVP'
	'SvO2'
	'graftEmboliVol'
 	'CO'
    };
meanVars = {
	%'accA_x_NF_HP'    % to get stddev
	%'accA_y_NF_HP'    % to get stddev
	%'accA_z_NF_HP'    % to get stddev
	%'accA_norm_NF_HP' % to get stddev
	'pGraft'
	'pMillar'
	'Q'
	};
minMaxVars = {
	'Q'
	};
F = make_intervention_stats(Data.G1, sequences, discrVars, meanVars, {}, minMaxVars, idSpecs);

% Calculate NHA as band powers
accVars = {
	'accA_x_NF_HP'
	'accA_y_NF_HP'
	'accA_z_NF_HP'
	'accA_norm_NF_HP'
	};
hBands = [
	1.20, 7
	1.20, 3.85
	];
isHarmBand = true;
Pxx = make_power_spectra(Data.G1, sequences, accVars, Config.fs, hBands, idSpecs, isHarmBand);

% Report NHA as g^2/kHz instead of g^2/Hz
Pxx.bandMetrics{:,vartype('numeric')} = 1000*Pxx.bandMetrics{:,vartype('numeric')};

% Add derived features
F = join(F, Pxx.bandMetrics, 'Keys',{'analysis_id','id'});
F.Q_CO_pst = 100*(F.Q_mean./F.CO_mean);
F.P_LVAD_drop = -F.P_LVAD_mean;

% Define F exclude map
% F.Q_stddev

% Add derived best axes based on highest absolute NHA values
vars = {'accA_x_NF_HP_b2_pow','accA_y_NF_HP_b2_pow','accA_z_NF_HP_b2_pow'};
newVar = 'accA_best_NF_HP_b2_pow';
F = derive_best_axis_values(F, vars, newVar, sequences);
vars = {'accA_x_NF_HP_b3_pow','accA_y_NF_HP_b3_pow','accA_z_NF_HP_b3_pow'};
newVar = 'accA_best_NF_HP_b3_pow';
F = derive_best_axis_values(F, vars, newVar, sequences);

% Add aggregated (sum and norm) bandbower over x, y, and z
F.accA_xyz_NF_HP_b2_pow_sum = sum([F.accA_x_NF_HP_b2_pow,F.accA_y_NF_HP_b2_pow,F.accA_z_NF_HP_b2_pow],2);
F.accA_xzy_NF_HP_b3_pow_sum = sum([F.accA_x_NF_HP_b3_pow,F.accA_y_NF_HP_b3_pow,F.accA_z_NF_HP_b3_pow],2);
F.accA_xyz_NF_HP_b2_pow_norm = sqrt( sum( F{:,{'accA_x_NF_HP_b2_pow','accA_y_NF_HP_b2_pow','accA_z_NF_HP_b2_pow'}}.^2,2));
F.accA_xyz_NF_HP_b3_pow_norm = sqrt( sum( F{:,{'accA_x_NF_HP_b3_pow','accA_y_NF_HP_b3_pow','accA_z_NF_HP_b3_pow'}}.^2,2));

Data.G1.Periodograms = Pxx;
Data.G1.Features.Absolute = F;


% Make relative and delta differences from baselines using id tags
% -----------------------------------------------------------

nominalAsBaseline = true;
F_rel = calc_relative_feats(F, nominalAsBaseline);
F_del = calc_delta_diff_feats(F, nominalAsBaseline);

Data.G1.Features.Relative = F_rel;
Data.G1.Features.Delta = F_del;


% Descriptive stastistics over group of experiments
% -----------------------------------------------------------

G = make_group_stats(F, idSpecs, sequences);
G_rel = make_group_stats(F_rel, idSpecs, sequences);
G_del = make_group_stats(F_del, idSpecs, sequences);

Data.G1.Feature_Statistics.Descriptive_Absolute = G;
Data.G1.Feature_Statistics.Descriptive_Relative = G_rel;
Data.G1.Feature_Statistics.Descriptive_Delta = G_del;


%% Hypothesis test
% -----------------------------------------------------------

% Do Wilcoxens pair test and make table of median and p-values
pVars = {
	'accA_x_NF_HP_b2_pow'
	'accA_y_NF_HP_b2_pow'
	'accA_z_NF_HP_b2_pow'
	'accA_best_NF_HP_b2_pow'
	'accA_best_NF_HP_b2_pow_per_speed'
	'sumNHA'
	'normNHA'
	'Q_mean'
	'P_LVAD_mean'
	'Q_LVAD_mean'
	'pGraft_mean'
};

W = make_paired_features_for_signed_rank_test(F, pVars);
W_rel = make_paired_features_for_signed_rank_test(F_rel, pVars);
[P,R] = make_paired_signed_rank_test(W, G, pVars, 'G1', 'pumpSpeed');
[P_rel,R_rel] = make_paired_signed_rank_test(W_rel, G_rel, pVars, 'G1', 'pumpSpeed');

Data.G1.Features.Paired_Absolute = W;
Data.G1.Features.Paired_Relative = W_rel;
Data.G1.Feature_Statistics.Test_P_Values_Absolute = P;
Data.G1.Feature_Statistics.Test_P_Values_Relative = P_rel;


%% One sorted and combined results table with absolute and relative results

levSortOrder = {
	'RPM, Nominal'
	'RPM, Nominal #2'
	'Balloon, Nominal'
	'Balloon, Lev1'
	'Balloon, Lev2'
	'Balloon, Lev3'
	'Balloon, Lev4'
	'Balloon, Lev5'
	'Balloon, Reversal'
	'Clamp, Nominal'
	'Clamp,  25%'
	'Clamp,  50%'
	'Clamp,  75%'
	'Clamp, Reversal'
	};
relVars = {
	'Q_LVAD_mean'
	'P_LVAD_mean'
	'Q_mean'
	'pGraft_mean'
	};

F.levelLabel = categorical(F.levelLabel, levSortOrder, 'Ordinal',true);
F_rel.levelLabel = categorical(F_rel.levelLabel, levSortOrder, 'Ordinal',true);
F_del.levelLabel = categorical(F_del.levelLabel, levSortOrder, 'Ordinal',true);
Data.G1.Features.Absolute = F;
Data.G1.Features.Relative = F_rel;
Data.G1.Features.Delta = F_del;


G.levelLabel = categorical(G.levelLabel, levSortOrder, 'Ordinal',true);
G_rel.levelLabel = categorical(G_rel.levelLabel, levSortOrder, 'Ordinal',true);
G_del.levelLabel = categorical(G_del.levelLabel, levSortOrder, 'Ordinal',true);
Data.G1.Feature_Statistics.Descriptive_Absolute = G;
Data.G1.Feature_Statistics.Descriptive_Relative = G_rel;
Data.G1.Feature_Statistics.Descriptive_Delta = G_del;

R.pumpSpeed = categorical(R.pumpSpeed, [2400,2600,2200], 'Ordinal',true);
R.levelLabel = categorical(R.levelLabel, levSortOrder, 'Ordinal',true);
R_rel.pumpSpeed = categorical(R_rel.pumpSpeed, [2400,2600,2200], 'Ordinal',true);
R_rel.levelLabel = categorical(R_rel.levelLabel, levSortOrder, 'Ordinal',true);
R = sortrows(R, {'pumpSpeed','levelLabel'});
R = join(R,R_rel, 'Keys',{'pumpSpeed','levelLabel'}, 'RightVariables',relVars);

Data.G1.Feature_Statistics.Results = R;


%% Calculate ROC curves and corresponding confidence intervals
% -----------------------------------------------------------
classifiers = {
'sumNHA'
'normNHA'
'accA_best_NF_HP_b2_pow_per_speed'
 	'accA_best_NF_HP_b2_pow'
 	'accA_x_NF_HP_b2_pow'
 	'accA_z_NF_HP_b2_pow'
	'accA_y_NF_HP_b2_pow'
	'P_LVAD_drop'
	'accA_best_NF_HP_b3_pow_per_speed'
	'accA_best_NF_HP_b3_pow'
 	'accA_x_NF_HP_b3_pow'
 	'accA_z_NF_HP_b3_pow'
	'accA_y_NF_HP_b3_pow'
	};
bestAxVars = {
 'accA_best_NF_HP_b2_pow'
  	'accA_best_NF_HP_b3_pow'
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
	'Balloon, Lev1', '\bf34%-47%\rm\newlineobstruction'
	'Balloon, Lev2', '\bf52%-64%\rm\newlineobstruction'
	'Balloon, Lev3', '\bf65%-72%\rm\newlineobstruction'
	'Balloon, Lev4', '\bf78%-84%\rm\newlineobstruction'
	%'Balloon, Lev5', '\bf85%-94%\rm\newlineobstruction'
	};
pooled = false;

%TODO: Do pooled ROC calculations
%TODO: Lookup corresponding BL for "best" axis.
[ROC,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
	F, classifiers, predStateVar, predStates, pooled, bestAxVars);

Data.G1.Feature_Statistics.ROC = ROC;
Data.G1.Feature_Statistics.AUC = AUC;

% TODO: Make different versions for IV2 and for G1:
% Prepare feature table for ROC analysis in SPSS, and for pooled diameter states
%F_ROC_SPSS = make_tables_for_ROC_analysis_in_SPSS(F);
%F_ROC = make_table_for_pooled_ROC_analysis(F,F_del);
Data.G1.Features.Absolute_SPSS_ROC = F_ROC_SPSS;
Data.G1.Features.Absolute_Pooled_ROC = F_ROC;


%% Save and roundup
% -----------------------------------------------------------

%save_data('Periodograms', feats_path, Data.G1.Periodograms, {'matlab'});
save_data('Features', Config.feats_path, Data.G1.Features, {'matlab'});
save_data('Feature_Statistics', Config.stats_path, Data.G1.Feature_Statistics, {'matlab'});
save_features_as_separate_spreadsheets(Data.G1.Features, Config.feats_path);
save_statistics_as_separate_spreadsheets(Data.G1.Feature_Statistics, Config.stats_path);

multiWaitbar('CloseAll');
clear save_data check_table_var_input
%clear F G F_rel G_rel F_del G_del 
clear Pxx idSpecs
clear discrVars meanVars accVars hBands  pVars nominalAsBaseline levSortOrder...
	pooled classifiers predStateVar predStates ROC F_ROC F_ROC_SPSS AUC ...
	sequences isHarmBand W W_rel relVars newVar vars ans
