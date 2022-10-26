Config =  get_processing_config_defaults_G1;
cd 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Visualize\Article2'
Make_Part_Plot_Data_G1

%% Diameter map

h_fig = make_diameter_map(F, Config);

%% Spectrograms and curves - Continious - Relative - 2 panel rows
 
%Make_Part_Plot_Data_G1

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


%% NHA, Q and P - 3X5 panels

var = 'accA_xyz_NF_HP_b1_pow_norm';
yLims = {
	[-0.85 0.3]
	[-0.85 0.3]+0.25
	[-0.75 5.5]
	};

plot_nha_power_and_flow_3x5panels(F_rel, G_rel.med, [], var, yLims);

%% Relative NHA versus BL flow scatter

var = 'accA_xyz_NF_HP_b1_pow_norm';
plot_nha_versus_flow_scatter_3panels(var, F, F_rel, F_del)

%% ROC curves for each specific obstruction level states

classifiersToUse = {
	'accA_xyz_NF_HP_b1_pow_norm', 'NHA'
	'P_LVAD_change',              '\itP\rm_{LVAD}'
	};
classifiersToUseForPooled = {
	'accA_xyz_NF_HP_b1_pow_norm', 'NHA'
	};
plot_roc_per_balloon_level(Data.G1.Feature_Statistics.ROC, ...
	Data.G1.Feature_Statistics.ROC_Pooled_RPM, classifiersToUse, classifiersToUseForPooled);
