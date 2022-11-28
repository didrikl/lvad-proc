%% Spectrograms and curves - Continious - Relative - 2 panel rows
 
var = 'accB_x_NF';
seq = 'Seq8'; 

Data.G1B2 = make_part_plot_data_per_sequence(Data.G1B2, ['G1B2_',seq], var, Config);
Notes = Data.G1B2.(seq).Notes;
partSpec = Data.G1B2.(seq).Config.partSpec;
yLims1 = [0.85, 5.5];
yLims2 = [-90,190];
yTicks2 = -75:25:190;
widthFactor = 70*60;

% Clamping
i=2;
map1 = Data.G1B2.(seq).Plot_Data.RPM_Order_Map{i};
T1 = Data.G1B2.(seq).Plot_Data.T{i};
cutInd = find(T1.noteRow==39,1,'first');
T1(cutInd:end,:) = [];

% Balloon, 2400 RPM; 
i=3;
map2 = Data.G1B2.(seq).Plot_Data.RPM_Order_Map{i};
T2 = Data.G1B2.(seq).Plot_Data.T{i};
cutInd = find(T2.noteRow==68,1,'first');
T2(cutInd:end,:) = [];

close all
make_part_figure_2panels_with_nha(T1, T2, map1, map2, Notes, var, partSpec(i,:), Config.fs, yLims1, yLims2, yTicks2, widthFactor);

%% NHA, Q and P - 3X5 panels

var = 'accB_x_NF_b2_pow';
yLims = {
	[-0.85 0.3]
	[-0.85 0.3]+0.25
	[-0.75 3]
	};

plot_nha_power_and_flow_3x5panels_G1B(F_rel, G_rel.med, [], var, yLims);


%% ROC curves for each specific obstruction level states

classifiersToUse = {
	'accB_x_NF_b2_pow', 'NHA'
	'P_LVAD_change',    '\itP\rm_{LVAD}'
	};
classifiersToUseForPooled = {
	'accB_x_NF_b2_pow', 'NHA'
	};
plot_roc_per_balloon_level(Data.G1B2.Feature_Statistics.ROC, Data.G1B2.Feature_Statistics.ROC_Pooled_BL_RPM, classifiersToUse, classifiersToUseForPooled);
