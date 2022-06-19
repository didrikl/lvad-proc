function hPlt = plot_rpm_order_map(hAx, colRange, colMap, t, order, map, yLim)
	
	hPlt = imagesc(hAx, t, order, map);

	colormap(hAx, colMap)
	caxis(hAx, colRange);

	set(hAx,'ydir','normal');
	yticks(hAx, 0:1:max(order));
	hAx.YLim = yLim;
	xlim(hAx, t([1,end]))
