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
var = 'accA_xyz_NF_HP_b2_pow_norm';
yLims = {
	[-0.85 0.3]
	[-0.85 0.3]+0.25
	[-0.75 5.505]
	};

%close all
plot_nha_power_and_flow_3x5panels(F_rel, G_rel.med, [], var, yLims);


%% ROC curves for each specific obstruction level states
% [no of levels]x1 panels

classifiersToUse = {
	'accA_xyz_NF_HP_b1_pow_norm', 'NHA'
%	'accA_xyz_NF_HP_b2_pow_norm', 'NHA)'
	'P_LVAD_change',              '\itP\rm_{LVAD}'
%	'P_LVAD_mean',              '\itP\rm_{LVAD}';
	};

%close all
plot_roc_per_balloon_level(Data.G1.Feature_Statistics.ROC, classifiersToUse);

%

%% ROC curves for each specific obstruction level states
% [no of levels]x1 panels

classifiersToUse = {
	'accA_xyz_NF_HP_b2_pow_norm', 'NHA)'
	'P_LVAD_change',              '\itP\rm_{LVAD}'
	};

close all
plot_roc_per_balloon_level(Data.G1.Feature_Statistics.ROC, classifiersToUse);



%% ROC curves, pooled for obstruction levels/pooled for RPM

classifiersToUse = {
	'accA_xyz_NF_HP_b1_pow_norm', 'norm(NHA_{x,y,z})'
	%'accA_best_NF_HP_b1_pow_per_speed', 'NHA_{best, per speed}'
	%'accA_best_NF_HP_b2_pow', 'NHA_{best, per interv.}';
	%'accA_x_NF_HP_b2_pow', 'NHA_{\itx}';
	%'accA_y_NF_HP_b2_pow', 'NHA_{\ity}';
	%'accA_z_NF_HP_b2_pow', 'NHA_{\itz}';
	'P_LVAD_change',   '\itP\rm_{LVAD}';
	};

close all
legTit = 'ROC curves - Pooled balloon levels - Pooled RPM';
h(1) = plot_roc_curve_matrix_G1(Data.G1.Feature_Statistics.ROC_Pooled_RPM, classifiersToUse, legTit);
legTit = 'ROC curves - Pooled balloon levels';
h(2) = plot_roc_curve_matrix_G1(Data.G1.Feature_Statistics.ROC_Pooled, classifiersToUse, legTit);

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



%%

var = 'accA_xyz_NF_HP_b1_pow_norm';
%close all

figHeight = 265;
figWidth = 340;
pWidth = 120;
pHeight = 200;
gap = 58;
ptSize = 21;

spec = get_plot_specs;
hFig2 = figure(...
	'Name','Flow (at corresponding baseline) versus NHA elevation',...
	'Position',[300,300,figWidth,figHeight],...
	'PaperUnits','centimeters',...
	'PaperSize',[9,9*(figHeight/figWidth)+0.1]...
	);

hSub(1) = subplot(1,2,1, spec.subPlt{:}, 'FontSize',9, 'LineWidth',1);
hSub(2) = subplot(1,2,2, spec.subPlt{:}, 'FontSize',9, 'LineWidth',1);

set(hSub(1:2), ...
	'Units','pixels',...
	...'YLim',[-1,10.8], ...
    'XLim',[1.15,4.15], ...
    'XLim',[2.05,4.25], ...
    'FontSize',9, ...
	'LineWidth',1, ...
	'XTick',1:0.5:4, ...
	'YTick',-2:2:11, ...
	'XTickLabelRotation',0, ...
	'YTickLabelRotation',0, ...
	'GridColor',[0 0 0], ...
	'GridAlpha',0.22, ...
	'GridLineStyle',':', ...
	'XGrid','on', ...
	'YGrid','on', ...
	'TickDir','out',...
	'TickLength',[0.025,0] ...
	);
%hSub(2).YAxis.Visible = 'off';
%set(hSub,'Units','pixels');
yStart = 50;
xStart = 41;
hSub(1).Position = [xStart, yStart, pWidth, pHeight];
hSub(2).Position = [xStart + pWidth + gap, yStart, pWidth, pHeight];

inds = ismember(F.balLev_xRay_mean,[0]) & F.interventionType~='Reversal';
inds = contains(string(F.idLabel),'Nom') & F.interventionType~='Reversal';
% inds = F.interventionType=='Control';
F2 = F;
F2 = F2(inds,:);
F2( F2.(var) == max(F2.(var)),:) = [];
x = F2.Q_mean;
y = F2.(var);
x = x(not(isnan(y)));
y = y(not(isnan(y)));
t = table(x,y);
t = sortrows(t,'x');
scatter(hSub(1), t.x, t.y, ptSize,'filled', 'MarkerFaceAlpha',0.35);
hold on

[R,p,uB,lB] = corrcoef(t.x, t.y);
pol = polyfit(t.x, t.y, 1);
t.f = polyval(pol, t.x);
hSub(1).ColorOrderIndex = hSub(1).ColorOrderIndex-1;
plot(hSub(1), t.x, t.f, 'HandleVisibility','off', 'LineWidth',2);
title(hSub(1), 'Baseline', 'FontWeight','normal');
hTxt(1) = text(hSub(1),2.3, 7, {['\itr\rm = ',num2str(R(1,2),'%2.2f')]});
fprintf('Correlation, baseline: %2.2f (p=%1.4f)\n',R(1,2),p(1,2))

inds = ismember(F.balLev_xRay_mean,[2,3,4]) & F.interventionType~='Reversal';
x = F.Q_mean(inds)-F_del.Q_mean(inds); % in view of corresponding BL flow
y = F_rel.(var)(inds);
x = x(not(isnan(y)));
y = y(not(isnan(y)));
t = table(x,y);
t = sortrows(t,'x');
scatter(hSub(2), t.x, t.y, ptSize,'filled', 'MarkerFaceAlpha',0.35);
hold on
[R,p,uB,lB] = corrcoef(t.x, t.y);
pol = polyfit(t.x, t.y, 1);
t.f = polyval(pol, t.x);
hSub(2).ColorOrderIndex = hSub(2).ColorOrderIndex-1;
plot(t.x, t.f, 'HandleVisibility','off', 'LineWidth',2);
title(hSub(2), 'Level 2-4', 'FontWeight','normal');
hTxt(1) = text(hSub(2),2.2, 7, {['\itr\rm = ',num2str(R(1,2),'%2.2f')]});

ylim(hSub(1),[0,6]);
ylim(hSub(2),[-1,11]);

fprintf('Correlation, level 2-4: %2.2f (p=%1.4f)\n',R(1,2),p(1,2))

%hXLab = suplabel('baseline flow rate (L min^{-1})','x');
xlabel(hSub(1),'flow (L min^{-1})');
xlabel(hSub(2),'flow (L min^{-1})');
hYLab(1) = ylabel(hSub(1),'NHA','Units','pixels');
hYLab(2) = ylabel(hSub(2),'relative NHA elevation','Units','pixels');
%hYLab.Position(1) = hYLab.Position(1)-6;
hXLab.Units = 'pixels';
hXLab.Position(2) = hXLab.Position(2)+4;


%%

var = 'accA_xyz_NF_HP_b1_pow_norm';
%close all
clear hSub

figHeight = 260;
figWidth = 340;
pWidth = 90;
pHeight = 195;
gap = 8;
levs = [2,3,4];
ptSize = 21;

spec = get_plot_specs;
hFig = figure(...
	'Name','Flow (actual) versus NHA elevation',...
	'Position',[300,300,figWidth,figHeight],...
	'PaperUnits','centimeters',...
	'PaperSize',[9,9*(figHeight/figWidth)+0.1]...
	);

hSub(1) = subplot(1,4,1, spec.subPlt{:}, 'FontSize',8.5, 'LineWidth',1);
hSub(2) = subplot(1,4,2, spec.subPlt{:}, 'FontSize',8.5, 'LineWidth',1);
hSub(3) = subplot(1,4,3, spec.subPlt{:}, 'FontSize',8.5, 'LineWidth',1);

set(hSub, ...
	'Units','pixels',...
	'YLim',[-1,11], ...
    'XLim',[1.15,4.15], ...
    'XLim',[2.10,4.25], ...
    'FontSize',9, ...
	'LineWidth',1, ...
	'XTick',1:0.5:4, ...
	'YTick',-2:2:10, ...
	'XTickLabelRotation',0, ...
	'YTickLabelRotation',0, ...
	'Color',[.96 .96 .96], ...
	'GridColor',[0 0 0], ...
	'GridAlpha',0.22, ...
	'GridColor',[1 1 1], ...
	'GridAlpha',1, ...
	'GridLineStyle',':', ...
	'GridLineStyle','-', ...
	'XGrid','on', ...
	'YGrid','on', ...
	'TickDir','out',...
	'TickLength',[0.025,0] ...
	);
%   xlim(hSub(1),[1.9,4.2]);
%   xlim(hSub(2),[1.6,3.8]);
%   xlim(hSub(3),[0.9,3.2]);
adjust_panel_positions(hSub, pWidth, pHeight, gap)
hSub(2).YAxis.Visible = 'off';
hSub(3).YAxis.Visible = 'off';
yTickLabels = 100*yticks(hSub(1))+"%";
yticklabels(hSub(1),yTickLabels)
hYAx = make_ax_offset(hSub, hFig);

fprintf('\n')
for i=1:numel(levs)
	inds = F.balLev_xRay_mean==levs(i) & F.interventionType~='Reversal';
	x = F.Q_mean(inds)+abs(F_del.Q_mean(inds)); % in view of corresponding BL flow
	%x = F.Q_mean(inds); % in view of actual flow
	y = F_rel.(var)(inds);
	x = x(not(isnan(y)));
	y = y(not(isnan(y)));
	t = table(x,y);
	t = sortrows(t,'x');
	scatter(hSub(i),t.x,t.y,ptSize,'filled',...
		'MarkerFaceColor',[0.07,0.39,0.50], ...
		'MarkerFaceAlpha',0.4);
	hold on
 	[R,p,uB,lB] = corrcoef(t.x, t.y);
	pol = polyfit(t.x, t.y, 1);
	t.f = polyval(pol, t.x);
	fprintf('Correlation, level %d: %2.2f (p=%1.3f)\n',levs(i),R(1,2),p(1,2))
	
	plot(hSub(i),t.x,t.f,'HandleVisibility','off',...
		'LineWidth',2, ...
		'Color',[0.07,0.39,0.50]);
	hTxt(i) = text(hSub(i),2.2, 9.5, {['\itr\rm = ',num2str(R(1,2),'%2.2f')]});
	title(hSub(i), ['Level ',num2str(levs(1))],'FontWeight','normal');
end


hXLab = suplabel('baseline flow rate (L min^{-1})','x');
hXLab.Position(2) = hXLab.Position(2)+7;
	
%hTxt(1).Position = [2.623181818181817,0.88963926752031,-1.4e-14];
hTxt(1).Position = [2.316054421768706,1.642972600853641,0];
%hTxt(2).Position = [2.29,1.523342971224012,0];
hTxt(2).Position = [2.086,2.94,0];
%hTxt(3).Position = [1.594495412844037,3.315438524025884,1.4e-14];
hTxt(3).Position = [2.172470823191661,4.335068153655516,0];

function hYAx = make_ax_offset(hSub, hFig)
	hYAx = copyobj(hSub(1), hFig);
	hSub(1).YAxis.Color = 'none';
	set(hYAx, 'box','off', 'Color','none', 'YGrid','off', 'XGrid','off', 'Units','pixels')
	hYAx.Position(1) = hYAx.Position(1)-8;
	set(hYAx(1).XAxis, 'Color','none')
end

function adjust_panel_positions(hSub, pWidth, pHeight, gap)
	set(hSub,'Units','pixels');
	yStart = 50;
	xStart = 54;
	hSub(1).Position = [xStart, yStart, pWidth, pHeight];
	hSub(2).Position = [xStart + pWidth + gap, yStart, pWidth, pHeight];
	hSub(3).Position = [xStart + 2*pWidth + 2*gap, yStart, pWidth, pHeight];
end
