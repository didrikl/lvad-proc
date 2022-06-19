close all
Config =  get_processing_config_defaults_G1;

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
xLab = 'diameter and areal obstruction';
yLab = 'experiments and pump speed';
xlims = [2,12.7];
speeds = [2200,2400,2600];
%mapScale = [0.6 3];

T = F;
vars = {
    'accA_xyz_NF_HP_b1_pow_norm',           'NHA (dB)',               []
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

T = lookup_plot_data(speeds, sequences, T, Config.balLevDiamLims);


nhaVars = contains(T.Properties.VariableNames,'acc') & ...
	not(contains(T.Properties.VariableNames,'_var'));
T{:,nhaVars}=db(T{:,nhaVars});

h_fig = gobjects(size(vars,2)+2,1);

 for i=1:size(vars,1)
 	h_fig(i) = plot_heat_map(T, vars{i,1}, vars{i,2}, xlims, xLab, yLab, Config);
 	if not(isnan(vars{i,3})), caxis(vars{i,3}); end
	%caxis(mapScale);
 end

h_fig(end-1) = plot_balloon_levels(T, 'balDiam_xRay_mean', xlims, xLab, yLab, Config);
%h_fig(end) = plot_balloon_levels(T, 'balHeight_xRay_mean', xlims, xLab, yLab, Config);

% save_path = fullfile(Config.fig_path,'Heatmaps');
% for i=1:numel(h_fig)-2, save_figure(h_fig(i), save_path, vars{i,1}, 300); end
% save_figure(h_fig(end-1), save_path, 'Balloon levels - Diameter', 300)
% save_figure(h_fig(end), save_path, 'Balloon levels - Height', 300)


function h_fig = plot_balloon_levels(T, var, xlims, xLab, yLab, Config)
	h_fig = figure('Position',[100,100,1000,650]);
	h_ax = init_axes;
	for i=1:numel(Config.balLevDiamLims)
		inds = T.balLev_xRay==i;
		scatter(T.(var)(inds),T.seqList(inds),50,'filled','o');
	end
	make_plot_adjustments(h_ax, xlims, xLab, yLab, Config);
end

function h_fig = plot_heat_map(T, plotVar, colMapLab, xlims, xLab, yLab, Config)
	
	h_fig = figure('Position',[100,100,1100,800]);
	h_ax = init_axes;
	load('ScientificColormaps')
	
	plotVar = check_table_var_input(T,plotVar);
	blVar = [plotVar,'_BL'];
	
	if contains(plotVar,'best')
		T.(plotVar)(T.balLev=='1') = T.(blVar)(T.balLev=='1');
	end
	
	scatter(T.balDiam_xRay_mean, T.seqList, 200, T.(plotVar), 'filled');
	colMap = scientificColormaps.batlow50;
	%colMap = flip(scientificColormaps.roma);
	%colMap = scientificColormaps.roma;
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
	seqList = strrep(seqList,'Seq06 2200','Seq06 2200**');
	seqList = strrep(seqList,' ','    ');
	seqList = strrep(seqList,'Seq','# ');
	seqList = categorical(seqList);
end

function h_ax = init_axes
	h_ax = axes(...
		'NextPlot','add',...
		'Clipping','off');
	h_ax.LineWidth = 1.5;
	h_ax.FontSize = 12;
	h_ax.Position(1) = 0.155;
	h_ax.Position(2) = 0.15;
	h_ax.Position(3) = 0.72;
	h_ax.Position(4) = 0.80;
end

function add_grid_lines(levLims, xlims)
	xline(levLims,...
		'LineStyle',':',...
		'Alpha',0.6,...
		'LineWidth',1.25,...
		'HandleVisibility','off')
	plot([xlims(1)-1.45,xlims(2)],repmat(3.5:3:24,2,1),...
		'Color',[0 0 0 0.45],...
		'LineStyle',':',...
		'Clipping','off',...
		'LineWidth',1,...
		'HandleVisibility','off')
end

function hAx = customize_axis(levLims, hAx, Config)
	levLims(1) = 2.33;
	xticks([levLims])
	obstr_diam = string(compose(' %3.1f',string(hAx.XTick)))';
	obstr_pst = strtrim(string(num2str(100*(hAx.XTick'.^2)/(Config.inletInnerDiamLVAD^2),2.0)));
	obstr_pst = "\newline"+""+compose('%3s',obstr_pst);
	if hAx.XTick(end) == Config.inletInnerDiamLVAD
		obstr_pst(end) = '\newline100';
	end
	obstr_pst(1) = "\newline 3";
	hAx.XTickLabel = obstr_diam+obstr_pst+"%";
	hAx.TickDir = 'out';
	hAx.YTickLabel(contains(hAx.YTickLabel,'2600')) = {'2600'};
	noteInd = contains(hAx.YTickLabel,'2200**');
	hAx.YTickLabel(contains(hAx.YTickLabel,'2200**')) = {'2200**'};
	hAx.YTickLabel(contains(hAx.YTickLabel,'2200') & not(noteInd)) = {'2200'};

end

function add_axis_labels(hAx, xLab, yLab, specs)
	hXLab = xlabel(xLab,specs.supXLab{:},'FontSize',hAx.FontSize+2);
	hXLab.Position(2) = hXLab.Position(2)-36;
	hYLab = ylabel(yLab,specs.supXLab{:},'FontSize',hAx.FontSize+2);
	hYLab.Position(1) = hYLab.Position(1)-5;
end

function T2 = lookup_plot_data(speeds, sequences, T1, levLims)
	T2 = table;
	seqList = {};
	for j=1:numel(speeds)
		for i=1:numel(sequences)
			
			F2 = T1(T1.pumpSpeed==speeds(j) & T1.balLev~='-' & T1.seq==sequences{i},:);
			F2 = add_revised_balloon_levels(F2, levLims);
			if isempty(F2) 
				% Make a empty dummy row
				F2{end+1,20} = missing;
			end
			T2 = merge_table_blocks(T2,F2);
			
			inputs_i = split(sequences{i},'_');
			seqID = [inputs_i{1}(1:3),sprintf('%02d',str2double(inputs_i{1}(4:end)))];
			ID = [seqID,' ',num2str(speeds(j))];
			seqList = [seqList;cellstr(repmat(ID,height(F2),1))];
			
		end
	end
	change_seq_list_to_ylabel(seqList)
	T2.seqList = change_seq_list_to_ylabel(seqList);
	
end

function add_annotations(hAx)
	% remark down in the corner (to be removed later?)
	annotation('textbox',[0.020 0.04 0.26 0.033],...
		'String',{'*air in balloon (not excluded)','**Excluded, d/t large flow variation'},...
		'FontSize',9,...
		'EdgeColor','none');
	
	% extra labels to the two axis units
	annotation('textbox',[0.905 0.049 0.05829 0.1],...
		'String',{'(mm)'},...
		'FontSize',hAx.FontSize,...
		'FontName','Arial',...
		'FitBoxToText','off',...
		'EdgeColor','none');

	annotation('textbox',[0.105,0.96,0.05829,0.031916],...
		'String','(RPM)',...
	    'FontSize',hAx.FontSize,...
		'FontName','Arial',...
		'FitBoxToText','off',...
		'EdgeColor','none');

	title(hAx, {'Balloon obstruction levels'})
end

function hAx = make_plot_adjustments(hAx, xlims, xLab, yLab, Config)
	specs = get_plot_specs;
	levLims = Config.balLevDiamLims;
	xlim(xlims)
	add_grid_lines(levLims, xlims);
	add_axis_labels(hAx, xLab, yLab, specs);
	hAx = customize_axis(levLims, hAx, Config);
	add_annotations(hAx);
end