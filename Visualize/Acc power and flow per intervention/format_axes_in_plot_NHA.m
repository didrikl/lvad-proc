function h_ax = format_axes_in_plot_NHA(h_ax,axSpec,axTickSpec)
	set(h_ax,axSpec{:});
	
	nRows = size(h_ax,1);
	nCols = size(h_ax,2);
	
	set(h_ax(:,1:nCols),'YColor',[1,1,1])
	set(h_ax(1:nRows,:),'XColor',[1,1,1])
	
	for i=1:nRows
		set(h_ax(i,1).YAxis,axTickSpec{:})
	end
	for j=1:nCols
		set(h_ax(nRows,j).XAxis,axTickSpec{:})
	end
	for j=1:nCols
		set(h_ax(nRows,j).YAxis,axTickSpec{:})
	end

	set(h_ax,'Box','on')
	set(h_ax,'XTickLabelRotation',0)
	set(h_ax,'YTickLabelRotation',0)
	set(h_ax,'Units','points')
	

		