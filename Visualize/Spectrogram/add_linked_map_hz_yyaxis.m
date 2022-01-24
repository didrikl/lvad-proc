function [hYLab, hSub] = add_linked_map_hz_yyaxis(hSub, yyLab, rpm, order)
	orderTicks = hSub.YTick;
	yyaxis(hSub,'right')
	hSub.YAxis(2).Color = hSub.YAxis(1).Color;
	linkprop(hSub.YAxis, 'Limits');
	yticks(0:1:max(order));
	set(hSub,'YTickLabel',strsplit(num2str(orderTicks*(rpm/60),'%2.0f ')));
	hYLab = ylabel(hSub,yyLab);
end