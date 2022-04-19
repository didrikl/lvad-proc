function add_shades(hAx, segs, segsForShade, color, alpha, ylims)
	
	if nargin<4, ylims = ylim; end
	
	pStartDur = segs.all.startDur(segsForShade);
	pEndDur = segs.all.endDur(segsForShade);
	
	cornerX = [pStartDur pEndDur pEndDur pStartDur];
	cornerY = [min(ylims)*[1 1] max(ylims)*[1 1]];
	for i=1:size(cornerX,1)
		patch(hAx, cornerX(i,:), cornerY, color,...
			'FaceAlpha',alpha,...
			'EdgeColor','none',...
			'HandleVisibility','off');
	end
