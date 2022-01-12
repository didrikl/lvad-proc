function h_sub = position_panels(h_sub,height,width,gap)
	
	row2Start = 85;
	row1Start = row2Start+height+gap;
	col1Start = 85;
	col2Start = col1Start+width+gap;
	
	h_sub(1,1).Position = [row1Start,col1Start,width,height];
	h_sub(1,2).Position = [row1Start,col2Start,width,height];
	h_sub(2,1).Position = [row2Start,col1Start,width,height];
	h_sub(2,2).Position = [row2Start,col2Start,width,height];

% 	rowStart = 85;
% 	colStart = 85;
% 	[nRows,nCols] = size(h_ax);
% 	for i=1:nRows
% 		rowPos = (nRows-i)*(panelLength+gap)+rowStart;
% 		for j=1:nCols
% 			colPos = (j-1)*(panelLength+gap)+colStart;
% 			h_ax(i,j).Position = [colPos,rowPos,2*panelLength,panelLength];
% 		end
% 	end
end