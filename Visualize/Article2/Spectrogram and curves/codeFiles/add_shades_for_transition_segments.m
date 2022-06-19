function add_shades_for_transition_segments(hSub, segs, yLims1, yLims2)
	
	shadeColor = [1 1 1];
	echoShadeColor = [.9 .9 .9];
	
	add_shades(hSub(1), segs, segs.all.isEcho, echoShadeColor, 0.18, [yLims1(1) yLims1(2)])
	add_shades(hSub(1), segs, segs.all.isTransitional, shadeColor, 0.40, [yLims1(1) yLims1(2)])
	for i=2:numel(hSub)
		add_shades(hSub(i), segs, segs.all.isEcho, echoShadeColor, 0.18, [yLims2(1) yLims2(2)])
		add_shades(hSub(i), segs, segs.all.isTransitional, shadeColor, 0.52, [yLims2(1) yLims2(2)])
	end

