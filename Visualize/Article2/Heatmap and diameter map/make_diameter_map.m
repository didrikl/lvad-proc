function hFig = make_diameter_map(T, Config)
	
	xLab = 'diameter and areal obstruction';
	yLab = 'experiments and pump speed';
	xlims = [2,12.7];
	
	T = lookup_plot_data(T, Config.balLevDiamLims);

	hFig = plot_balloon_levels(T, 'balDiam_xRay_mean', xlims, xLab, yLab, Config);
	%hFig(2) = plot_balloon_levels(T, 'balHeight_xRay_mean', xlims, xLab, yLab, Config);
end

function h_fig = plot_balloon_levels(T, var, xlims, xLab, yLab, Config)
	h_fig = figure('Position',[100,100,1000,650]);
	h_ax = init_axes;
	for i=1:numel(Config.balLevDiamLims)
		inds = T.balLev_xRay==i;
		scatter(T.(var)(inds),T.seqList(inds),50,'filled','o');
	end
	make_plot_adjustments(h_ax, xlims, xLab, yLab, Config);
end