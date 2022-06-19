function hImg = plot_rpm_order_map(h_ax, colorRange, colorMap, time, order, map, yLim, segEnds)
	
	axes(h_ax)
	hImg = imagesc(time,order,map);

	colormap(colorMap)
	caxis(colorRange);

	h = gca;
	set(h,'ydir','normal');
	yticks(0:1:max(order));
	xticks([0,segEnds'])
	h.YLim = yLim;
	xlim([0,segEnds(end)])