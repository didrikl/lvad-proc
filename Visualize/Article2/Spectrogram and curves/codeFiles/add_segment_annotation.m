function add_segment_annotation(hAx, segs, whichSegs, labStr, labRot, color)
	if nargin<5, labRot = 0; end
	if nargin<6, color = [0 0 0]; end

	if labRot==0
		horAlign = 'center';
		vertAlign = 'top';%'middle';%'top';
	elseif labRot==90 
		horAlign = 'right'; 
		vertAlign = 'top';
	else
		horAlign = 'center'; 
		vertAlign = 'middle';
	end
	
	yLims = ylim(hAx);
	whichSegs = find(whichSegs);
	durs = segs.all.startDur(whichSegs);
		
	for i=1:numel(durs)
		if labRot==90
			x = segs.all.startDur(whichSegs(i));
			y = yLims(2);%+0.05*diff(yLims);
		else	
			x = segs.main.MidDur(...
				find(segs.main.StartDur==durs(i),1,'first'));
			y = yLims(2);%+0.05*diff(yLims);
		end
		if not(isempty(x))
			text(hAx, x, y, labStr, ...
				'Color',color,...
				'HorizontalAlignment',horAlign,...
				'VerticalAlignment',vertAlign,...
				'FontName','Arial Narrow',...
				'FontSize',8,...
				'Rotation',labRot)
		end
	end
