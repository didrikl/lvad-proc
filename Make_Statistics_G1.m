%% Calculate metrics of intervals tagged in the analysis_id column in Data
% -------------------------------------------------------------------------

% This defines the relevant ids for analysis
Config =  get_processing_config_defaults_G1;
init_multiwaitbar_calc_stats
	
idSpecs = init_id_specifications(Config.idSpecs_path);
idSpecs = idSpecs(not(idSpecs.extra),:);
idSpecs = idSpecs(not(contains(string(idSpecs.analysis_id),{'E'})),:);
idSpecs = idSpecs(not(contains(string(idSpecs.categoryLabel),{'Injection'})),:);

seqs = {
	'Seq3'
  	'Seq6'
   	'Seq7'
   	'Seq8'
   	'Seq11'
 	'Seq12'
   	'Seq13'
   	'Seq14'
	};

Data.G1.Features.idSpecs = idSpecs;
Data.G1.Features.sequences = seqs;

% Model statistics
weight = lookup_model_weights(seqs, Data.G1);
Data.G1.Features.Model.weight = weight;


%% Make variable features of each intervention
% ---------------------------------------------

discrVars = {
	'Q_LVAD'
	'P_LVAD'
 	'balLev'
 	'balLev_xRay'
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
	'pGraft'
	'pMillar'
	'Q'
	};
minMaxVars = {'Q'};
F = make_intervention_stats(Data.G1, seqs, discrVars, meanVars, {}, minMaxVars, idSpecs);

% Calculate band powers as NHA
accVars = {
	'accA_x_NF_HP'
	'accA_y_NF_HP'
	'accA_z_NF_HP'
	'accA_norm_NF_HP'
	};
hBands = [1.25, 3.85]; % for band denoted 'b2'
Pxx = make_power_spectra(Data.G1, seqs, accVars, Config.fs, hBands, idSpecs);

% Report NHA as g^2/kHz instead of g^2/Hz
Pxx.bandMetrics{:,vartype('numeric')} = 1000*Pxx.bandMetrics{:,vartype('numeric')};Data.G1.Periodograms = Pxx;
Data.G1.Periodograms = Pxx;

% Add derived features
F = join(F, Pxx.bandMetrics, 'Keys',{'analysis_id','id'});
F.Q_CO_pst = 100*(F.Q_mean./F.CO_mean);

% Add derived best axes based on highest absolute NHA values
% vars = {'accA_x_NF_HP_b1_pow','accA_y_NF_HP_b1_pow','accA_z_NF_HP_b1_pow'};
% newVar = 'accA_best_NF_HP_b1_pow';
% F = derive_best_axis_values(F, vars, newVar, sequences);

% Add norm of spatial component NHAs
F = calc_pow_norm(F, 'accA_xyz_NF_HP_b1_pow_norm', {'accA_x_NF_HP_b1_pow','accA_y_NF_HP_b1_pow','accA_z_NF_HP_b1_pow'});
F = calc_pow_norm(F, 'accA_xyz_NF_HP_b2_pow_norm', {'accA_x_NF_HP_b2_pow','accA_y_NF_HP_b2_pow','accA_z_NF_HP_b2_pow'});


%% Make exclusions before stastitical processing
% -----------------------------------------------

% Exclude PLVAD from experiment with friction
F.P_LVAD_mean(contains(F.id,'Seq14_Bal')) = nan;

% Exclude all measurements from experiment with friction
% F(contains(F.id,'Seq14_Bal'),:) = [];

% Exclude unstable flow recordings (more than 20% within segment)
F(ismember(F.id,"Seq6_Bal_2200_Lev1"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev2"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev3"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev4"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev5"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2200_Nom_Rep1"),:) = []; % Missing PLVAD & QLVAD
% F(ismember(F.id,"Seq6_RPM_2400_Nom_Rep1"),:) = []; % Good for inter-experiment comparisons
F(ismember(F.id,"Seq6_RPM_2200_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2400_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2600_Nom_Rep2"),:) = [];


%% Make relative and delta differences from BL and group stats, using id tags
% ----------------------------------------------------------------------------

nominalAsBaseline = false;
F_rel = calc_relative_feats(F, nominalAsBaseline);
F_del = calc_delta_diff_feats(F, nominalAsBaseline);
F.P_LVAD_change = -F_del.P_LVAD_mean;

Data.G1.Features.Absolute = F;
Data.G1.Features.Relative = F_rel;
Data.G1.Features.Delta = F_del;

G = make_group_stats(F, idSpecs, seqs);
G_rel = make_group_stats(F_rel, idSpecs, seqs);
G_del = make_group_stats(F_del, idSpecs, seqs);

Data.G1.Feature_Statistics.Descriptive_Absolute = G;
Data.G1.Feature_Statistics.Descriptive_Relative = G_rel;
Data.G1.Feature_Statistics.Descriptive_Delta = G_del;


%% Hypothesis test
% -----------------

pVars = {
	'accA_xyz_NF_HP_b1_pow_norm'
	%'accA_best_NF_HP_b1_pow'
	%'accA_best_NF_HP_b1_pow_per_speed'
  	'accA_xyz_NF_HP_b2_pow_norm'
	'Q_mean'
	'P_LVAD_mean'
	'Q_LVAD_mean'
	'pGraft_mean'
};

W = make_paired_features_for_signed_rank_test(F, pVars,{'seq'});
W_rel = make_paired_features_for_signed_rank_test(F_rel, pVars,{'seq'});

% Wilcoxens pair test and make table of median and p-values
[P,R] = make_paired_signed_rank_test_G1(W, G, pVars);
[P_rel, R_rel] = make_paired_signed_rank_test_G1(W_rel, G_rel, pVars);

Results = compile_results_table_G1(R, R_rel);

Data.G1.Features.Paired_Absolute = W;
Data.G1.Features.Paired_Relative = W_rel;
Data.G1.Feature_Statistics.Test_P_Values_Absolute = P;
Data.G1.Feature_Statistics.Test_P_Values_Relative = P_rel;
Data.G1.Feature_Statistics.Results = Results;


%% Calculate ROC curves
% ----------------------

classifiers = {
	'accA_xyz_NF_HP_b1_pow_norm'
 	'accA_xyz_NF_HP_b2_pow_norm'
	'P_LVAD_change'
	'P_LVAD_mean'
	};

% If any of the above classifiers contains any of these names, then treat them
% specifically as "best axis" when comparing against corresponding baseline
% bestAxVars = {'accA_best_NF_HP_b1_pow'};

% Input for states of concrete occlusions 
predStateVar = 'levelLabel';
predStates = {
	'Balloon, 2400, Lev1', '\bf34%-47%\rm\newlineobstruction'
	'Balloon, 2400, Lev2', '\bf52%-64%\rm\newlineobstruction'
	'Balloon, 2400, Lev3', '\bf65%-72%\rm\newlineobstruction'
	'Balloon, 2400, Lev4', '\bf78%-84%\rm\newlineobstruction'
	};
[ROC,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
	F(F.pumpSpeed==single(2400),:), classifiers, predStateVar, predStates, false);

Data.G1.Feature_Statistics.ROC = ROC;
Data.G1.Feature_Statistics.AUC = AUC;


%% Calculate ROC curves for pooled RPM of both BL and balloon interventions
% --------------------------------------------------------------------------

classifiers = {
	'accA_xyz_NF_HP_b1_pow_norm'
 	'P_LVAD_change'
	};
predStateVar = 'balLev_xRay_mean';
predStates = {
	1, '\bf34%-47%\rm\newlineobstruction'
	2, '\bf52%-64%\rm\newlineobstruction'
	3, '\bf65%-72%\rm\newlineobstruction'
	4, '\bf78%-84%\rm\newlineobstruction'
	};

[ROC_pooled_rpm,AUC_pooled_rpm] = make_roc_curve_matrix_per_intervention_and_speed(...
	F, classifiers, predStateVar, predStates, false, {}, true);

Data.G1.Feature_Statistics.ROC_Pooled_RPM = ROC_pooled_rpm;
Data.G1.Feature_Statistics.AUC_Pooled_RPM = AUC_pooled_rpm;


%% Calculate ROC curves for pooled RPM of BL
% -------------------------------------------

classifiers = {
	'accA_xyz_NF_HP_b1_pow_norm'
 	'P_LVAD_change'
	};
predStateVar = 'levelLabel';
predStates = {
	'Balloon, 2400, Lev1', '\bf34%-47%\rm\newlineobstruction'
	'Balloon, 2400, Lev2', '\bf52%-64%\rm\newlineobstruction'
	'Balloon, 2400, Lev3', '\bf65%-72%\rm\newlineobstruction'
	'Balloon, 2400, Lev4', '\bf78%-84%\rm\newlineobstruction'
	};

[ROC_pooled_bl_rpm,AUC_pooled_bl_rpm] = make_roc_curve_matrix_per_intervention_and_speed(...
	F, classifiers, predStateVar, predStates, false, {}, true);

Data.G1.Feature_Statistics.ROC_Pooled_BL_RPM = ROC_pooled_bl_rpm;
Data.G1.Feature_Statistics.AUC_Pooled_BL_RPM = AUC_pooled_bl_rpm;


%% Calculate pooled levels ROC curves
% ------------------------------------

predStateVar = 'balLev';
F.balLev = double(string(F.balLev));
predStates = {
	1, ' Lev 1-5' % all levels
	%2, ' Lev 2-5' % minimum level 2
	[2,3,4], 'Lev 2-4' % level 2, 3 and 4 specifically
	};
[ROC_pooled_levs,AUC_pooled_levs] = make_roc_curve_matrix_per_intervention_and_speed(...
	F(F.balLev~=5,:), classifiers, predStateVar, predStates, true, {}, false);

Data.G1.Feature_Statistics.ROC_Pooled_Levels = ROC_pooled_levs;
Data.G1.Feature_Statistics.AUC_Pooled_Levels = AUC_pooled_levs;


%% Save 
% ------

save_data('Features', Config.feats_path, Data.G1.Features, {'matlab'});
save_data('Feature_Statistics', Config.stats_path, Data.G1.Feature_Statistics, {'matlab'});
save_features_as_separate_spreadsheets(Data.G1.Features, Config.feats_path);
save_statistics_as_separate_spreadsheets(Data.G1.Feature_Statistics, Config.stats_path);


%% Roundup
% ---------

multiWaitbar('CloseAll');
clear save_data check_table_var_input
clear idSpecs accVars discrVars meanVars hBands nominalAsBaseline pVars Pxx ...
	weight W W_rel seqs P P_rel ROC AUC ROC_pooled_levs AUC_pooled_levs ...
	ROC_pooled_bl_rpm ROC_pooled_rpm AUC_pooled_bl_rpm AUC_pooled_rpm ...
	predStates predStateVar classifiers minMaxVars
