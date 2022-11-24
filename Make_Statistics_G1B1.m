%% Calculate metrics of intervals tagged in the analysis_id column in Data

% This defines the relevant ids for analysis
Config =  get_processing_config_defaults_G1B;
init_multiwaitbar_calc_stats
	
idSpecs = init_id_specifications(Config.idSpecs_path);
idSpecs = idSpecs(not(idSpecs.extra),:);
idSpecs = idSpecs(not(contains(string(idSpecs.analysis_id),{'E'})),:);
idSpecs = idSpecs(contains(string(idSpecs.categoryLabel),{'Injection',}),:);
%idSpecs = idSpecs((ismember(idSpecs.interventionType,{'Control','Effect'})),:);

sequences = {
  	'Seq6'
   	'Seq7'
   	'Seq8'
   	'Seq11' 	
    'Seq12'
   	'Seq13'
	};

Data.G1B.Features.idSpecs = idSpecs;
Data.G1B.Features.sequences = sequences;

%%


accVars = {
	'accA_x'
	'accA_y'
	'accA_z'
	'accB_x'
	'accB_y'
	'accB_z'
	%'accB_norm'
	};
meanVars = {
	'P_LVAD'
	'Q_LVAD'
	'Q'
	'CO'
	};
	
eventsToClip = {
	'Injection, saline'
	'Hands on'
	'Echo on'
	'Fibrillation'
	};

seqDefs = cellstr("G1B_"+sequences);
Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVars, Config, eventsToClip);

% partSpec with all data parts to be analysed gathered
partSpecNo = 1;

F = make_features_G1(sequences, Data, partSpecNo, idSpecs, accVars, meanVars);

nominalAsBaseline = true;
F_rel = calc_relative_feats(F, nominalAsBaseline);
F_del = calc_delta_diff_feats(F, nominalAsBaseline);
F.P_LVAD_change = abs(F_del.P_LVAD);


F.h1A = max(F{:,{'accA_x_h1Avg','accA_y_h1Avg','accA_z_h1Avg'}}, [], 2);
F.h1B = max(F{:,{'accB_x_h1Avg','accB_y_h1Avg','accB_z_h1Avg'}}, [], 2);
F.h2A = max(F{:,{'accA_x_h2Avg','accA_y_h2Avg','accA_z_h2Avg'}}, [], 2);
F.h2B = max(F{:,{'accB_x_h2Avg','accB_y_h2Avg','accB_z_h2Avg'}}, [], 2);
F.h3A = max(F{:,{'accA_x_h3Avg','accA_y_h3Avg','accA_z_h3Avg'}}, [], 2);
F.h3B = max(F{:,{'accB_x_h3Avg','accB_y_h3Avg','accB_z_h3Avg'}}, [], 2);
F.h4A = max(F{:,{'accA_x_h4Avg','accA_y_h4Avg','accA_z_h4Avg'}}, [], 2);
F.h4B = max(F{:,{'accB_x_h4Avg','accB_y_h4Avg','accB_z_h4Avg'}}, [], 2);

%%

for thr = 3:0.05:5
	F.effA = F.h3A>thr;
	F.effB = F.h3B>thr;
	F.accB_FP = not(F.effA) & F.effB;
	F.accB_TP = F.effA & F.effB;
	F.accB_TN = not(F.effA) & not(F.effB);
	F.accB_FN = F.effA & not(F.effB);
	fprintf('\nFP=%d, TP=%d, FN=%d and TN=%d for threshold=%1.2f',nnz(F.accB_FP),nnz(F.accB_TP),nnz(F.accB_FN),nnz(F.accB_TN),thr)
end

%%

thr = 4.75;
F.effA = F.h3A>thr;
F.effB = F.h3B>thr;
F.accB_FP = not(F.effA) & F.effB;
F.accB_TP = F.effA & F.effB;
F.accB_TN = not(F.effA) & not(F.effB);
F.accB_FN = F.effA & not(F.effB);%countTP = sum(F.accB_TP)

PLVAD_del_effA_mean = mean(F_del.P_LVAD(F.effA),'omitnan');
PLVAD_del_noEffA_mean = mean(F_del.P_LVAD(not(F.effA)),'omitnan');
PLVAD_del_effA_std = std(F_del.P_LVAD(F.effA),'omitnan');
PLVAD_del_noEffA_std = std(F_del.P_LVAD(not(F.effA)),'omitnan');

%PLVAD_del_effA_mean = mean(F_del.P_LVAD(F.accB_TP),'omitnan')

PLVAD_effA_median = median(F_del.P_LVAD(F.effA),'omitnan');
PLVAD_noEffA_median = median(F_del.P_LVAD(not(F.effA)),'omitnan');
PLVAD_effA_iqr = iqr(F_del.P_LVAD(F.effA));
PLVAD_noEffA_iqr = iqr(F_del.P_LVAD(not(F.effA)));

% corr(F.h3A(F.effA), F.h3B(F.effA), 'Type','Spearman')
% corr(F.h3A(F.effA), F.h3B(F.effA), 'Type','Pearson')

F_BL = F(F.intervType=='Baseline',:);
F_TE = F(not(F.intervType=='Baseline') & F.intervType=='Steady-state',:);
%F_TE = F(not(F.intervType=='Baseline'),:);% & F.intervType=='Steady-state',:);
F_INJ = F(not(F.intervType=='Baseline') & contains(string(F.event),'Injection') & F.intervType=='Transitional',:);

%%

thr = 20;
F.effA2 = F.h3A>thr;
F.effB2 = F.h3B>thr;
F.accB_FP2 = not(F.effA) & F.effB;
F.accB_TP2 = F.effA & F.effB;
F.accB_TN2 = not(F.effA) & not(F.effB);
F.accB_FN2 = F.effA & not(F.effB);%countTP = sum(F.accB_TP)


%%

close all
hFig = figure('Name','Scatter - Harmonic comparison',...
	'Position',[10,10,600*2-100,(5/7)*600]);
hold on
markerSize = 25;

hSub(1) = subplot(1,2,1);
hSub(2) = subplot(1,2,2);
set(hSub, 'Units','points', 'NextPlot','add');

h = hSub(1);
h.ColorOrderIndex = 1;
scatter(h, F_INJ.h4A(contains(string(F_INJ.id),'Seq6')),  F_INJ.h4B(contains(string(F_INJ.id),'Seq6')), 'filled', 'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_INJ.h4A(contains(string(F_INJ.id),'Seq7')),  F_INJ.h4B(contains(string(F_INJ.id),'Seq7')), 'filled', 'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_INJ.h4A(contains(string(F_INJ.id),'Seq8')),  F_INJ.h4B(contains(string(F_INJ.id),'Seq8')), 'filled', 'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_INJ.h4A(contains(string(F_INJ.id),'Seq11')), F_INJ.h4B(contains(string(F_INJ.id),'Seq11')), 'filled', 'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_INJ.h4A(contains(string(F_INJ.id),'Seq12')), F_INJ.h4B(contains(string(F_INJ.id),'Seq12')), 'filled', 'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_INJ.h4A(contains(string(F_INJ.id),'Seq13')), F_INJ.h4B(contains(string(F_INJ.id),'Seq13')), 'filled', 'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')

h.ColorOrderIndex = 1;
scatter(h, F_TE.h4A(contains(string(F_TE.id),'Seq6')),  F_TE.h4B(contains(string(F_TE.id),'Seq6')),'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_TE.h4A(contains(string(F_TE.id),'Seq7')),  F_TE.h4B(contains(string(F_TE.id),'Seq7')),'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_TE.h4A(contains(string(F_TE.id),'Seq8')),  F_TE.h4B(contains(string(F_TE.id),'Seq8')),'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_TE.h4A(contains(string(F_TE.id),'Seq11')), F_TE.h4B(contains(string(F_TE.id),'Seq11')),'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_TE.h4A(contains(string(F_TE.id),'Seq12')), F_TE.h4B(contains(string(F_TE.id),'Seq12')),'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')
scatter(h, F_TE.h4A(contains(string(F_TE.id),'Seq13')), F_TE.h4B(contains(string(F_TE.id),'Seq13')),'MarkerEdgeColor','flat','MarkerEdgeAlpha',.7);%, markerSize, 'Marker','*')

h.ColorOrderIndex = 1;
scatter(h, F_BL.h4A(contains(string(F_BL.id),'Seq6')),  F_BL.h4B(contains(string(F_BL.id),'Seq6')), 3*markerSize, 'filled', 'Marker','pentagram', 'MarkerEdgeColor',[0 0 0])
scatter(h, F_BL.h4A(contains(string(F_BL.id),'Seq7')),  F_BL.h4B(contains(string(F_BL.id),'Seq7')), 3*markerSize, 'filled', 'Marker','pentagram', 'MarkerEdgeColor',[0 0 0])
scatter(h, F_BL.h4A(contains(string(F_BL.id),'Seq8')),  F_BL.h4B(contains(string(F_BL.id),'Seq8')), 3*markerSize, 'filled', 'Marker','pentagram', 'MarkerEdgeColor',[0 0 0])
scatter(h, F_BL.h4A(contains(string(F_BL.id),'Seq11')), F_BL.h4B(contains(string(F_BL.id),'Seq11')), 3*markerSize, 'filled', 'Marker','pentagram', 'MarkerEdgeColor',[0 0 0])
scatter(h, F_BL.h4A(contains(string(F_BL.id),'Seq12')), F_BL.h4B(contains(string(F_BL.id),'Seq12')), 3*markerSize, 'filled', 'Marker','pentagram', 'MarkerEdgeColor',[0 0 0])
scatter(h, F_BL.h4A(contains(string(F_BL.id),'Seq13')), F_BL.h4B(contains(string(F_BL.id),'Seq13')), 3*markerSize, 'filled', 'Marker','pentagram', 'MarkerEdgeColor',[0 0 0])

h = hSub(2);
h.ColorOrderIndex = 1;
scatter(h, F_TE.h3A(contains(string(F_TE.id),'Seq6')),  F_TE.h3B(contains(string(F_TE.id),'Seq6')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_TE.h3A(contains(string(F_TE.id),'Seq7')),  F_TE.h3B(contains(string(F_TE.id),'Seq7')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_TE.h3A(contains(string(F_TE.id),'Seq8')),  F_TE.h3B(contains(string(F_TE.id),'Seq8')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_TE.h3A(contains(string(F_TE.id),'Seq11')), F_TE.h3B(contains(string(F_TE.id),'Seq11')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_TE.h3A(contains(string(F_TE.id),'Seq12')), F_TE.h3B(contains(string(F_TE.id),'Seq12')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_TE.h3A(contains(string(F_TE.id),'Seq13')), F_TE.h3B(contains(string(F_TE.id),'Seq13')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')

h.ColorOrderIndex = 1;
scatter(h, F_BL.h3A(contains(string(F_BL.id),'Seq6')),  F_BL.h3B(contains(string(F_BL.id),'Seq6')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_BL.h3A(contains(string(F_BL.id),'Seq7')),  F_BL.h3B(contains(string(F_BL.id),'Seq7')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_BL.h3A(contains(string(F_BL.id),'Seq8')),  F_BL.h3B(contains(string(F_BL.id),'Seq8')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_BL.h3A(contains(string(F_BL.id),'Seq11')), F_BL.h3B(contains(string(F_BL.id),'Seq11')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_BL.h3A(contains(string(F_BL.id),'Seq12')), F_BL.h3B(contains(string(F_BL.id),'Seq12')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')
scatter(h, F_BL.h3A(contains(string(F_BL.id),'Seq13')), F_BL.h3B(contains(string(F_BL.id),'Seq13')), markerSize, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5,'MarkerEdgeColor','flat')



yline(h, thr)
xline(h, thr)
ylim(h, [-5, 50]);
xlim(h, [-5, 70]);
yLim = ylim(h);
xLim = xlim(h);
xticks(h, -5:10:70)
yticks(h, -5:10:50)
patch(h, 'XData',[xLim(1),thr,thr,xLim(1),], 'YData',[yLim(1),yLim(1),thr,thr],...
	'FaceAlpha',0.15,...
	'EdgeColor','none',...
	'HandleVisibility','off');


harmA = [F.h3A; F.h4A];
harmB = [F.h3B; F.h4B];
% corr(harmA(F.effA & contains(string(F.id),'Seq11')), harmB(F.effA & contains(string(F.id),'Seq11')), 'Type','Spearman')
% corr(harmA(F.effA & contains(string(F.id),'Seq11')), harmB(F.effA & contains(string(F.id),'Seq11')), 'Type','Pearson')
% 
% corr(harmA(F.effA & contains(string(F.id),'Seq12')), harmB(F.effA & contains(string(F.id),'Seq12')), 'Type','Spearman')
% corr(harmA(F.effA & contains(string(F.id),'Seq12')), harmB(F.effA & contains(string(F.id),'Seq12')), 'Type','Pearson')


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
Data.G1B.Features.Absolute = F_seq;
Data.G1B.Features.Relative = F_rel;
Data.G1B.Features.Delta = F_del;


% 
% %% Save 
% % -----------------------------------------------------------
% 
% save_data('Features', Config.feats_path, Data.G1B.Features, {'matlab'});
% save_data('Feature_Statistics', Config.stats_path, Data.G1B.Feature_Statistics, {'matlab'});
% save_features_as_separate_spreadsheets(Data.G1B.Features, Config.feats_path);
% save_statistics_as_separate_spreadsheets(Data.G1B.Feature_Statistics, Config.stats_path);
% 
% 
% %% Roundup
% % -----------------------------------------------------------
% 
% multiWaitbar('CloseAll');
% clear save_data check_table_var_input
% clear discrVars meanVars minMaxVars accVars hBands  pVars nominalAsBaseline ...
%     bestAxVars levOrder pooled classifiers predStateVar predStates ROC AUC ...
% 	isHarmBand W W_rel relVars newVar vars ans

%%


