function format_axes(hAx,spec)
	
	set(hAx,'Box','off')
	set(hAx,'XTickLabelRotation',0)
	set(hAx,'YTickLabelRotation',0)
	set(hAx,'Units','points')
	set(hAx,spec.ax{:});

	nRows = size(hAx,1);
	nCols = size(hAx,2);

	for i=1:nRows
		set(hAx(i,1).YAxis,spec.axTick{:},'TickLength',[0.018,0])
	end
	for j=1:nCols
		set(hAx(nRows,j).XAxis,spec.axTick{:},'TickLength',[0.018,0])
	end
	for j=1:nCols
		set(hAx(nRows,j).YAxis,spec.axTick{:},'TickLength',[0.018,0])
	end

	set(hAx(1,:),'XColor','none')
	set(hAx(1,2).YAxis(1),'Color','none')
	set(hAx(2,2).YAxis(1),'Color','none')

	axes(hAx(1,1))
	yyaxis right
	set(hAx(1,1).YAxis(2),'Color','none')
	yyaxis left

	axes(hAx(2,1))
	yyaxis right
	set(hAx(2,1).YAxis(2),'Color','none')
	yyaxis left