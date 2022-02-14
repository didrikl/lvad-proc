%% Spectrograms 
% [2x2] panels, controls to the left and balloon interventions to the right
% Figure 3 in submission for ASAIO

tit = 'Spectrogram';
S = Data.IV2.Seq10.S;
var = 'accA_y_NF';
rpm = 2800;

IDs1 = {
		'02.0 #1'
		% 	'52.0'
		'52.1'
		'52.2'
		'52.3'
		'52.4'
		% 	'62.0'
		% 	'62.5'
		% 	'62.1'
		% 	'62.2'
		% 	'62.3'
		% 	'62.4'
		};
	IDs2 = {
		'02.0 #1'
		%'12.3'
		'22.3'
		'32.3'
		'42.4'
		%'42.5'
		};

close all
make_spectrogram_figure_IV2(S, tit, var, rpm, Data.IV2.pc.fs, IDs1, IDs2);

clear tit s var rpm

%% NHA, Q and P, per catheter type
% Pendulating Mass in Inlet Conduit
% 3 X [nLevels] panels
% Figure 5 in submission for ASAIO

nhaVars = {
     %'accA_x_NF_b1_pow',[0,0.008]
      'accA_y_NF_b1_pow',[0,8]
     %'accA_z_NF_b1_pow',[0,0.008]
 	 %'accA_y_NF_stdev',[]
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

xLims = [0,100];
tit = 'Pendulating Mass in Inlet Conduit';
xLab = 'Areal inflow obstruction (%)';

home; close all
plot_nha_power_and_flow_per_intervention(Data.IV2.Features.Absolute,...
	Data.IV2.Feature_Statistics.Descriptive_Absolute.med, ...
	Data.IV2.Feature_Statistics.Results, ...
	nhaVars, levelLabels, 'arealObstr_pst', xLims, xLab, tit, 'effect');

clear nhaVars levelLabels xLims xLab tit

%% NHA, Q and P for afterload and prelod side by side 
% Control intervention
% 3 X 2 panels
% Figure 4 in submission for ASAIO

close all

nhaVars = {
     %'accA_x_NF_b1_pow',[0,8]
    'accA_y_NF_b1_pow',[0 8]
     %'accA_z_NF_b1_pow',[0,8]
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
	
xLims = [0,100];
xLab = 'Flow rate reduction targets (%)';
tit = 'Control intervensions';

plot_nha_power_and_flow_per_intervention(Data.IV2.Features.Absolute,...
	Data.IV2.Feature_Statistics.Descriptive_Absolute.med, ...
	Data.IV2.Feature_Statistics.Results, ...
	nhaVars, levelLabels, 'QRedTarget_pst', xLims, xLab, tit,'control');

clear nhaVars levelLabels xLims xLab tit

%% ROC curves for each diameter states and each speed
% Overlaid component curves 
% [no of states]x[no of speeds] panels 
% Figure 6 in submission for ASAIO

classifiers = {
 	%'accA_y_b1_pow', 'NHA_{\ity}';
	%'accA_x_b1_pow', 'NHA_{\itx}';
	%'accA_z_b1_pow', 'NHA_{\itz}';
 	'accA_y_NF_b1_pow', 'NHA_{\ity}';
 	'accA_x_NF_b1_pow', 'NHA_{\itx}';
 	'accA_z_NF_b1_pow', 'NHA_{\itz}';
	%'P_LVAD_drop',   '\itP\rm_{LVAD}';
	%'accA_xynorm_NF_b1_pow', 'NHA_{\it|xy|}';
	};
tit = 'ROC Curves for Pendulating Mass States';

close all
plot_roc_curve_matrix_per_intervention_and_speed(...
	Data.IV2.Feature_Statistics.ROC, classifiers, tit);

clear classfiers tit

%% ROC curves for each diameter states and each component
% Overlaid speed curves 
% [no of states]x[3] panels

classifiers = {
 	'accA_x_NF_b1_pow', 'NHA_{\itx}';
 	'accA_y_NF_b1_pow', 'NHA_{\ity}';
 	'accA_z_NF_b1_pow', 'NHA_{\itz}';
	};
tit = 'ROC Curves for Pendulating Mass States by Spatial Component';

plot_roc_curve_matrix_per_intervention_and_xyz(...
	Data.IV2.Feature_Statistics.ROC, classifiers, tit);

clear classfiers tit

%% ROC curves for each pooled diameter states
% Overlaid each speed
% 1x[no of states] panels

classifiers = {
 	'accA_y_NF_b1_pow';
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
plot_roc_curves_per_pooled_interventions(Data.IV2.Features.Absolute_Pooled_ROC, ...
	classifiers, predStates, tit);

clear classfiers predStates tit

%% Absolute NHA versus flow scatter
% Intervention type grouping by color
% 2x2 panels, one panel per speed

vars = {
%    'accA_y_NF_stdev',[0.01,0.19]
    'accA_x_NF_b1_pow',[0,0.018]
    'accA_y_NF_b1_pow',[0,0.018]
   };

close all
plot_scatter_acc_against_Q(Data.IV2.Features.Absolute, vars);
plot_scatter_relative_acc_and_Q_LVAD_against_Q(Data.IV2.Features.Absolute, ...
	Data.IV2.Features.Relative, vars);

clear vars 

%% Individual effects aginst categories of Q red. and balloon occlusions
% [no of speeds]x1panels
% Includes all diameters (incl. intermediate levels) 
% D is numerical (unevenly distributed)

vars = {
	'accA_y_NF_b1_pow', [0,0.011]
	%'accA_y_NF_b1_mpf', [90,210]
	};

close all
plot_individual_effects_against_interv_cats_per_speed(vars, ...
	{'Absolute','Medians'}, Data.IV2.Features.Absolute, ...
	'Absolute median effects');

clear vars

%% Aggregated effects aginst categories of Q red. and balloon occlusions
%  [no of speeds]x1panels
% Includes all diameters (incl. intermediate levels) 
% D is numerical (unevenly distributed)

vars = {
	'accA_y_NF_b1_pow', [0,0.011]
	%'accA_y_NF_b1_mpf', [90,210]
	};

close all
G = Data.IV2.Feature_Statistics.Descriptive.Absolute;
plot_aggregate_effects_against_interv_cats_per_speed(...
	G.med, vars,{'median','absolute'}, G.q1, G.q3);

clear G vars
