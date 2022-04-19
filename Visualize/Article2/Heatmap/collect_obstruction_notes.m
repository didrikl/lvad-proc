%close all
Config =  get_processing_config_defaults_G1;

inputs = {
	'Seq3' % (pilot)
	'Seq6'
	'Seq7'
	'Seq8'
	'Seq11'
	%'Seq11_SwapYZ'
	'Seq12'
	'Seq13'
	'Seq14'
	%'Seq14_SwapYZ'
	};
xLab = 'diameter and areal obstruction';
yLab = 'experiments';% and pump speed (RPM)';
xlims = [2,12.7];
speeds = [2200,2400,2600];

T = F;
vars = {
%    'accA_best_NF_HP_b2_pow_per_speed', 'NHA (dB)',               [-70,-35]
    'accA_best_NF_HP_b2_pow',           'NHA (dB)',               []
%    'accA_x_NF_HP_b2_pow',              'NHA_{\itx\rm} (dB)',     [-70,-35]
%    'accA_y_NF_HP_b2_pow',              'NHA_{\ity\rm} (dB)',     [-70,-35]
%    'accA_z_NF_HP_b2_pow',              'NHA_{\itz\rm} (dB)',     [-70,-35]
%    'accA_norm_NF_HP_b2_pow',           'NHA_{\it|xyz|\rm} (dB)', [-70,-35]
%     'Q_CO_pst',                         '\itQ\rm-\itCO\rm ratio', [0 100]
%'Q_mean', 'Q', [0 5]
	 };

% T = F_del;
% vars = {
%  	'P_LVAD_mean',  '\itP\rm_{LVAD} (W)',      [-2,0.5]
% 	'Q_mean',       '\itQ\rm (L/min)',         []
%    	'Q_LVAD_mean',  '\itQ\rm_{LVAD} (W)',      []
% %  	'pGraft_mean',  '\itp\rm_{graft} (mmHg)'  
% %  	'SvO2_mean'     'SVO_2 (%)'
% %  	'p_minArt_mean' '\itp\rm_{art,min} (mmHg)'
% % 	'p_maxArt_mean' '\itp\rm_{art,max} (mmHg)'
% % 	'CO_mean'       'CO (L/min)'
% % 	'CVP_mean'      'CVP (mmHg)'
% 	};

T = lookup_plot_data(speeds, inputs, T, Config.balLevDiamLims);

h_fig = gobjects(size(vars,2)+2,1);

 for i=1:size(vars,1)
 	h_fig(i) = plot_heat_map(T, vars{i,1}, vars{i,2}, xlims, xLab, yLab, Config);
 	if not(isnan(vars{i,3})), caxis(vars{i,3}); end
 end

%h_fig(end-1) = plot_balloon_levels(T, 'balDiam_xRay_mean', xlims, xLab, yLab, Config);
%h_fig(end) = plot_balloon_levels(T, 'balHeight_xRay_mean', xlims, xLab, yLab, Config);

% save_path = fullfile(Config.fig_path,'Heatmaps');
% for i=1:numel(h_fig)-2, save_figure(h_fig(i), save_path, vars{i,1}, 300); end
% save_figure(h_fig(end-1), save_path, 'Balloon levels - Diameter', 300)
% save_figure(h_fig(end), save_path, 'Balloon levels - Height', 300)


function h_fig = plot_balloon_levels(T, var, xlims, xLab, yLab, Config)
	h_fig = figure('Position',[100,100,1000,800]);
	h_ax = init_axes;
	for i=1:numel(Config.balLevDiamLims)
		inds = T.balLev_xRay==i;
		scatter(T.(var)(inds),T.seqList(inds),40,'filled','o');
	end
	make_plot_adjustments(h_ax, xlims, xLab, yLab, Config);
end

function h_fig = plot_heat_map(T, plotVar, colMapLab, xlims, xLab, yLab, Config)
	h_fig = figure('Position',[100,100,1100,800]);
	h_ax = init_axes;
	load('ScientificColormaps')
	
	blVar = [plotVar,'_BL'];
	if contains(plotVar,'best')
		T.(plotVar)(T.balLev=='1') = T.(blVar)(T.balLev=='1');
	end
	scatter(T.balDiam_xRay_mean, T.seqList, 375, T.(plotVar), 'filled');
	%colMap = scientificColormaps.batlow50;
	%colMap = flip(scientificColormaps.roma);
	colMap = scientificColormaps.roma;
	colormap(colMap);
	colorbar(h_ax,...
		'Position',[0.92 0.20 0.018 0.2],...
		'TickLength',0.03,...
		'LineWidth',1,...
		'FontSize',15,...
		'FontName','Arial',...
		'Box','off');
	
	annotation('textbox',[0.91 0.44 0.0971 0.0643],...
		'FitBoxToText','off',...
		'EdgeColor','none',...
		'FontSize',15,...
		'FontName','Arial',...
		'String',colMapLab);

	make_plot_adjustments(h_ax, xlims, xLab, yLab, Config);
end

function seqList = change_seq_list_to_ylabel(seqList)
	seqList = strrep(seqList,'Seq12 2400','Seq12 2400*');
	seqList = strrep(seqList,' ','  ');
	seqList = strrep(seqList,'Seq','# ');
	seqList = categorical(seqList);
end

function h_ax = init_axes
	h_ax = axes(...
		'NextPlot','add',...
		'Clipping','off');
	h_ax.LineWidth = 1.5;
	h_ax.FontSize = 15;
	h_ax.Position(1) = 0.155;
	h_ax.Position(2) = 0.15;
	h_ax.Position(3) = 0.72;
	h_ax.Position(4) = 0.80;
end

function add_grid_lines(levLims, xlims)
	xline(levLims,...
		'LineStyle',':',...
		'Alpha',0.5,...
		'LineWidth',1.1,...
		'HandleVisibility','off')
	plot([xlims(1)-1,xlims(2)],repmat(3.5:3:24,2,1),...
		'Color',[0 0 0 0.5],...
		'LineStyle',':',...
		'Clipping','off',...
		'LineWidth',1.1,...
		'HandleVisibility','off')
end

function h_ax = customize_axis(levLims, h_ax, Config)
	xticks(levLims)
	obstr_diam = string(compose('%3.1f',string(h_ax.XTick)))';
	obstr_pst = strtrim(string(num2str(100*(h_ax.XTick'.^2)/(Config.inletInnerDiamLVAD^2),2.0)));
	obstr_pst = "\newline"+""+compose('%3s',obstr_pst);
	if h_ax.XTick(end) == Config.inletInnerDiamLVAD
		obstr_pst(end) = '\newline100';
	end
	h_ax.XTickLabel = obstr_diam+obstr_pst;

	h_ax.YTickLabel(contains(h_ax.YTickLabel,'2600')) = {'2600'};
	h_ax.YTickLabel(contains(h_ax.YTickLabel,'2200')) = {'2200'};
end

function add_axis_labels(xLab, yLab, specs)
	hXLab = xlabel(xLab,specs.supXLab{:});
	hXLab.Position(2) = hXLab.Position(2)-36;
	hYLab = ylabel(yLab,specs.supXLab{:});
	hYLab.Position(1) = hYLab.Position(1)-5;
end

function T2 = lookup_plot_data(speeds, inputs, T1, levLims)
	T2 = table;
	seqList = {};
	for j=1:numel(speeds)
		for i=1:numel(inputs)
			
			F2 = T1(T1.pumpSpeed==speeds(j) & T1.balLev~='-' & T1.seq==inputs{i},:);
			F2 = add_revised_balloon_levels(F2, levLims);
			T2 = merge_table_blocks(T2,F2);
			
			inputs_i = split(inputs{i},'_');
			seqID = [inputs_i{1}(1:3),sprintf('%02d',str2double(inputs_i{1}(4:end)))];
			ID = [seqID,' ',num2str(speeds(j))];
			seqList = [seqList;cellstr(repmat(ID,height(F2),1))];
			
		end
	end
	T2.seqList = change_seq_list_to_ylabel(seqList);
	
	nhaVars = contains(T2.Properties.VariableNames,'acc') & ...
		not(contains(T2.Properties.VariableNames,'_var'));
	T2{:,nhaVars}=db(T2{:,nhaVars});
end

function add_annotations
	% remark down in the corner (to be removed later?)
	annotation('textbox',[0.030 0.0492 0.136 0.033],...
		'String','*air in balloon',...
		'FontSize',12,...
		'EdgeColor','none');
	
	% extra labels to the two axis units
	annotation('textbox',[0.921 0.053125 0.0582900000000002 0.090875],...
		'String',{'(mm)','(%)'},...
		'FontSize',15,...
		'FontName','Arial',...
		'FitBoxToText','off',...
		'EdgeColor','none');
end

function h_ax = make_plot_adjustments(h_ax, xlims, xLab, yLab, Config)
	specs = get_plot_specs;
	levLims = Config.balLevDiamLims;
	xlim(xlims)
	add_grid_lines(levLims, xlims);
	add_axis_labels(xLab, yLab, specs);
	h_ax = customize_axis(levLims, h_ax, Config);
	add_annotations;
end