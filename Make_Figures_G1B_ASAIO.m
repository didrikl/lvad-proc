Config =  get_processing_config_defaults_G1B;
cd 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Visualize\Article3'
Make_Part_Plot_Data

%%

accVar = {
	'accB_x'
    %'accB_y'
    %'accB_z'
    %'accB_norm'
 	};

%Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config);

close all
%set(0,'DefaultFigureVisible','off');

% make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
%  	@make_part_figure_2panels, 'Spectrogram and curves - accB')

make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
 	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - accB')


for i=1:size(partSpec,1)
			
			for j=1:nVars
				
				Notes = Data.(seq).Notes;
				T = Data.(seq).Plot_Data.T{i};				
				map = Data.(seq).Plot_Data.RPM_Order_Map{i};

				hFig = fnc(T, Notes, map, accVar{j}, Config, partSpec(i,:));
				
				savePath = fullfile(Config.data_basePath, Config.seq_subdir, ...
					Config.proc_plot_subdir, subDir);
	
				save_figure(hFig, fullfile(savePath,'png'), hFig.Name, 'png', 300);
				%save_figure(hFig, fullfile(savePath,'svg'), hFig.Name, 'svg');
				
			end
			%close all



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
