%% Calculate metrics of intervals tagged in the analysis_id column in Data
% -------------------------------------------------------------------------

% This defines the relevant ids for analysis
Config =  get_processing_config_defaults_G1B2;
init_multiwaitbar_calc_stats

% Experiment inclusions
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
Data.G1B2.Features.sequences = seqs;

% Segment inclusions
idSpecs = init_id_specifications(Config.idSpecs_path);
idSpecs = idSpecs(not(idSpecs.extra),:);
idSpecs = idSpecs(not(contains(string(idSpecs.analysis_id),{'E'})),:);
idSpecs = idSpecs(not(contains(string(idSpecs.categoryLabel),{'Injection'})),:);
idSpecs = idSpecs((ismember(idSpecs.interventionType,{'Control','Effect'})),:);
Data.G1B2.Features.idSpecs = idSpecs;

% Model statistics
weight = lookup_model_weights(seqs, Data.G1B2);
Data.G1B2.Features.Model.weight = weight;


%% Make variable features of each intervention
% ---------------------------------------------

discrVars = {
   'P_LVAD'
   'Q_LVAD'
   'balLev_xRay'
 	%'balDiam_xRay'
 	};
meanVars = {
	'Q'
	};
F = make_intervention_stats(Data.G1B2, seqs, discrVars, meanVars, {}, {}, idSpecs);

% Calculate NHA as band powers
accVars = {
  	'accB_x_NF'
  	'accB_y_NF'
  	'accB_z_NF'
	};
hBands = [1.25, 3.85]; % for band denoted 'b2'
Pxx = make_power_spectra(Data.G1B2, seqs, accVars, Config.fs, hBands, idSpecs);

% Remove mean power frequencies, just to reduce number of variables
Pxx.bandMetrics = Pxx.bandMetrics(:,...
	not(contains(Pxx.bandMetrics.Properties.VariableNames,'_mpf')));

% Report NHA as g^2/kHz instead of g^2/Hz
Pxx.bandMetrics{:,vartype('numeric')} = 1000*Pxx.bandMetrics{:,vartype('numeric')};
Data.G1B2.Periodograms = Pxx;

% Add derived features
F = join(F, Pxx.bandMetrics, 'Keys',{'analysis_id','id'});

% Determine best NHA axis
% TODO: Find best signal (4H) to noise (NHA) at BL
%F = find_best_axis_per_intervention(F, 'accB_best_NF_b2', {'accB_x_NF_b2_pow','accB_y_NF_b2_pow','accB_z_NF_b2_pow'});
%F = lookup_baseline_for_best_axis(F, 'accB_best_NF_b2');

% Add norm of spatial component NHAs
F = calc_pow_norm(F, 'accB_xyz_NF_b2_pow_norm', {'accB_x_NF_b2_pow','accB_y_NF_b2_pow','accB_z_NF_b2_pow'});


%% Segment exclusions before stastitical processing
% --------------------------------------------------

% Exclude PLVAD from experiment with friction
F.P_LVAD_mean(contains(F.id,'Seq14_Bal')) = nan;

% Exclude experiment with corrupt signal
%F(contains(F.id,'Seq3'), :) = [];
F{contains(F.id, {'Seq3_Bal_2600','Seq3_Bal_2400','Seq3_Bal_2600'}), [accVars;'accB_xyz_NF_b1_pow_norm';'accB_xyz_NF_b2_pow_norm']} = nan;
F{ismember(F.id,"Seq6_RPM_2200_Nom_Rep1"), [accVars;'accB_xyz_NF_b1_pow_norm';'accB_xyz_NF_b2_pow_norm']} = nan;

% Exclude unstable flow recordings (more than 20% within segment)
F(ismember(F.id,"Seq6_Bal_2200_Lev1"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev2"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev3"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev4"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev5"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2200_Nom_Rep1"),:) = []; % Missing PLVAD & QLVAD
F(ismember(F.id,"Seq6_RPM_2200_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2400_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2600_Nom_Rep2"),:) = [];


%% Make relative and delta differences from BL and group stats, using id tags
% ----------------------------------------------------------------------------

nominalAsBaseline = false;
F_rel = calc_relative_feats(F, nominalAsBaseline);
F_del = calc_delta_diff_feats(F, nominalAsBaseline);

F.P_LVAD_change = -F_del.P_LVAD_mean;

Data.G1B2.Features.Absolute = F;
Data.G1B2.Features.Relative = F_rel;
Data.G1B2.Features.Delta = F_del;

G = make_group_stats(F, idSpecs, seqs);
G_rel = make_group_stats(F_rel, idSpecs, seqs);
G_del = make_group_stats(F_del, idSpecs, seqs);

Data.G1B2.Feature_Statistics.Descriptive_Absolute = G;
Data.G1B2.Feature_Statistics.Descriptive_Relative = G_rel;
Data.G1B2.Feature_Statistics.Descriptive_Delta = G_del;


%% Hypothesis test
% -----------------

% Do Wilcoxens pair test and make table of median and p-values
pVars = {
	'accB_x_NF_b2_pow'
	'accB_y_NF_b2_pow'
	'accB_z_NF_b2_pow'
	'accB_xyz_NF_b2_pow_norm'
	'Q_mean'
	'Q_LVAD_mean'
	'P_LVAD_mean'
	};

W = make_paired_features_for_signed_rank_test(F, pVars,{'seq'});
W_rel = make_paired_features_for_signed_rank_test(F_rel, pVars,{'seq'});
Data.G1B2.Features.Paired_Absolute = W;
Data.G1B2.Features.Paired_Relative = W_rel;

[P,R] = make_paired_signed_rank_test_G1(W, G, pVars);
[P_rel,R_rel] = make_paired_signed_rank_test_G1(W_rel, G_rel, pVars);
Data.G1B2.Feature_Statistics.Test_P_Values_Absolute = P;
Data.G1B2.Feature_Statistics.Test_P_Values_Relative = P_rel;

Results = compile_results_table_G1B2(R, R_rel);
Data.G1B2.Feature_Statistics.Results = Results;


%% Calculate ROC curves
% ----------------------

classifiers = {
	'accB_xyz_NF_b2_pow_norm'
	'P_LVAD_change'
	'P_LVAD_mean'
	};

predStateVar = 'levelLabel';
predStates = {
	'Balloon, 2400, Lev1', '\bf34%-47%\rm\newlineobstruction'
	'Balloon, 2400, Lev2', '\bf52%-64%\rm\newlineobstruction'
	'Balloon, 2400, Lev3', '\bf65%-72%\rm\newlineobstruction'
	'Balloon, 2400, Lev4', '\bf78%-84%\rm\newlineobstruction'
	};
[ROC,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
	F(F.pumpSpeed==single(2400),:), classifiers, predStateVar, predStates, false);

Data.G1B2.Feature_Statistics.ROC = ROC;
Data.G1B2.Feature_Statistics.AUC = AUC;


%% Calculate ROC curves for pooled RPM of BL
% -------------------------------------------

classifiers = {
	'accB_xyz_NF_b2_pow_norm'
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

Data.G1B2.Feature_Statistics.ROC_Pooled_BL_RPM = ROC_pooled_bl_rpm;
Data.G1B2.Feature_Statistics.AUC_Pooled_BL_RPM = AUC_pooled_bl_rpm;


%% Calculate pooled levels ROC curves
% ------------------------------------

predStateVar = 'balLev';
F.balLev = double(string(F.balLev));
predStates = {
	[2,3,4], 'Lev 2-4' % level 2, 3 and 4 specifically
	};
[ROC_pooled_levs, AUC_pooled_levs] = make_roc_curve_matrix_per_intervention_and_speed(...
	F(F.balLev~=5,:), classifiers, predStateVar, predStates, true, {}, false);

Data.G1B2.Feature_Statistics.ROC_Pooled_Levels = ROC_pooled_levs;
Data.G1B2.Feature_Statistics.AUC_Pooled_Levels = AUC_pooled_levs;


%% Save 
% ------
save_data('Features', Config.feats_path, Data.G1B2.Features, {'matlab'});
save_data('Feature_Statistics', Config.stats_path, Data.G1B2.Feature_Statistics, {'matlab'});
save_features_as_separate_spreadsheets(Data.G1B2.Features, Config.feats_path);
save_statistics_as_separate_spreadsheets(Data.G1B2.Feature_Statistics, Config.stats_path);


%% Roundup
% ---------

multiWaitbar('CloseAll');
clear save_data check_table_var_input
clear idSpecs accVars discrVars meanVars hBands nominalAsBaseline pVars Pxx ...
	weight W W_rel seqs P P_rel ROC AUC ROC_pooled_levs AUC_pooled_levs ...
	ROC_pooled_bl_rpm ROC_pooled AUC_pooled_bl_rpm AUC_pooled_rpm ...
	predStates predStateVar classifiers
