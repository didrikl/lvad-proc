function hAx = make_plot_adjustments(hAx, xlims, xLab, yLab, Config)
	specs = get_plot_specs;
	levLims = Config.balLevDiamLims;
	xlim(xlims)
	add_grid_lines(levLims, xlims);
	add_axis_labels(hAx, xLab, yLab, specs);
	hAx = customize_axis(levLims, hAx, Config);
	add_annotations(hAx);
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

function add_axis_labels(hAx, xLab, yLab, specs)
	hXLab = xlabel(xLab,specs.supXLab{:},'FontSize',hAx.FontSize+2);
	hXLab.Position(2) = hXLab.Position(2)-36;
	hYLab = ylabel(yLab,specs.supXLab{:},'FontSize',hAx.FontSize+2);
	hYLab.Position(1) = hYLab.Position(1)-5;
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