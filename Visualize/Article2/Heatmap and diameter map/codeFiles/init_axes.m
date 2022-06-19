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