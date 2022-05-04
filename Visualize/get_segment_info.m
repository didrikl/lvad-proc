function segs = get_segment_info(T)
	
	segs = struct;
	segs.all = table;
	segs.all.endInd = [find(diff(T.noteRow));height(T)];
	segs.all.startInd = [1;segs.all.endInd(1:end-1)+2];
	segs.all.startDur = round(T.dur(segs.all.startInd));
	segs.all.endDur = round(T.dur(segs.all.endInd));
	segs.all.midDur = segs.all.startDur+(segs.all.endDur-segs.all.startDur)./2;
	segs.all.midInd = round((segs.all.endInd-segs.all.startInd)./2);
	
	segs.all.event = T.event(segs.all.startInd);
	segs.all.pumpSpeed = T.pumpSpeed(segs.all.startInd);
	segs.all.intervType = T.intervType(segs.all.startInd);
	segs.all.balLev_xRay = T.balLev_xRay(segs.all.startInd);
	segs.all.arealObstr_xRay_pst = T.arealObstr_xRay_pst(segs.all.startInd);
	segs.all.QRedTarget_pst = T.QRedTarget_pst(segs.all.startInd);
	
	segs.all.isTransitional = ismember(T.intervType(segs.all.startInd),'Transitional');
	segs.all.isEcho = contains(lower(string(T.event(segs.all.startInd))),'echo');
	segs.all.isSteadyState = ismember(T.intervType(segs.all.startInd),'Steady-state') & not(segs.all.isEcho);
	segs.all.isBaseline = ismember(T.intervType(segs.all.startInd),'Baseline') & not(segs.all.isEcho);
	segs.all.isAfterload = double(string(T.QRedTarget_pst(segs.all.startInd)))>0;
  	segs.all.isBalloon = double(string(T.balLev_xRay(segs.all.startInd)))>0;
	segs.all.isNominal = segs.all.isSteadyState & not(segs.all.isAfterload) & not(segs.all.isBalloon);

	segs.all.isIntraSeg = ...
		[false;diff(segs.all.isTransitional)==0] & ...
		([false;diff(double(segs.all.event))==0] | not(segs.all.event~='-')) & ...
		[false;diff(segs.all.isEcho)==0];

	segs.main = table;
	mainSegRows = unique([1;find(not(segs.all.isIntraSeg));numel(not(segs.all.isIntraSeg))]);
	segs.main = segs.all(mainSegRows,:);
 	segs.main.StartInd = segs.all.startInd(mainSegRows);
 	segs.main.StartDur = segs.all.startDur(mainSegRows);	
 	segs.main.EndInd = [segs.main.StartInd(2:end);segs.all.endInd(end)];
 	segs.main.EndDur = [segs.main.StartDur(2:end);segs.all.endDur(end)];
	segs.main.MidDur = segs.main.StartDur+(segs.main.EndDur-segs.main.StartDur)./2;
	