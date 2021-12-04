%% NHA, Q and P, per catheter type
% Pendulating Mass in Inlet Conduit
% 3 X [nLevels] panels
% Figure 3 in submission for ASAIO

nhaVars = {
%      'accA_x_nf_pow',[0,0.008]
      'accA_y_nf_pow',[0,8]
%      'accA_z_nf_pow',[0,0.008]
%	 'accA_y_nf_stdev',[]
     %'accA_x_nf_bpow',[0,0.008]
     %'accA_norm_nf_pow',[0,0.008]
	 %'p_eff_mean',[55,100]
	 %'pGrad_mean',[]
	 %'Q_LVAD_mean',[0 8]
 };
levelLabels = {
%	'Inflated, 4.31 mm', 'Catheter 1'
	'Inflated, 4.73 mm', 'Catheter 1'
%	'Inflated, 6.00 mm', 'Catheter 2'
	'Inflated, 6.60 mm', 'Catheter 2'
%	'Inflated, 7.30 mm', 'Catheter 3'
	'Inflated, 8.52 mm', 'Catheter 3'
%	'Inflated, 9 mm',    'Catheter 4'
	%'Inflated, 10 mm',   'Catheter 4'
	'Inflated, 11 mm',   'Catheter 4'
	%'Inflated, 12 mm',   'Catheter 4'
	};
xVar = 'arealOccl_pst';
xLims = [0,100];
tit = 'Pendulating Mass in Inlet Conduit';
xLab = 'Areal inflow occlusion (%)';

close all
plot_nha_power_and_flow_per_intervention(F,G.med,R,nhaVars,levelLabels,xVar,xLims,xLab,tit,'effect');


%% NHA, Q and P for afterload and prelod side by side 
% Control intervention
% 3 X 2 panels
% Figure 2 in submission for ASAIO

close all

nhaVars = {
     %'accA_x_nf_bpow',[0,8]
     %'accA_y_nf_bpow',[0,8]
    'accA_y_nf_pow',[0 8]
     %%'accA_z_nf_pow',[0,8]
     %'accA_norm_nf_pow',[0,8]
	 %'accA_norm_nf_bpow',[0,8]
	 };
 
% Level categories plotted together
levelLabels = {
	'Afterload', 'Outflow clamp'
	'Preload',   'Inflow clamp'
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
xLab = 'Flow rate reduction targets (%)';
tit = 'Control intervensions';

plot_nha_power_and_flow_per_intervention(F,G.med,R,nhaVars,levelLabels,xVar,xLims,xLab,tit,'control');


%% ROC curves for each diameter states and each speed
% Overlaid classifier curves 
% [no of states]x[no of speeds] panels 
% Figure 4 in submission for ASAIO

classifiers = {
 	'accA_y_nf_pow', 'NHA_{\ity}';
	'accA_x_nf_pow', 'NHA_{\itx}';
	'accA_z_nf_pow', 'NHA_{\itz}';
	...'accA_xynorm_nf_pow', 'NHA_{\it|xy|}';
	};
tit = 'ROC Curves for Pendulating Mass States';

close all
plot_roc_curve_matrix_per_intervention_and_speed(ROC,F,classifiers,tit);

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
tit = 'ROC Curves for Pool of Pendulating Mass States';

close all
plot_roc_curves_per_pooled_interventions(F_ROC,classifiers,predStates,tit);

%% Absolute NHA versus flow scatter
% Intervention type grouping by color
% 2x2 panels, one panel per speed

vars = {
%    'accA_y_nf_stdev',[0.01,0.19]
    'accA_x_nf_pow',[0,0.018]
    'accA_y_nf_pow',[0,0.018]
   };

close all
plot_scatter_acc_against_Q(F,vars);
plot_scatter_relative_acc_and_Q_LVAD_against_Q(F,F_rel,vars);

%% Individual effects aginst categories of Q red. and balloon occlusions
% [no of speeds]x1panels
% Includes all diameters (incl. intermediate levels) 
% D is numerical (unevenly distributed)

vars = {
	%'accA_x_nf_pow', [0,0.011]
	'accA_y_nf_pow', [0,0.011]
	%'accA_y_nf_bpow', [0,0.011]
	%'accA_y_nf_mpf', [90,210]
	};

close all
plot_individual_effects_against_interv_cats_per_speed(...
	vars,{'Absolute','Medians'},F,'Absolute median effects');

%% Aggregated effects aginst categories of Q red. and balloon occlusions
% [no of speeds]x1panels
% Includes all diameters (incl. intermediate levels) 
% D is numerical (unevenly distributed)

vars = {
	%'accA_x_nf_pow', [0,0.011]
	'accA_y_nf_pow', [0,0.011]
	%'accA_y_nf_bpow', [0,0.011]
	%'accA_y_nf_mpf', [90,210]
	};

close all
plot_aggregate_effects_against_interv_cats_per_speed(G.med,vars,{'median','absolute'},G.q1,G.q3)