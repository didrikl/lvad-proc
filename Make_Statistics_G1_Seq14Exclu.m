%% Calculate metrics of intervals tagged in the analysis_id column in Data

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

%%
F2 = F; 

% Exclude friction
F2(contains(F2.id,'Seq14_Bal'),:) = [];

% Make relative and delta differences from baselines using id tags
% -----------------------------------------------------------

nominalAsBaseline = true;
F2_rel = calc_relative_feats(F2, nominalAsBaseline);
F2_del = calc_delta_diff_feats(F2, nominalAsBaseline);


%% Descriptive stastistics over group of experiments
% -----------------------------------------------------------

G2 = make_group_stats(F2, idSpecs, sequences);
G2_rel = make_group_stats(F2_rel, idSpecs, sequences);
G2_del = make_group_stats(F2_del, idSpecs, sequences);


% Hypothesis test
% -----------------------------------------------------------

% Do Wilcoxens pair test and make table of median and p-values
pVars = {
	'accA_x_NF_HP_b1_pow'
	'accA_y_NF_HP_b1_pow'
	'accA_z_NF_HP_b1_pow'
	'accA_xyz_NF_HP_b1_pow_sum'
	'accA_xyz_NF_HP_b1_pow_norm'
	'accA_best_NF_HP_b1_pow'
	'accA_best_NF_HP_b1_pow_per_speed'
% 	'accA_x_NF_HP_b3_pow'
% 	'accA_y_NF_HP_b3_pow'
% 	'accA_z_NF_HP_b3_pow'
% 	'accA_xyz_NF_HP_b3_pow_sum'
% 	'accA_xyz_NF_HP_b3_pow_norm'
% 	'accA_best_NF_HP_b3_pow'
% 	'accA_best_NF_HP_b3_pow_per_speed'
	'Q_mean'
	'P_LVAD_mean'
	'Q_LVAD_mean'
	'pGraft_mean'
};

W2 = make_paired_features_for_signed_rank_test(F2, pVars);
W2_rel = make_paired_features_for_signed_rank_test(F2_rel, pVars);
[P2,R2] = make_paired_signed_rank_test(W2, G2, pVars, 'G1', 'pumpSpeed');
[P2_rel,R2_rel] = make_paired_signed_rank_test(W2_rel, G2_rel, pVars, 'G1', 'pumpSpeed');


% One sorted and combined results table with absolute and relative results
levOrder = {
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
rpmOrder = [2400,2600,2200];

[F2, F2_rel, F2_del, G2, G2_rel, G2_del] = sort_by_level_order(...
	F2, levOrder, F2_rel, F2_del, G2, G2_rel, G2_del);
R2 = compile_results_table(R2, levOrder, rpmOrder, R2_rel);


%% Calculate ROC2 curves and corresponding confidence intervals
% -----------------------------------------------------------

classifiers = {
	'accA_x_NF_HP_b1_pow'
 	'accA_y_NF_HP_b1_pow'
 	'accA_z_NF_HP_b1_pow'
	'accA_best_NF_HP_b1_pow'
 	'accA_best_NF_HP_b1_pow_per_speed'
	'accA_xyz_NF_HP_b1_pow_sum'
	'accA_xyz_NF_HP_b1_pow_norm'
	'P_LVAD_drop'
	'P_LVAD_mean'
% 	'accA_xyz_NF_HP_b3_pow_sum'
% 	'accA_xyz_NF_HP_b3_pow_norm'
% 	'accA_best_NF_HP_b3_pow_per_speed'
% 	'accA_best_NF_HP_b3_pow'
%  	'accA_x_NF_HP_b3_pow'
%  	'accA_y_NF_HP_b3_pow'
%  	'accA_z_NF_HP_b3_pow'
	};
bestAxVars = {
	'accA_best_NF_HP_b1_pow'
%   'accA_best_NF_HP_b3_pow'
	};

% Input for states of concrete occlusions 
predStateVar = 'levelLabel';
predStates = {
	'Balloon, Lev1', '\bf34%-47%\rm\newlineobstruction'
	'Balloon, Lev2', '\bf52%-64%\rm\newlineobstruction'
	'Balloon, Lev3', '\bf65%-72%\rm\newlineobstruction'
	'Balloon, Lev4', '\bf78%-84%\rm\newlineobstruction'
	%'Balloon, Lev5', '\bf85%-94%\rm\newlineobstruction'
	};
[ROC2,AUC2] = make_roc_curve_matrix_per_intervention_and_speed(...
	F2, classifiers, predStateVar, predStates, false, bestAxVars);
Data.G1.Feature_Statistics2.ROC2 = ROC2;
Data.G1.Feature_Statistics2.AUC2 = AUC2;

% Input for states of pooled occlusions above a threshold
predStateVar = 'balLev';
F2.balLev = double(string(F2.balLev));
predStates = {
	1, ' Lev 1-4'
	2, ' Lev 2-4'
	3, ' Lev 3,4'
	[2,3], 'Lev 2,3'
	};
[ROC2_pooled,AUC2_pooled] = make_roc_curve_matrix_per_intervention_and_speed(...
	F2(F2.balLev~=5,:), classifiers, predStateVar, predStates, true, {}, false);
Data.G1.Feature_Statistics2.ROC_Pooled = ROC2_pooled;
Data.G1.Feature_Statistics2.AUC_Pooled = AUC2_pooled;

[ROC2_pooled_rpm,AUC2_pooled_rpm] = make_roc_curve_matrix_per_intervention_and_speed(...
	F2(F2.balLev~=5,:), classifiers, predStateVar, predStates, true, {}, true);
Data.G1.Feature_Statistics2.ROC_Pooled_RPM = ROC2_pooled_rpm;
Data.G1.Feature_Statistics2.AUC_Pooled_RPM = AUC2_pooled_rpm;


%% Save 
% -----------------------------------------------------------

Data.G1.Features2.idSpecs = idSpecs;
Data.G1.Features2.sequences = sequences;
Data.G1.Features2.Absolute = F2;
Data.G1.Features2.Relative = F2_rel;
Data.G1.Features2.Delta = F2_del;
Data.G1.Features2.Paired_Absolute = W2;
Data.G1.Features2.Paired_Relative = W2_rel;
Data.G1.Features2.Absolute = F2;

Data.G1.Feature_Statistics2.Descriptive_Absolute = G2;
Data.G1.Feature_Statistics2.Descriptive_Relative = G2_rel;
Data.G1.Feature_Statistics2.Descriptive_Delta = G2_del;
Data.G1.Feature_Statistics2.Test_P_Values_Absolute = P2;
Data.G1.Feature_Statistics2.Test_P_Values_Relative = P2_rel;
Data.G1.Feature_Statistics2.Results = R2;
Data.G1.Feature_Statistics2.ROC2 = ROC2;
Data.G1.Feature_Statistics2.AUC2 = AUC2;
Data.G1.Feature_Statistics2.ROC2_pooled = ROC2_pooled;
Data.G1.Feature_Statistics2.AUC2_pooled = AUC2_pooled;

%save_data('Periodograms', feats_path, Data.G1.Periodograms, {'matlab'});
save_data('Features2', Config.feats_path, Data.G1.Features2, {'matlab'});
save_data('Feature_Statistics2', Config.stats_path, Data.G1.Feature_Statistics2, {'matlab'});
save_features_as_separate_spreadsheets(Data.G1.Features2, Config.feats_path);
save_statistics_as_separate_spreadsheets(Data.G1.Feature_Statistics2, Config.stats_path);


%% Roundup
% -----------------------------------------------------------

multiWaitbar('CloseAll');
clear save_data check_table_var_input
%clear F2 G2 F2_rel G2_rel F2_del G2_del 
clear Pxx idSpecs
clear discrVars meanVars minMaxVars accVars hBands  pVars nominalAsBaseline ...
    bestAxVars levOrder...
	pooled classifiers predStateVar predStates ROC2 F_ROC F_ROC_SPSS AUC2 ...
	sequences isHarmBand W2 W2_rel relVars newVar vars ans
