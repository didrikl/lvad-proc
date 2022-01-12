function h_yLab = add_linked_map_hz_yyaxis(h_sub, yyLab, rpm, order)
	orderTicks = h_sub(1).YTick;
	yyaxis(h_sub(1),'right')
	h_sub(1).YAxis(2).Color = h_sub(1).YAxis(1).Color;
	h_yLab = ylabel(yyLab);
	linkprop(h_sub(1).YAxis, 'Limits');
	yticks(0:1:max(order));
	set(h_sub(1),'YTickLabel',strsplit(num2str(orderTicks*(rpm/60),'%2.0f ')));
end