function plot_rpm_order_map(h_ax, colorRange, colorMap, time, order, map, yLim, segEnds)
	
	axes(h_ax)
	imagesc(time,order,map);

	caxis(colorRange);
	colormap(colorMap)
	
	h = gca;
	set(h,'ydir','normal');
	yticks(0:1:max(order));
	xticks([0,segEnds'])
	h.YLim = yLim;
	xlim([0,segEnds(end)])
end