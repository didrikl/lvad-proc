%% Calculate metrics of intervals tagged in the analysis_id column in Data

% This defines the relevant ids for analysis
Config =  get_processing_config_defaults_G1B;
init_multiwaitbar_calc_stats
	
idSpecs = init_id_specifications(Config.idSpecs_path);
idSpecs = idSpecs(not(idSpecs.extra),:);
idSpecs = idSpecs(not(contains(string(idSpecs.analysis_id),{'E'})),:);
idSpecs = idSpecs(contains(string(idSpecs.categoryLabel),{'Injection'}),:);
%idSpecs = idSpecs((ismember(idSpecs.interventionType,{'Control','Effect'})),:);

sequences = {
	%'Seq3' % (pilot)
   	'Seq6'
   	'Seq7'
   	'Seq8'
   	'Seq11' 	
    'Seq12'
   	'Seq13'
   	%'Seq14'
	};

Data.G1B.Features.idSpecs = idSpecs;
Data.G1B.Features.sequences = sequences;

%% Make variable features of each intervention
% -----------------------------------------------------------

discrVars = {
   'P_LVAD'
   'Q_LVAD'
 	%'balLev_xRay'
 	%'balDiam_xRay'
 	%'arealObstr_xRay_pst' 
 	};
meanVars = {
	%'accB_x_NF_HP'    % to get stddev
	%'accB_y_NF_HP'    % to get stddev
	%'accB_z_NF_HP'    % to get stddev
	%'accB_norm_NF_HP' % to get stddev
	'Q'
	};
minMaxVars = {};
F = make_intervention_stats(Data.G1B, sequences, discrVars, meanVars, {}, minMaxVars, idSpecs);

% Calculate NHA as band powers
accVars = {
  	'accA_x'
  	'accA_y'
  	'accA_z'
  	'accB_x'
  	'accB_y'
  	'accB_z'
  	'accB_norm'
	};
hBands = [
	2.995, 3.005 % 1Hz-band (for 2400 RPM) containing the 3. harmonic
	2.9695, 2.9705 % adjacent NHA reference 1Hz-band below the 3. harmonic
	3.0275, 3.0425 % adjacent NHA reference 1Hz-band above the 3. harmonic
	];
isHarmBand = true; % could as well have used absolute band instead
Pxx = make_power_spectra(Data.G1B, sequences, accVars, Config.fs, hBands, idSpecs, isHarmBand);

% Remove mean power frequencies, just to reduce number of variables
mpfVars = contains(Pxx.bandMetrics.Properties.VariableNames,'_mpf');
Pxx.bandMetrics = Pxx.bandMetrics(:,not(mpfVars));

% Report NHA as g^2/kHz instead of g^2/Hz
Pxx.bandMetrics{:,vartype('numeric')} = 1000*Pxx.bandMetrics{:,vartype('numeric')};
Data.G1.Periodograms = Pxx;

% Add derived features
F = join(F, Pxx.bandMetrics, 'Keys',{'analysis_id','id'});

% Add derived highest third harmonic
% vars = {'accB_x_b3_pow','accB_y_b3_pow','accB_z_b3_pow'};
% newVar = 'accB_highest_h3';
% F = find_best_axis_per_intervention(F, newVar, vars);
% F = lookup_baseline_for_best_axis(F, newVar);
%F.accB_highest_h3_var

%% Make exclusions before stastitical processing
% ----------------------------------------------

% Exclude PLVAD from experiment with friction
F.P_LVAD_mean(contains(F.id,'Seq14_Bal')) = nan;

% Exclude experiment with corrupt signal
F(contains(F.id,'Seq3'), :) = [];
accVars = [accVars;'accB_xyz_NF_HP_b1_pow_norm';'accB_xyz_NF_HP_b3_pow_norm'];
F{ismember(F.id,"Seq6_RPM_2200_Nom_Rep1"),accVars} = nan;

% Exclude unstable flow recordings (more than 20% within segment)
F(ismember(F.id,"Seq6_Bal_2200_Lev1"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev2"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev3"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev4"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Lev5"),:) = [];
F(ismember(F.id,"Seq6_Bal_2200_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2200_Nom_Rep1"),:) = []; % Missing PLVAD & QLVAD
% F(ismember(F.id,"Seq6_RPM_2400_Nom_Rep1"),:) = []; % Good for inter-experiment comparisons
% F(ismember(F.id,"Seq6_RPM_2600_Nom_Rep1"),:) = []; % Was not even recorded
F(ismember(F.id,"Seq6_RPM_2200_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2400_Nom_Rep2"),:) = [];
F(ismember(F.id,"Seq6_RPM_2600_Nom_Rep2"),:) = [];


%% Make relative and delta differences from baselines using id tags
% -----------------------------------------------------------

nominalAsBaseline = false;
F_rel = calc_relative_feats(F, nominalAsBaseline);
F_del = calc_delta_diff_feats(F, nominalAsBaseline);

F.P_LVAD_change = -F_del.P_LVAD_mean;


% Model statistics
% -----------------------------------------------------------

weight = nan(numel(sequences),1);
for i=1:numel(sequences)
	weight(i) = str2double(Data.G1B.(sequences{i}). ...
		Notes.Properties.UserData.Experiment_Info.PigWeight0x28kg0x29);
end

Data.G1B.Periodograms = Pxx;
Data.G1B.Features.Model.weight = weight;
Data.G1B.Features.Absolute = F;
Data.G1B.Features.Relative = F_rel;
Data.G1B.Features.Delta = F_del;


%% Descriptive stastistics over group of experiments
% -----------------------------------------------------------

G = make_group_stats(F, idSpecs, sequences);
G_rel = make_group_stats(F_rel, idSpecs, sequences);
G_del = make_group_stats(F_del, idSpecs, sequences);

Data.G1B.Feature_Statistics.Descriptive_Absolute = G;
Data.G1B.Feature_Statistics.Descriptive_Relative = G_rel;
Data.G1B.Feature_Statistics.Descriptive_Delta = G_del;


% Hypothesis test
% -----------------------------------------------------------

% Do Wilcoxens pair test and make table of median and p-values
pVars = {
 	'accB_x_NF_HP_b1_pow'
 	'accB_x_NF_HP_b3_pow'
 	'accB_y_NF_HP_b1_pow'
% 	'accB_z_NF_HP_b1_pow'
% 	'accB_x_NF_HP_b2_pow'
% 	'accB_y_NF_HP_b2_pow'
% 	'accB_z_NF_HP_b2_pow'
	'accB_norm_NF_HP_b1_pow'
 	'accB_xyz_NF_HP_b1_pow_norm'
	'accB_norm_NF_HP_b3_pow'
 	'accB_xyz_NF_HP_b3_pow_norm'
	'Q_mean'
	'P_LVAD_mean'
};

W = make_paired_features_for_signed_rank_test(F, pVars,{'seq'});
W_rel = make_paired_features_for_signed_rank_test(F_rel, pVars,{'seq'});
Data.G1B.Features.Paired_Absolute = W;
Data.G1B.Features.Paired_Relative = W_rel;

[P,R] = make_paired_signed_rank_test_G1(W, G, pVars);
[P_rel,R_rel] = make_paired_signed_rank_test_G1(W_rel, G_rel, pVars);
Data.G1B.Feature_Statistics.Test_P_Values_Absolute = P;
Data.G1B.Feature_Statistics.Test_P_Values_Relative = P_rel;

% Compile results table
Results = compile_results_table_G1B(R, R_rel);
Data.G1B.Feature_Statistics.Results = Results;


%% Calculate ROC curves
% ----------------------

classifiers = {
	'accB_x_NF_HP_b3_pow'
 	'P_LVAD_change'
	};

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
Data.G1B.Feature_Statistics.ROC = ROC;
Data.G1B.Feature_Statistics.AUC = AUC;


% Calculate ROC curves for pooled RPM of both BL and balloon interventions
% --------------------------------------------------------------------------


% Input for states of concrete occlusions 
predStateVar = 'balLev_xRay_mean';
predStates = {
	1, '\bf34%-47%\rm\newlineobstruction'
	2, '\bf52%-64%\rm\newlineobstruction'
	3, '\bf65%-72%\rm\newlineobstruction'
	4, '\bf78%-84%\rm\newlineobstruction'
	};

[ROC_pooled_rpm,AUC_pooled_rpm] = make_roc_curve_matrix_per_intervention_and_speed(...
	F, classifiers, predStateVar, predStates, false, {}, true);

Data.G1B.Feature_Statistics.ROC_Pooled_RPM = ROC_pooled_rpm;
Data.G1B.Feature_Statistics.AUC_Pooled_RPM = AUC_pooled_rpm;


%% Save 
% -----------------------------------------------------------

save_data('Features', Config.feats_path, Data.G1B.Features, {'matlab'});
save_data('Feature_Statistics', Config.stats_path, Data.G1B.Feature_Statistics, {'matlab'});
save_features_as_separate_spreadsheets(Data.G1B.Features, Config.feats_path);
save_statistics_as_separate_spreadsheets(Data.G1B.Feature_Statistics, Config.stats_path);


%% Roundup
% -----------------------------------------------------------

multiWaitbar('CloseAll');
clear save_data check_table_var_input
clear discrVars meanVars minMaxVars accVars hBands  pVars nominalAsBaseline ...
    bestAxVars levOrder pooled classifiers predStateVar predStates ROC AUC ...
	isHarmBand W W_rel relVars newVar vars ans
