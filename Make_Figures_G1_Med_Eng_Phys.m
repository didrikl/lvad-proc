Config =  get_processing_config_defaults_G1;
cd 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Visualize\Article2'
Make_Part_Plot_Data

%% Diameter map

h_fig = make_diameter_map(F, Config);


%% Bar chart - Relative

vars = {
	'Q_mean',                     '\itQ'
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

make_baseline_deviation_bar_chart_figure(G_rel, 'median', vars, cats);


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

make_part_figure_2panels_with_nha(T1, T2, map1, map2, Notes, var, partSpec(i,:), Config.fs, yLims1, yLims2, yTicks2, widthFactor);


%% NHA, Q and P - 3X5 panels

var = 'accA_xyz_NF_HP_b1_pow_norm';
yLims = {
	[-0.85 0.3]
	[-0.85 0.3]+0.25
	[-0.75 5.5]
	};

plot_nha_power_and_flow_3x5panels(F_rel, G_rel.med, [], var, yLims);
