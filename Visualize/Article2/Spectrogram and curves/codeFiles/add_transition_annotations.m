function add_transition_annotations(hSub, T, segs, y)
	
	if nargin<4
		yLims = ylim(hSub);
		y = yLims(2);
	end

	events = unique(segs.all.event);
	for i=1:numel(events)
		if ismember(events(i),'-'), continue; end
		isEvent = ismember(T.event(segs.all.startInd),events(i));
		isEvent = isEvent & not(segs.all.isEcho);
		add_segment_annotation(hSub, segs, isEvent, lower(string(events(i))), 90, [.45 .45 .45], y)
	end
