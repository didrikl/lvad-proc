function [hYLab, hAx] = add_linked_map_hz_yyaxis(hAx, yyLab, rpm)
	orderTicks = hAx.YTick;
	yyaxis(hAx,'right')
	hAx.YAxis(2).Color = hAx.YAxis(1).Color;
	linkprop(hAx.YAxis, 'Limits');
	yticks(orderTicks);
	rpm = double(string(rpm));
	yyTicks = orderTicks*(rpm(1)/60);
	yyTickLabels = string(compose('%1.0f',yyTicks));
 	for i=2:numel(rpm)
		yyTicks = orderTicks*(rpm(i)/60);
		yyTickLabels = yyTickLabels+"|"+string(compose('%1.0f',yyTicks));
	end
	yticklabels(hAx,yyTickLabels);

	if not(isempty(yyLab))
		hYLab = ylabel(hAx,yyLab,"Units","points");
	else
		hYLab = [];
	end