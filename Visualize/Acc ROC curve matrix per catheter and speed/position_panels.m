function [gap, h_ax] = position_panels(panelLength, h_ax)
	gap = 25;
	rowStart = 74;
	colStart = 66;
	[nRows,nCols] = size(h_ax);
	for i=1:nRows
		rowPos = (nRows-i)*(panelLength+gap)+rowStart;
		for j=1:nCols
			colPos = (j-1)*(panelLength+gap)+colStart;
			h_ax(i,j).Position = [colPos,rowPos,panelLength,panelLength];
		end
	end
end