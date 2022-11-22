Config =  get_processing_config_defaults_G1B;
cd 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Visualize\Article3'

%%

% save_figure(hFig, fullfile(Config.fig_path,'Accelerometer comparisons'), hFig.Name, 'pdf');
%save_figure(hFig, fullfile(Config.fig_path,'Accelerometer comparisons'), hFig.Name, 'png', 300);
save_figure(hFig, fullfile(Config.fig_path,'Bland-Altmann'), hFig.Name, 'png', 600);

%% Bland-Altmann

seq = 'Seq6';
varA = 'accA_z';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%% Bland-Altmann

seq = 'Seq8';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%% Bland-Altmann

seq = 'Seq11';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%% Bland-Altmann

seq = 'Seq12';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%% Bland-Altmann

seq = 'Seq13';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%%

seq = 'Seq6';
varA = 'accA_z';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%%

seq = 'Seq7';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
% hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%%

seq = 'Seq8';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);


%%

seq = 'Seq11';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);
				

%%

seq = 'Seq12';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);
				
%%

seq = 'Seq13';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;

[~, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%[~, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%%

[hFig, hAx] = plot_roc_for_3h(ROC);


%% Spectrograms and curves - Continious - Relative - 2 panel rows
 
var = 'accB_x_NF_HP';
seq = 'Seq8'; 

%Make_Part_Plot_Data_G1B % remove line...
Data.G1 = make_part_plot_data_per_sequence(Data.G1, ['G1B_',seq], var, Config);
Notes = Data.G1B.(seq).Notes;
partSpec = Data.G1B.(seq).Config.partSpec;
yLims1 = [0.85, 5.5];
yLims2 = [-90,190];
yTicks2 = -75:25:190;
widthFactor = 70*60;

% Clamping
i=2;
map1 = Data.G1B.(seq).Plot_Data.RPM_Order_Map{i};
T1 = Data.G1B.(seq).Plot_Data.T{i};
cutInd = find(T1.noteRow==39,1,'first');
T1(cutInd:end,:) = [];

% Balloon, 2400 RPM; 
i=3;
map2 = Data.G1B.(seq).Plot_Data.RPM_Order_Map{i};
T2 = Data.G1B.(seq).Plot_Data.T{i};
cutInd = find(T2.noteRow==68,1,'first');
T2(cutInd:end,:) = [];

close all
make_part_figure_2panels_with_nha_G1B(T1, T2, map1, map2, Notes, var, partSpec(i,:), Config.fs, yLims1, yLims2, yTicks2, widthFactor);


%% NHA, Q and P - 3X5 panels

var = 'accB_x_NF_HP_b3_pow';
yLims = {
	[-0.85 0.3]
	[-0.85 0.3]+0.25
	[-0.75 3]
	};

plot_nha_power_and_flow_3x5panels_G1B(F_rel, G_rel.med, [], var, yLims);


%% ROC curves for each specific obstruction level states

classifiersToUse = {
	'accB_x_NF_HP_b3_pow', 'NHA'
	'P_LVAD_change',          '\itP\rm_{LVAD}'
	};
classifiersToUseForPooled = {
	'accB_x_NF_HP_b3_pow', 'NHA'
	};
plot_roc_per_balloon_level(Data.G1B.Feature_Statistics.ROC, Data.G1B.Feature_Statistics.ROC_Pooled_RPM, classifiersToUse, classifiersToUseForPooled);
