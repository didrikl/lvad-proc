function format_tick_labels(h_ax,h_xax, h_yax)
	
	nRows = numel(h_yax);
	nCols = numel(h_xax);
	
	set([h_ax(:);h_xax(:);h_yax(:)],'XTick',0:0.2:1);
	set([h_ax(:);h_xax(:);h_yax(:)],'YTick',0:0.2:1);
	
	for j=1:nCols
		h_xax(j).XTickLabel(2:end-1) = strip(h_xax(j).XTickLabel(2:end-1),'0');
	end
	for i=1:nRows
		h_yax(i).YTickLabel(2:end-1) = strip(h_yax(i).YTickLabel(2:end-1),'0');
	end
end