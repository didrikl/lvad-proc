% NOTE: Split this script into Calc_IV2_SegmentFeatures and 
% Calc_IV2_StatisticalData?

%% Init preprocessed data from raw data or already preprocessed 

Environment_Analysis_IV2

% Init from raw data or already pre-processed
%Init_IV2_Preprocess
%Init_IV2_Preprocessed


%% Calculate features of signal intervals denoted with an analysis ID tag

idSpecs = init_id_specifications(idSpecs_path);

F_all = make_stats(Data,...
    {'Q_LVAD','P_LVAD'},...
    {'p_eff','p_aff','pGrad','Q','accA_norm','accA_xynorm','accA_x','accA_y','accA_z',...
    'accA_xynorm_nf','accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'},...
    idSpecs);
[F_all,psds] = make_power_spectra(Data,F_all,...
    {'accA_norm','accA_x','accA_y','accA_z',...
    'accA_xynorm_nf','accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'},...
    idSpecs);

F_rel_all = calc_relative_feats(F_all);
F_del_all = calc_delta_diff_feats(F_all);

% Filter out any extra measurements
F = F_all(ismember(F_all.interventionType,{'Effect','Control'}),:);
F_rel = F_rel_all(ismember(F_rel_all.interventionType,{'Effect','Control'}),:);
F_del = F_del_all(ismember(F_del_all.interventionType,{'Effect','Control'}),:);

% Save each table as .mat files
save_table('Features', feats_path, F, 'matlab');
save_table('Features - All', feats_path, F_all, 'matlab');
save_table('Features - Relative', feats_path, F_rel, 'matlab');
save_table('Features - Delta', feats_path, F_rel, 'matlab');
%save(fullfile(stats_path,'Power spectra densities'), 'psds');

% Save each table as Excel file
save_table('Features', feats_path, F, 'spreadsheet');
save_table('Features - All', feats_path, F_all, 'spreadsheet');
save_table('Features - Relative', feats_path, F_rel, 'spreadsheet');
save_table('Features - Delta', feats_path, F_del, 'spreadsheet');

multiWaitbar('CloseAll');


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
F_ROC_PCI1 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 4.73 mm' ),:);
F_ROC_PCI2 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 6.60 mm' ),:);
F_ROC_PCI3 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 8.52 mm' ),:);
F_ROC_RHC  = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 11 mm' ),:);

% Tables for pooled diameter state levels for SPSS
F_ROC_4_73_or_more = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=4.30 ),:);
F_ROC_6_60_or_more = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=6.59 ),:);
F_ROC_8_52_or_more = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=8.51 ),:);
F_ROC_9_or_more    = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=8.99 ),:);
F_ROC_10_or_more   = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=9.99 ),:);
F_ROC_11           = F(( F.interventionType=='Control' | F_ROC.balloonDiam>=10.99 ),:);

% Save as mat file
save_table('Features - ROC', feats_path, F_ROC, 'matlab');

% Save each table as Excel file
save_table('Features - ROC', feats_path, F_ROC, 'spreadsheet');
save_table('Features - ROC - PCI 1', feats_path, F_ROC_PCI1, 'spreadsheet');
save_table('Features - ROC - PCI 2', feats_path, F_ROC_PCI2, 'spreadsheet');
save_table('Features - ROC - PCI 3', feats_path, F_ROC_PCI3, 'spreadsheet');
save_table('Features - ROC - RHC', feats_path, F_ROC_RHC, 'spreadsheet');
save_table('Features - ROC - 4.73mm or more', feats_path, F_ROC_4_73_or_more, 'spreadsheet');
save_table('Features - ROC - 6.60mm or more', feats_path, F_ROC_6_60_or_more, 'spreadsheet');
save_table('Features - ROC - 8.52mm or more', feats_path, F_ROC_8_52_or_more, 'spreadsheet');
save_table('Features - ROC - 9mm or more', feats_path, F_ROC_9_or_more, 'spreadsheet');
save_table('Features - ROC - 10mm or more', feats_path, F_ROC_10_or_more, 'spreadsheet');
save_table('Features - ROC - 11mm', feats_path, F_ROC_11, 'spreadsheet');


%% Calc group means and standard deviations

G = make_group_stats(F,idSpecs);
G_rel = make_group_stats(F_rel,idSpecs);
G_del = make_group_stats(F_del,idSpecs);
% G_ROC = make_group_stats(F_ROC,idSpecs);

% Save structs as .mat files
save(fullfile(stats_path,'Group stats tables'), 'G');
save(fullfile(stats_path,'Group stats tables - Delta'), 'G_del');
save(fullfile(stats_path,'Group stats tables - Relative'), 'G_rel');

% Save each table as Excel file
save_table('Group mean of features', stats_path, G.avg, 'spreadsheet');
save_table('Group st.dev. of features', stats_path, G.std, 'spreadsheet');
save_table('Group median of features', stats_path, G.med, 'spreadsheet');
save_table('Group 25-percentile of features', stats_path, G.q1, 'spreadsheet');
save_table('Group 75-percentile of features', stats_path, G.q3, 'spreadsheet');
save_table('Group mean of features - Relative', stats_path, G_rel.avg, 'spreadsheet');
save_table('Group st.dev. of features - Relative', stats_path, G_rel.std, 'spreadsheet');
save_table('Group median of features - Relative', stats_path, G_rel.med, 'spreadsheet');
save_table('Group 25-percentile of features - Relative', stats_path, G_rel.q1, 'spreadsheet');
save_table('Group 75-percentile of features - Relative', stats_path, G_rel.q3, 'spreadsheet');
save_table('Group mean of features - Delta', stats_path, G_del.avg, 'spreadsheet');
save_table('Group st.dev. of features - Delta', stats_path, G_del.std, 'spreadsheet');
save_table('Group median of features - Delta', stats_path, G_del.med, 'spreadsheet');
save_table('Group 25-percentile of features - Delta', stats_path, G_del.q1, 'spreadsheet');
save_table('Group 75-percentile of features - Delta', stats_path, G_del.q3, 'spreadsheet');


%% Do Wilcoxens pair test and make table of median and p-values
% Make stats table
% Calculate p values from Wilcoxens pair rank test

pVars = {
	'accA_x_nf_pow'
    'accA_y_nf_pow'
	'accA_z_nf_pow'
	%'accA_xynorm_nf_pow'
	'accA_norm_nf_pow'
	%'accA_x_nf_bpow'
	%'accA_y_nf_bpow'
	%'accA_xynorm_nf_bpow'
	%'accA_norm_nf_bpow'
	'Q_mean'
	'Q_LVAD_mean'
	'P_LVAD_mean'
	'pGrad_mean'
	'p_aff_mean'
	'p_eff_mean'
	};

% Prepare data for paired statistical test
W = unstack(F,pVars,'levelLabel',...
	'GroupingVariables',{'seq','pumpSpeed'},...
	'VariableNamingRule','preserve');
	
[P,R] = make_results_table_from_paired_signed_rank_test(W,G,pVars,'levelLabel');
R_sel = R(ismember(R.levelLabel,{'Nominal','Inflated, 4.73 mm',...
	'Inflated, 6.60 mm','Inflated, 8.52 mm','Inflated, 11 mm'}),:);

% Save for analysis in SPSS
save_table('Features - Paired for Wilcoxens signed rank test',stats_path, W, 'spreadsheet');

% Save each results table as .mat files
save_table('Features - Paired for Wilcoxens signed rank test',stats_path, W, 'matlab');
save_table('Results - Median and p-values - Wilcoxon paired signed rank test', stats_path, R, 'matlab');
save_table('Results - p-values - Wilcoxon paired signed rank test', stats_path, P, 'matlab');
save_table('Results - Selected median and p-values - Wilcoxon paired signed rank test', stats_path, R_sel, 'matlab');

% Save each results table as Excel file
save_table('Results - Median and p-values - Wilcoxon paired signed rank test', stats_path, R, 'spreadsheet');
save_table('Results - p-values - Wilcoxon paired signed rank test', stats_path, P, 'spreadsheet');
save_table('Results - Selected median and p-values - Wilcoxon paired signed rank test', stats_path, R_sel, 'spreadsheet');


%% Round up
clear save_table
clear pVars