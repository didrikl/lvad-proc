%% Init preprocessed data from raw data or already preprocessed 

% Init from raw data or already pre-processed
%Init_IV2_Preprocess
%Init_IV2_Preprocessed


%% Calculate metrics of intervals tagged in the analysis_id column in Data

Environment_Analysis_IV2
idSpecs = init_id_specifications(idSpecs_path);

% Make descriptive variable statistics of each intervention
discrVars = {'Q_LVAD','P_LVAD'};
meanVars = {'p_eff','pGrad','Q','accA_x','accA_y','accA_z','accA_xynorm_nf',...
	'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'};
medianVars = {};
F_all = make_intervention_stats(Data,discrVars,meanVars,medianVars,idSpecs);

% Make band powers and periodograms of vibration variables of each intervention
accVars = {'accA_x','accA_y','accA_z','accA_x_nf','accA_y_nf','accA_z_nf'};
[F_all,psds] = make_power_spectra(Data,F_all,accVars,idSpecs,fs_new);

% Make relative and delta differences from tagged baselines 
F_rel_all = calc_relative_feats(F_all);
F_del_all = calc_delta_diff_feats(F_all);

% Filter out any extra measurements
F = F_all(ismember(F_all.interventionType,{'Effect','Control'}),:);
F_rel = F_rel_all(ismember(F_rel_all.interventionType,{'Effect','Control'}),:);
F_del = F_del_all(ismember(F_del_all.interventionType,{'Effect','Control'}),:);

% Save each table as .mat files and as Excel files
save_data('Features', feats_path, F, {'matlab','spreadsheet'});
save_data('Features - All', feats_path, F_all, {'matlab','spreadsheet'});
save_data('Features - Relative', feats_path, F_rel, {'matlab','spreadsheet'});
save_data('Features - Delta', feats_path, F_del, {'matlab','spreadsheet'});
%save_data('Power spectra densities', feats_path, F_rel, 'matlab');

multiWaitbar('CloseAll');
clear discrVars meanVars medianVars accVars

%% Make feature table for ROC analysis, with pooled diameter state vars

% Turn Power elevation into Power drop
F_ROC = join(F,F_del(:,{'id','P_LVAD_mean'}),'keys','id');
F_ROC.Properties.VariableNames{'P_LVAD_mean_F'} = 'P_LVAD_mean';
F_ROC.Properties.VariableNames{'P_LVAD_mean_right'} = 'P_LVAD_drop';
F_ROC.P_LVAD_drop = -F_ROC.P_LVAD_drop;

% Make boolean state variables for SPSS
F_ROC.('diam_4.31mm_or_more') = F_ROC.balloonDiam>=4.30;
F_ROC.('diam_4.73mm_or_more') = F_ROC.balloonDiam>=4.72;
F_ROC.('diam_6.00mm_or_more') = F_ROC.balloonDiam>=5.99;
F_ROC.('diam_6.60mm_or_more') = F_ROC.balloonDiam>=6.59;
F_ROC.('diam_7.30mm_or_more') = F_ROC.balloonDiam>=7.29;
F_ROC.('diam_8.52mm_or_more') = F_ROC.balloonDiam>=8.51;
F_ROC.('diam_9mm_or_more')    = F_ROC.balloonDiam>=8.99;
F_ROC.('diam_10mm_or_more')   = F_ROC.balloonDiam>=9.99;
F_ROC.('diam_11mm_or_more')   = F_ROC.balloonDiam>=10.99;
F_ROC.('diam_12mm_or_more')   = F_ROC.balloonDiam>=11.99;

% Make pooled diameter state digit codes
% NOTE: Alternative code could make use of ordinal rating instead
F_ROC.pooledDiam = zeros(height(F_ROC),1);
F_ROC.pooledDiam(F_ROC.('diam_4.31mm_or_more')) = 1;
F_ROC.pooledDiam(F_ROC.('diam_4.73mm_or_more')) = 2;
F_ROC.pooledDiam(F_ROC.('diam_6.00mm_or_more')) = 3;
F_ROC.pooledDiam(F_ROC.('diam_6.60mm_or_more')) = 4;
F_ROC.pooledDiam(F_ROC.('diam_7.30mm_or_more')) = 5;
F_ROC.pooledDiam(F_ROC.('diam_8.52mm_or_more')) = 6;
F_ROC.pooledDiam(F_ROC.('diam_9mm_or_more'))    = 7;
F_ROC.pooledDiam(F_ROC.('diam_10mm_or_more'))   = 8;
F_ROC.pooledDiam(F_ROC.('diam_11mm_or_more'))   = 9;
F_ROC.pooledDiam(F_ROC.('diam_12mm_or_more'))   = 10;

% Tables for concrete/specific diameter state levels for SPSS
F_ROC_SPSS.PCI1 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 4.73 mm' ),:);
F_ROC_SPSS.PCI2 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 6.60 mm' ),:);
F_ROC_SPSS.PCI3 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 8.52 mm' ),:);
F_ROC_SPSS.RHC  = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 11 mm' ),:);

% Tables for pooled diameter state levels for SPSS
F_ROC_SPSS.D_4_73_or_more = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=4.30 ),:);
F_ROC_SPSS.D_6_60_or_more = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=6.59 ),:);
F_ROC_SPSS.D_8_52_or_more = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=8.51 ),:);
F_ROC_SPSS.D_9_or_more    = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=8.99 ),:);
F_ROC_SPSS.D_10_or_more   = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=9.99 ),:);
F_ROC_SPSS.D_11           = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=10.99 ),:);

% Save as mat file and Excel files
save_data('Features - ROC', feats_path, F_ROC, {'matlab','spreadsheet'});
save_data('Features - ROC - SPSS', feats_path, F_ROC_SPSS, 'matlab');

% Save as Excel files for analysis in SPSS
save_data('Features - ROC - PCI 1', feats_path, F_ROC_SPSS.PCI1, 'spreadsheet');
save_data('Features - ROC - PCI 2', feats_path, F_ROC_SPSS.PCI2, 'spreadsheet');
save_data('Features - ROC - PCI 3', feats_path, F_ROC_SPSS.PCI3, 'spreadsheet');
save_data('Features - ROC - RHC', feats_path, F_ROC_SPSS.RHC, 'spreadsheet');
save_data('Features - ROC - 4.73mm or more', feats_path, F_ROC_SPSS.D_4_73_or_more, 'spreadsheet');
save_data('Features - ROC - 6.60mm or more', feats_path, F_ROC_SPSS.D_6_60_or_more, 'spreadsheet');
save_data('Features - ROC - 8.52mm or more', feats_path, F_ROC_SPSS.D_8_52_or_more, 'spreadsheet');
save_data('Features - ROC - 9mm or more', feats_path, F_ROC_SPSS.D_9_or_more, 'spreadsheet');
save_data('Features - ROC - 10mm or more', feats_path, F_ROC_SPSS.D_10_or_more, 'spreadsheet');
save_data('Features - ROC - 11mm', feats_path, F_ROC_SPSS.D_11, 'spreadsheet');


%% Calc group means and standard deviations

G = make_group_stats(F,idSpecs);
G_rel = make_group_stats(F_rel,idSpecs);
G_del = make_group_stats(F_del,idSpecs);

% Save structs as .mat files
save_data('Group stats tables', stats_path, G, 'matlab');
save_data('Group stats tables - Delta', stats_path, G_del, 'matlab');
save_data('Group stats tables - Relative', stats_path, G_rel, 'matlab');

% Save each table as Excel file
save_data('Group mean of features', stats_path, G.avg, 'spreadsheet');
save_data('Group st.dev. of features', stats_path, G.std, 'spreadsheet');
save_data('Group median of features', stats_path, G.med, 'spreadsheet');
save_data('Group 25-percentile of features', stats_path, G.q1, 'spreadsheet');
save_data('Group 75-percentile of features', stats_path, G.q3, 'spreadsheet');
save_data('Group mean of features - Relative', stats_path, G_rel.avg, 'spreadsheet');
save_data('Group st.dev. of features - Relative', stats_path, G_rel.std, 'spreadsheet');
save_data('Group median of features - Relative', stats_path, G_rel.med, 'spreadsheet');
save_data('Group 25-percentile of features - Relative', stats_path, G_rel.q1, 'spreadsheet');
save_data('Group 75-percentile of features - Relative', stats_path, G_rel.q3, 'spreadsheet');
save_data('Group mean of features - Delta', stats_path, G_del.avg, 'spreadsheet');
save_data('Group st.dev. of features - Delta', stats_path, G_del.std, 'spreadsheet');
save_data('Group median of features - Delta', stats_path, G_del.med, 'spreadsheet');
save_data('Group 25-percentile of features - Delta', stats_path, G_del.q1, 'spreadsheet');
save_data('Group 75-percentile of features - Delta', stats_path, G_del.q3, 'spreadsheet');


%% Do Wilcoxens pair test and make table of median and p-values
% Make stats table
% Calculate p values from Wilcoxens pair rank test

pVars = {
 	'accA_x_pow'
    'accA_y_pow'
 	'accA_z_pow'
	'accA_x_nf_pow'
    'accA_y_nf_pow'
 	'accA_z_nf_pow'
	'accA_y_nf_stdev'
	%'accA_xynorm_nf_pow'
	%'accA_norm_nf_pow'
	%'accA_y_nf_bpow'
	'Q_mean'
	%'Q_LVAD_mean'
	'P_LVAD_mean'
	%'pGrad_mean'
	%'pGrad_stdev'
	%'p_aff_mean'
	%'p_eff_stdev'
	%'accA_y_h3pow'
	};

% Prepare data for paired statistical test, e.g. in SPSS
W = unstack(F,pVars,'levelLabel',...
	'GroupingVariables',{'seq','pumpSpeed'},...
	'VariableNamingRule','preserve');
% W_rel = unstack(F_rel,pVars,'levelLabel',...
% 	'GroupingVariables',{'seq','pumpSpeed'},...
% 	'VariableNamingRule','preserve');

% Save each results table as .mat files and as Excel files
save_data('Features - Paired for Wilcoxens signed rank test',feats_path, W, {'spreadsheet','matlab'});
%save_data('Features - Paired for Wilcoxens signed rank test - Relative',feats_path, W_rel, {'spreadsheet','matlab'});

[P,R] = make_results_table_from_paired_signed_rank_test(W,G,pVars);
%[P_rel,R_rel] = make_results_table_from_paired_signed_rank_test(W_rel,G_rel,pVars);

save_data('Results - Median and p-values - Wilcoxon paired signed rank test', stats_path, R, {'spreadsheet','matlab'});
%save_data('Results - Median and p-values - Wilcoxon paired signed rank test - Relative', stats_path, R_rel, {'spreadsheet','matlab'});
save_data('Results - p-values - Wilcoxon paired signed rank test', stats_path, P, {'spreadsheet','matlab'});
%save_data('Results - p-values - Wilcoxon paired signed rank test - Relative', stats_path, P_rel, {'spreadsheet','matlab'});


%% Calculate ROC curves and corresponding confidence intervals

classifiers = {
  	'accA_y_pow'
 	'accA_x_pow'
 	'accA_z_pow'
 	'accA_y_nf_pow'
 	'accA_x_nf_pow'
 	'accA_z_nf_pow'
	%'accA_xynorm_nf_pow'
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
	F,classifiers,predStateVar,predStates,pooled);

save_data('Results - AUC', stats_path, AUC, {'spreadsheet','matlab'});
save_data('Results - ROC curve info', stats_path, ROC, 'matlab');

%% Round up
clear save_data
clear pVars pooled classifiers predStateVar predStates