function h_yLab = add_subYLabels_to_plot_NHA(h_ax,yLab)
	nRows = numel(yLab);
	for i=1:nRows
		h_yLab(i) = ylabel(h_ax(i),yLab{i},'Units','normalized');
	end
	