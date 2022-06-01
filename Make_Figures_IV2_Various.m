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
