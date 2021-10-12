%% NHA, Q and P, per catheter type
% Pendulating Mass in Inlet Conduit
% 3 X [nLevels] panels
% Figure 3 in submission for ASAIO

nhaVars = {
     'accA_y_nf_pow',[0,0.008]
     %'accA_x_nf_bpow',[0,0.008]
     %'accA_norm_nf_pow',[0,0.008]
     %'accA_norm_nf_bpow',[0,0.008]

 };
levelLabels = {
	'Inflated, 4.73 mm', 'Catheter 1'
	'Inflated, 6.60 mm', 'Catheter 2'
	'Inflated, 8.52 mm', 'Catheter 3'
	%'Inflated, 9 mm',    'Catheter 4'
	%'Inflated, 10 mm',   'Catheter 4'
	'Inflated, 11 mm',   'Catheter 4'
	};
xVar = 'arealOccl_pst';
xLims = [0,100];
titleStr = 'Pendulating Mass in Inlet Conduit';
xLab = 'Areal occlusion (%)';
figWidth = 275*size(levelLabels,1);

close all
plot_nha_power_and_flow_per_intervention(...
	F,G.med,R,nhaVars,levelLabels,xVar,xLims,xLab,titleStr,figWidth);


%% NHA, Q and P for afterload and prelod side by side 
% Control intervention
% 3 X 2 panels
% Figure 2 in submission for ASAIO

close all

nhaVars = {
     %'accA_x_nf_bpow',[0,0.008]
     'accA_y_nf_bpow',[0,0.008]
     %'accA_z_nf_pow',[0,0.008]
     %'accA_norm_nf_pow',[0,0.008]
	 %'accA_norm_nf_bpow',[0,0.008]
	 };
 
% Level categories plotted together
levelLabels = {
	'Afterload', 'Outflow tube clamp'
	'Preload',   'Inflow tube clamp'
	};

% Levels in separate panels 
%{
levelLabels = {
	'Preload Q red., 10%', 'Q reduced 10%'
	'Preload Q red., 20%', 'Q reduced 20%'
	'Preload Q red., 40%', 'Q reduced 40%'
	'Preload Q red., 60%', 'Q reduced 60%'
	'Preload Q red., 80%', 'Q reduced 80%'
};
	%}
	
xVar = 'QRedTarget_pst';
xLims = [0,100];
figWidth = 950;
xLab = 'Flow rate reduction targets (%)';
titleStr = 'Control intervensions';

plot_nha_power_and_flow_per_intervention(...
 	F,G.med,R,nhaVars,levelLabels,xVar,xLims,xLab,titleStr,figWidth);


%% ROC curves for each pooled diameter states and each speed
% Overlaid classifier curves 
% [no of states]x[no of speeds] panels 
% Figure 4 in submission for ASAIO

classifiers = {
 	'accA_y_nf_pow', 'SBP_{\ity}';
	'accA_x_nf_pow', 'SBP_{\itx}';
	'accA_z_nf_pow', 'SBP_{\itz}';
	...'accA_xynorm_nf_pow', 'SBP_{\it|xy|}';
	};
titleStr = 'ROC Curves for Pendulating Mass States';

close all
plot_roc_curve_matrix_per_intervention_and_speed(ROC,F,classifiers,titleStr);

%% ROC curves for each pooled diameter states
% Overlaid each speed
% 1x[no of states] panels

classifiers = {
 	'accA_y_nf_pow';
	%'accA_norm_nf_pow';
	};
predStates = {
	%'diam_4.30mm_or_more', '>= 4.30mm'
	'diam_4.73mm_or_more', '>= 4.73mm'
	%'diam_6.00mm_or_more', '>= 6.0mm'
	'diam_6.60mm_or_more', '>= 6.6mm'
	%'diam_7.30mm_or_more', '>= 7.30mm'
	'diam_8.52mm_or_more', '>= 8.52mm'
	%'diam_9mm_or_more', '>= 9mm'
	%'diam_10mm_or_more', '>= 10mm'
	'diam_11mm_or_more', '>= 11mm'
	%'diam_12mm', '= 12mm'
	};
titleStr = 'ROC Curves for Pool of Pendulating Mass States';

close all
plot_roc_curves_per_pooled_interventions(F_ROC,classifiers,predStates,titleStr);

%% Absolute NHA versus flow scatter
% Intervention type grouping by color
% 2x2 panels, one panel per speed

vars = {
%    'accA_y_nf_stdev',[0.01,0.19]
    'accA_x_nf_pow',[0,0.018]
    'accA_y_nf_pow',[0,0.018]
   };

close all
h_figs = plot_scatter_acc_against_Q(F,vars);

%% Individual effects aginst categories of Q red. and balloon occlusions
% [no of speeds]x1panels
% Includes all diameters (incl. intermediate levels) 
% D is numerical (unevenly distributed)

vars = {
	%'accA_x_nf_pow', [0,0.011]
	'accA_y_nf_pow', [0,0.011]
	%'accA_norm_nf_pow', [0,0.011]
	%'accA_y_nf_bpow', [0,0.011]
	%'accA_norm_nf_bpow', [0,0.011]
	%'accA_y_nf_mpf', [90,210]
	};

close all
plot_individual_effects_against_interv_cats_per_speed(vars,{'Absolute','Medians'},F,'Absolute median effects');

%% TODO: Make plot of aggregates with errorbars

% plot_individual_effects_against_interv_cats_per_speed(...
% 	G.med,vars,{'Absolute','Medians'},G.q1,G.q3,F,'Absolute median effects');
% 
