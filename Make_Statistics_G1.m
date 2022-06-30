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

Data.G1.Features.idSpecs = idSpecs;
Data.G1.Features.sequences = sequences;

%% Make variable features of each intervention
% -----------------------------------------------------------

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
	%'accA_norm_NF_HP'
	};
hBands = [
	1.25, 3.85
	];
isHarmBand = true;
Pxx = make_power_spectra(Data.G1, sequences, accVars, Config.fs, hBands, idSpecs, isHarmBand);

% Report NHA as g^2/kHz instead of g^2/Hz
Pxx.bandMetrics{:,vartype('numeric')} = 1000*Pxx.bandMetrics{:,vartype('numeric')};Data.G1.Periodograms = Pxx;

% Add derived features
F = join(F, Pxx.bandMetrics, 'Keys',{'analysis_id','id'});
F.Q_CO_pst = 100*(F.Q_mean./F.CO_mean);

% Add derived best axes based on highest absolute NHA values
% vars = {'accA_x_NF_HP_b1_pow','accA_y_NF_HP_b1_pow','accA_z_NF_HP_b1_pow'};
% newVar = 'accA_best_NF_HP_b1_pow';
% F = derive_best_axis_values(F, vars, newVar, sequences);

% Add aggregated (sum and norm) bandbower over x, y, and z
% F.accA_xyz_NF_HP_b1_pow_sum = sum([F.accA_x_NF_HP_b1_pow,F.accA_y_NF_HP_b1_pow,F.accA_z_NF_HP_b1_pow],2,'omitnan');
F.accA_xyz_NF_HP_b1_pow_norm = sqrt( sum( F{:,{'accA_x_NF_HP_b1_pow','accA_y_NF_HP_b1_pow','accA_z_NF_HP_b1_pow'}}.^2,2,"omitnan"));
F.accA_xyz_NF_HP_b2_pow_norm = sqrt( sum( F{:,{'accA_x_NF_HP_b2_pow','accA_y_NF_HP_b2_pow','accA_z_NF_HP_b2_pow'}}.^2,2,"omitnan"));

% Make exclusions before stastitical processing
% ----------------------------------------------

% Exclude PLVAD from experiment with friction
F.P_LVAD_mean(contains(F.id,'Seq14_Bal')) = nan;

% F2 = F;
% F(contains(F.id,'Seq14_Bal'),:) = [];
% F = F2;

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


% Make relative and delta differences from baselines using id tags
% -----------------------------------------------------------

nominalAsBaseline = false;
F_rel = calc_relative_feats(F, nominalAsBaseline);
F_del = calc_delta_diff_feats(F, nominalAsBaseline);

F.P_LVAD_change = -F_del.P_LVAD_mean;


% Model statistics
% -----------------------------------------------------------

weight = nan(numel(sequences),1);
for i=1:numel(sequences)
	weight(i) = str2double(Data.G1.(sequences{i}). ...
		Notes.Properties.UserData.Experiment_Info.PigWeight0x28kg0x29);
end

Data.G1.Periodograms = Pxx;
Data.G1.Features.Model.weight = weight;
Data.G1.Features.Absolute = F;
Data.G1.Features.Relative = F_rel;
Data.G1.Features.Delta = F_del;


%% Descriptive stastistics over group of experiments
% -----------------------------------------------------------

G = make_group_stats(F, idSpecs, sequences);
G_rel = make_group_stats(F_rel, idSpecs, sequences);
G_del = make_group_stats(F_del, idSpecs, sequences);

Data.G1.Feature_Statistics.Descriptive_Absolute = G;
Data.G1.Feature_Statistics.Descriptive_Relative = G_rel;
Data.G1.Feature_Statistics.Descriptive_Delta = G_del;


% Hypothesis test
% -----------------------------------------------------------

% Do Wilcoxens pair test and make table of median and p-values
pVars = {
% 	'accA_x_NF_HP_b1_pow'
% 	'accA_y_NF_HP_b1_pow'
% 	'accA_z_NF_HP_b1_pow'
	'accA_xyz_NF_HP_b1_pow_norm'
	%'accA_xyz_NF_HP_b1_pow_sum'
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
Data.G1.Features.Paired_Absolute = W;
Data.G1.Features.Paired_Relative = W_rel;

[P,R] = make_paired_signed_rank_test_G1(W, G, pVars);
[P_rel,R_rel] = make_paired_signed_rank_test_G1(W_rel, G_rel, pVars);
Data.G1.Feature_Statistics.Test_P_Values_Absolute = P;
Data.G1.Feature_Statistics.Test_P_Values_Relative = P_rel;

% Compile results table
Results = compile_results_table(R, R_rel);
Data.G1.Feature_Statistics.Results = Results;


%% Calculate ROC curves
% ----------------------

classifiers = {
	'accA_x_NF_HP_b1_pow'
 	'accA_y_NF_HP_b1_pow'
 	'accA_z_NF_HP_b1_pow'
	'accA_xyz_NF_HP_b1_pow_norm'
%	'accA_xyz_NF_HP_b1_pow_sum'
%	'accA_best_NF_HP_b1_pow'
% 	'accA_best_NF_HP_b1_pow_per_speed'
	'accA_x_NF_HP_b2_pow'
 	'accA_y_NF_HP_b2_pow'
 	'accA_z_NF_HP_b2_pow'
	'accA_xyz_NF_HP_b2_pow_norm'
%	'accA_xyz_NF_HP_b1_pow_sum'
%	'accA_best_NF_HP_b1_pow'
% 	'accA_best_NF_HP_b1_pow_per_speed'
	'P_LVAD_change'
	'P_LVAD_mean'
	};

% If any of the above classifiers contains any of these names, then treat them
% specifically as "best axis" when comparing against corresponding baseline
% bestAxVars = {
%    'accA_best_NF_HP_b1_pow'
%    'accA_best_NF_HP_b2_pow'
% 	};

% Input for states of concrete occlusions 
predStateVar = 'levelLabel';
predStates = {
	'Balloon, 2400, Lev1', '\bf34%-47%\rm\newlineobstruction'
	'Balloon, 2400, Lev2', '\bf52%-64%\rm\newlineobstruction'
	'Balloon, 2400, Lev3', '\bf65%-72%\rm\newlineobstruction'
	'Balloon, 2400, Lev4', '\bf78%-84%\rm\newlineobstruction'
	%'Balloon, 2400, Lev5', '\bf85%-94%\rm\newlineobstruction'
	};
[ROC,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
	F(F.pumpSpeed==single(2400),:), classifiers, predStateVar, predStates, false);
Data.G1.Feature_Statistics.ROC = ROC;
Data.G1.Feature_Statistics.AUC = AUC;


%% Calculate pooled ROC curves
% ------------------------------

% Input for states of pooled occlusions above a threshold
predStateVar = 'balLev';
F.balLev = double(string(F.balLev));
predStates = {
	1, ' Lev 1-5' % all levels
	%2, ' Lev 2-5' % minimum level 2
	%3, ' Lev 3-5' % minimum level 3
	[2,3,4], 'Lev 2-4' % level 2, 3 and 4 specifically
	};
[ROC_pooled,AUC_pooled] = make_roc_curve_matrix_per_intervention_and_speed(...
	F(F.balLev~=5,:), classifiers, predStateVar, predStates, true, {}, false);
Data.G1.Feature_Statistics.ROC_Pooled = ROC_pooled;
Data.G1.Feature_Statistics.AUC_Pooled = AUC_pooled;

[ROC_pooled_rpm,AUC_pooled_rpm] = make_roc_curve_matrix_per_intervention_and_speed(...
	F(F.balLev~=5,:), classifiers, predStateVar, predStates, true, {}, true);
Data.G1.Feature_Statistics.ROC_Pooled_RPM = ROC_pooled_rpm;
Data.G1.Feature_Statistics.AUC_Pooled_RPM = AUC_pooled_rpm;


%% Save 
% -----------------------------------------------------------

%save_data('Periodograms', feats_path, Data.G1.Periodograms, {'matlab'});
save_data('Features', Config.feats_path, Data.G1.Features, {'matlab'});
save_data('Feature_Statistics', Config.stats_path, Data.G1.Feature_Statistics, {'matlab'});
save_features_as_separate_spreadsheets(Data.G1.Features, Config.feats_path);
save_statistics_as_separate_spreadsheets(Data.G1.Feature_Statistics, Config.stats_path);


%% Roundup
% -----------------------------------------------------------

multiWaitbar('CloseAll');
clear save_data check_table_var_input
%clear F G F_rel G_rel F_del G_del 
%clear Pxx idSpecs sequences
clear discrVars meanVars minMaxVars accVars hBands  pVars nominalAsBaseline ...
    bestAxVars levOrder pooled classifiers predStateVar predStates ROC AUC ...
	isHarmBand W W_rel relVars newVar vars ans
