%% Figure 5 - Data assessment example
% Spectrograms and curve plots

tit = 'Spectrogram';
S = Data.IV2.Seq10.S;
var = 'accA_y_NF';
rpm = 2800;

IDs1 = {
		'02.0 #1'
		'52.1'
		'52.2'
		'52.3'
		'52.4'
		};
	IDs2 = {
		'02.0 #1'
		'22.3'
		'32.3'
		'42.4'
		};

make_spectrogram_figure_IV2(S, tit, var, rpm, Config.fs, IDs1, IDs2);


%% Figure 6 - Effects of flow reductions by clamps
% NHA, Q and P for afterload and prelod side by side 

nhaVars = {
	'accA_y_NF_b1_pow',[0 8]
	};
 
% Level categories plotted together
levelLabels = {
	'Afterload', 'Outflow clamp'
	'Preload',   'Inflow clamp'
	};
	
xLims = [0,100];
xLab = 'Flow rate reduction targets (%)';
tit = 'Control intervensions';

plot_nha_power_and_flow_per_intervention(Data.IV2.Features.Absolute,...
	Data.IV2.Feature_Statistics.Descriptive_Absolute.med, ...
	Data.IV2.Feature_Statistics.Results, ...
	nhaVars, levelLabels, 'QRedTarget_pst', xLims, xLab, tit,'control');


%% Figure 7 - Effects of inflow obstructions
% NHA, Q and P, per catheter type

nhaVars = {
      'accA_y_NF_b1_pow',[0,8]
     };
levelLabels = {
	'Inflated, 4.73 mm', 'Catheter 1'
	'Inflated, 6.60 mm', 'Catheter 2'
	'Inflated, 8.52 mm', 'Catheter 3'
	'Inflated, 11 mm',   'Catheter 4'
	};

xLims = [0,100];
tit = 'Pendulating Mass in Inlet Conduit';
xLab = 'Areal inflow obstruction (%)';

plot_nha_power_and_flow_per_intervention(Data.IV2.Features.Absolute,...
	Data.IV2.Feature_Statistics.Descriptive_Absolute.med, ...
	Data.IV2.Feature_Statistics.Results, ...
	nhaVars, levelLabels, 'arealObstr_pst', xLims, xLab, tit, 'effect');


%% Figure 8 - Accelerometer ROC curves
% Overlaid component-wise ROC curves 

classifiers = {
 	'accA_y_NF_b1_pow', 'NHA_{\ity}';
 	'accA_x_NF_b1_pow', 'NHA_{\itx}';
 	'accA_z_NF_b1_pow', 'NHA_{\itz}';
	};

tit = 'ROC Curves for Pendulating Mass States';

plot_roc_curve_matrix_per_intervention_and_speed(...
	Data.IV2.Feature_Statistics.ROC, classifiers, tit);
