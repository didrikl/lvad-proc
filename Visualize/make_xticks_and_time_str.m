function xLabels = make_xticks_and_time_str(hSub, segs, rot)
	if nargin<3, rot=45; end
	
	xt = [0;segs.all.endDur];
	xticks(hSub(end),xt);
	xLabels = hSub(end).XTick;
	xLabels = seconds(xLabels);
	xLabels.Format = 'mm:ss';
	xLabels = string(xLabels);
	xLabels(not(ismember(xt,segs.main.EndDur))) = '';
	xticklabels(hSub(end), xLabels);
	xtickangle(hSub(end), rot);
	xticklabels(hSub(1:end-1),{})
	xt = xticks(hSub(end));
	xticks(hSub(1:end-1),xt);