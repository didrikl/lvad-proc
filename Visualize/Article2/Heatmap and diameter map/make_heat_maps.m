function hFig = make_heat_maps(T, vars, sequences, Config)
	
	xLab = 'diameter and areal obstruction';
	yLab = 'experiments and pump speed';
	xlims = [2,12.7];
	
	T = lookup_plot_data(T, Config.balLevDiamLims, sequences);

	% convert from g^2/kHz to g^2/Hz and into dB scale
	nhaVars = contains(T.Properties.VariableNames,'acc') & ...
		not(contains(T.Properties.VariableNames,'_var'));
	T{:,nhaVars} = T{:,nhaVars}/1000;
	T{:,nhaVars}=db(T{:,nhaVars});

	hFig = gobjects(size(vars,2)+2,1);

	for i=1:size(vars,1)
		hFig(i) = plot_heat_map(T, vars{i,1}, vars{i,2}, xlims, xLab, yLab, Config);
		if not(isnan(vars{i,3})), caxis(vars{i,3}); end
		%caxis(mapScale);
	end

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










