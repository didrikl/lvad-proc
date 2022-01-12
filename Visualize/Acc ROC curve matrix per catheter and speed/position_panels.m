function h_ax = position_panels(panelLength,h_ax,gap_x,gap_y)
	
	if nargin==3, gap_y = gap_x; end

	rowStart = 85;
	colStart = 85;
	[nRows,nCols] = size(h_ax);
	for i=1:nRows
		rowPos = (nRows-i)*(panelLength+gap_y)+rowStart;
		for j=1:nCols
			colPos = (j-1)*(panelLength+gap_x)+colStart;
			h_ax(i,j).Position = [colPos,rowPos,panelLength,panelLength];
		end
	end
end