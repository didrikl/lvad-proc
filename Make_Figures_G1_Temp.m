Config =  get_processing_config_defaults_G1;
cd 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Visualize\Article2'
Make_Part_Plot_Data

%% Diameter map

close all
h_fig = make_diameter_map(F, Config);

%% Heatmaps

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

vars = {
    'accA_xyz_NF_HP_b1_pow_norm', 'NHA (dB)',                []
    %'Q_CO_pst',                   '\itQ\rm-\itCO\rm ratio', [0 100]
    %'Q_mean',                     'Q', [0 5]
	 };

close all
hFig = make_heat_maps(F, vars, sequences, Config);

% vars = {
%  	'P_LVAD_mean',  '\itP\rm_{LVAD} (W)',      [-2,0.5]
% 	'Q_mean',       '\itQ\rm (L/min)',         []
% 	'Q_LVAD_mean',  '\itQ\rm_{LVAD} (W)',      []
%  	'pGraft_mean',  '\itp\rm_{graft} (mmHg)'  
%  	'SvO2_mean'     'SVO_2 (%)'
%  	'p_minArt_mean' '\itp\rm_{art,min} (mmHg)'
% 	'p_maxArt_mean' '\itp\rm_{art,max} (mmHg)'
% 	'CO_mean'       'CO (L/min)'
% 	'CVP_mean'      'CVP (mmHg)'
% 	};

%close all
%hFig = make_heat_maps(F_rel, vars, sequences, Config);


%% Boxplot, pooled

%close all
saveFig = false;

vars = {
  	'accA_xyz_NF_HP_b2_pow_norm', 'NHA_{norm(\itx,y,z\rm)} (dB)', [-.5,2.5]
% 	'P_LVAD_mean', '{\itP}_{LVAD} (W)', [-.5,2.5]
	'P_LVAD_change', '{\itP}_{LVAD} (W)', [-.5,2.5]
 	'Q_mean' '{\itQ} (L/min)', [-.5,2.5]
%	'Q_drop' '{\itQ} (L/min)', [-.5,2.5]
%	'pGraft_mean' '{\itp}_{graft} (mmHg)', []
	};

% TODO: Expand support for list of different groups and group labels in the
%       functions make_intervention_groups and make_level_sting_for_save_name
levs = {
	'2'
	'3'
	'4'
	};

bpAsdB = true;
intervention_boxplot_by_color_per_rpm(F, levs, vars, bpAsdB, saveFig, Config);
intervention_boxplot(F, levs, vars, bpAsdB, saveFig, Config);

%bpAsdB = false;
% intervention_boxplot_by_color_per_rpm(F_rel, levs, vars, bpAsdB, saveFig, Config);
% intervention_boxplot(F_rel, levs, vars, bpAsdB, saveFig, Config);


%% Bar chart - Relative

vars = {
	'Q_mean',                     '\itQ'
	%'Q_LVAD_mean',                '\itQ\rm_{LVAD}'
	'P_LVAD_mean',                '\itP\rm_{LVAD}'
	'accA_xyz_NF_HP_b1_pow_norm', 'NHA'
	};
cats = {
     'Clamp, 2400, 25%', '1'
     'Clamp, 2400, 50%', '2'
     'Clamp, 2400, 75%', '3'
     'Balloon, 2400, Lev1', '40%' 
     'Balloon, 2400, Lev2', '55%'
     'Balloon, 2400, Lev3', '70%'
     'Balloon, 2400, Lev4', '80%' 
     'Balloon, 2400, Lev5', '90%' 
     };

close all
make_baseline_deviation_bar_chart_figure(G_rel, 'median', vars, cats);


%% Spectrograms and curves - Continious - Relative - 2 panel rows
 
var = 'accA_y_NF_HP';
 
seq = 'Seq12'; 
Notes = Data.G1.(seq).Notes;
partSpec = Data.G1.(seq).Config.partSpec;

yLims1 = [0.8, 5.5];
yLims2 = [-90,140];
yTicks2 = -100:25:120;
widthFactor = 60*60;
	
% Clamping
i=8;
map1 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T1 = Data.G1.(seq).Plot_Data.T{i};
T1(1:0.9*60*750,:) = [];
cutInd = find(T1.noteRow==104,1,'first');
%T1(cutInd:end,:) = [];
T1(cutInd+2*60*650:end,:) = [];

% Balloon, 2400 RPM; 
% NB with air in balloon at 2400 RPM
i=4;
map2 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T2 = Data.G1.(seq).Plot_Data.T{i};
cutInd = find(T2.noteRow==63);
T2(cutInd(end)-20000:end,:) = [];

close all
make_part_figure_2panels_with_nha(T1, T2, map1, map2, Notes, var, partSpec(i,:), Config.fs, yLims1, yLims2, yTicks2, widthFactor);


%% Spectrograms and curves - Continious - Relative - 2 panel rows
 
var = 'accA_x_NF_HP';
 
seq = 'Seq8'; 
Notes = Data.G1.(seq).Notes;
partSpec = Data.G1.(seq).Config.partSpec;

yLims1 = [0.85, 5.5];
yLims2 = [-90,190];
yTicks2 = -75:25:190;
widthFactor = 70*60;

% Clamping
i=2;
map1 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T1 = Data.G1.(seq).Plot_Data.T{i};
cutInd = find(T1.noteRow==39,1,'first');
T1(cutInd:end,:) = [];

% Balloon, 2400 RPM; 
i=3;
map2 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T2 = Data.G1.(seq).Plot_Data.T{i};
cutInd = find(T2.noteRow==68,1,'first');
T2(cutInd:end,:) = [];

close all
make_part_figure_2panels_with_nha(T1, T2, map1, map2, Notes, var, partSpec(i,:), Config.fs, yLims1, yLims2, yTicks2, widthFactor);

%% Spectrograms and curves - Continious - Relative - 2 panel rows
 
var = 'accA_y_NF_HP';
 
seq = 'Seq7'; 
Notes = Data.G1.(seq).Notes;
partSpec = Data.G1.(seq).Config.partSpec;

yLims1 = [0.85, 5.5];
yLims2 = [-90,200];
yTicks2 = -75:25:190;
widthFactor = 70*60;

% Clamping
i=5;
map1 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T1 = Data.G1.(seq).Plot_Data.T{i};
cutInd = find(T1.noteRow==109,1,'first');
T1(cutInd:end,:) = [];

% Balloon, 2600 RPM; 
i=4;
map2 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T2 = Data.G1.(seq).Plot_Data.T{i};
%T2(1:1*60*750,:) = [];
%cutInd = find(T2.noteRow==68,1,'first');
%T2(cutInd:end,:) = [];
%T2(cutInd+0.5*60*750:end,:) = [];

close all

make_part_figure_2panels_with_nha(T1, T2, map1, map2, Notes, var, partSpec(i,:), Config.fs, yLims1, yLims2, yTicks2, widthFactor);

%% Spectrograms and curves - Continious - Relative - 3 panel rows
 
var = 'accA_y_NF_HP';
 
seq = 'Seq13'; 
Notes = Data.G1.(seq).Notes;
partSpec = Data.G1.(seq).Config.partSpec;

yLims1 = [0.8, 5.5];
yLims2 = [-100,50];
yTicks2 = -75:25:40;
yLims3 = [-75,750];
yTicks3 = 0:100:600;
widthFactor = 85*60;

% Clamping
i=5;
map1 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T1 = Data.G1.(seq).Plot_Data.T{i};
% T1(1:0.9*60*750,:) = [];
cutInd = find(T1.noteRow==84,1,'first');
T1(cutInd:end,:) = [];

% Balloon, 2400 RPM; 
i=2;
map2 = Data.G1.(seq).Plot_Data.RPM_Order_Map{i};
T2 = Data.G1.(seq).Plot_Data.T{i};
% cutInds = find(T2.noteRow==41,1,'first');
% T2(cutInds+1*60*750:end,:) = [];
cutInd = find(T2.noteRow==39,1,'first');
T2(cutInd:end,:) = [];

close all
hFig = make_part_figure_3panels_with_nha(T1, T2, map1, map2, Notes, var, ...
	partSpec(i,:), Config.fs, yLims1, yLims2, yLims3, yTicks2, yTicks3, widthFactor);


%% Spectrograms and curves - Clipped to IDs - Absolute - 2 panel rows
% [2x2] panels, controls to the left and balloon interventions to the right

var = 'accA_y_NF_HP';
tit = 'Spectromgram and curves';
rpm = 2400;
IDs1 = {
	'2.0 #1'
	'2.1'
	'2.2'
	'2.3'
	'2.4'
	%'2.0 #2'
	};
IDs2 = {
	'3.0 #1'
	'3.1'
	'3.2'
	'3.3'
	'3.4'
	%'3.0 #2'
	};

close all
make_spectrogram_and_curve_figure_per_ids_G1(Data.G1.Seq13.S, tit, var, rpm, Config.fs, IDs1, IDs2);

%% NHA, Q and PLVAD - 3X2 panels

var = 'accA_xyz_NF_HP_b1_pow_norm';
yLims3 = [-0.75 6];

close all
G_rel_med = Data.G1.Feature_Statistics.Descriptive_Relative.med;
plot_nha_power_and_flow(F_rel, G_rel_med, [], var, yLims3);

%% NHA, Q and P - 3X5 panels

var = 'accA_xyz_NF_HP_b1_pow_norm';
%var = 'accA_xyz_NF_HP_b2_pow_norm';
yLims = {
	[-0.85 0.3]
	[-0.85 0.3]+0.25
	[-0.75 5.505]
	};

%close all
plot_nha_power_and_flow_3x5panels(F_rel, G_rel.med, [], var, yLims);


%% ROC curves for each diameter states and each speed
% Overlaid component curves
% [no of states]x[no of speeds] panels
% Figure 6 in submission for ASAIO

classifiers_to_plot = {
	%'accA_xyz_NF_HP_b1_pow_sum', 'sum(NHA_{x,y,z})'
	'accA_xyz_NF_HP_b1_pow_norm', 'norm(NHA_{x,y,z})'
	%'accA_best_NF_HP_b1_pow_per_speed', 'NHA_{best, per speed}'
	%   'accA_best_NF_HP_b2_pow', 'NHA_{best, per interv.}';
% 	'accA_x_NF_HP_b2_pow', 'NHA_{\itx}';
% 	'accA_y_NF_HP_b2_pow', 'NHA_{\ity}';
% 	'accA_z_NF_HP_b2_pow', 'NHA_{\itz}';
	'P_LVAD_change',   '\itP\rm_{LVAD}';
	};

close all
% legTit = 'ROC curves - Pooled balloon levels - Pooled RPM';
% h(1) = plot_roc_curve_matrix_G1(Data.G1.Feature_Statistics.ROC_Pooled_RPM, classifiers_to_plot, legTit);
% legTit = 'ROC curves - Pooled balloon levels';
% h(2) = plot_roc_curve_matrix_G1(Data.G1.Feature_Statistics.ROC_Pooled, classifiers_to_plot, legTit);
legTit = 'ROC curves - Concrete balloon levels';
h(3) = plot_roc_curve_matrix_G1(Data.G1.Feature_Statistics.ROC, classifiers_to_plot, legTit);

save_figure(h(1), fullfile(Config.fig_path,'ROC'), h(1).Name, 300)
save_figure(h(2), fullfile(Config.fig_path,'ROC'), h(2).Name, 300)
save_figure(h(3), fullfile(Config.fig_path,'ROC'), h(3).Name, 300)
%clear classfiers tit

%% ROC curves for each pooled diameter states
% % Overlaid each speed
% % 1x[no of states] panels
%
% classifiers = {
%  	'accA_y_NF_b1_pow';
% 	};
% predStates = {
% 	%'diam_4.30mm_or_more', '>= 4.30mm'
% 	'diam_4.73mm_or_more', '>= 4.73mm'
% 	%'diam_6.00mm_or_more', '>= 6.0mm'
% 	'diam_6.60mm_or_more', '>= 6.6mm'
% 	%'diam_7.30mm_or_more', '>= 7.30mm'
% 	'diam_8.52mm_or_more', '>= 8.52mm'
% 	%'diam_9mm_or_more', '>= 9mm'
% 	%'diam_10mm_or_more', '>= 10mm'
% 	'diam_11mm_or_more', '>= 11mm'
% 	%'diam_12mm', '= 12mm'
% 	};
% tit = 'ROC Curves for Pool of Pendulating Mass States';
%
% close all
% plot_roc_curves_per_pooled_interventions(Data.IV2.Features.Absolute_Pooled_ROC, ...
% 	classifiers, predStates, tit);
%
% clear classfiers predStates tit
%
%% Absolute NHA versus flow scatter
% Intervention type grouping by color
% 2x2 panels, one panel per speed

vars = {
    'accA_xyz_NF_HP_b1_pow_norm',[]
   };

close all
plot_scatter_acc_against_Q(Data.G1.Features.Absolute, vars);
plot_scatter_relative_acc_and_Q_LVAD_against_Q(Data.G1.Features.Absolute, ...
  	Data.G1.Features.Relative, vars);

