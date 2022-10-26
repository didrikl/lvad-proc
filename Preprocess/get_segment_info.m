function segs = get_segment_info(T, durVar)
	
	if nargin<2, durVar = ''; end

	segs = struct;
	segs.all = table;
	segs.main = table;
	
	segs.all.endInd = [find(diff(T.noteRow));height(T)];
	segs.all.startInd = [1;segs.all.endInd(1:end-1)+2];
	segs.all.midInd = round((segs.all.endInd-segs.all.startInd)./2);
	
	segs.all.event = T.event(segs.all.startInd);
	segs.all.pumpSpeed = T.pumpSpeed(segs.all.startInd);
	segs.all.intervType = T.intervType(segs.all.startInd);
	
	segs.all.isTransitional = ismember(T.intervType(segs.all.startInd),'Transitional');
	segs.all.isEcho = contains(lower(string(T.event(segs.all.startInd))),'echo');
	segs.all.isWashout = ismember(lower(string(T.event(segs.all.startInd))),'washout');
	segs.all.isSteadyState = ismember(T.intervType(segs.all.startInd),'Steady-state') & not(segs.all.isEcho);
	segs.all.isBaseline = ismember(T.intervType(segs.all.startInd),'Baseline') & not(segs.all.isEcho);
	
	% Parse additional model-dependent column info
	% TODO: Refactor to separate function
	try
		segs.all.balLev_xRay = T.balLev_xRay(segs.all.startInd);
		segs.all.arealObstr_xRay_pst = T.arealObstr_xRay_pst(segs.all.startInd);
	catch
		% X-ray measurement not done
		segs.all.balLev_xRay = T.balLev(segs.all.startInd);
		%segs.all.arealObstr_xRay_pst = T.arealObstr_pst(segs.all.startInd);
	end
	try

		segs.all.QRedTarget_pst = T.QRedTarget_pst(segs.all.startInd);
		segs.all.isClamp = double(string(T.QRedTarget_pst(segs.all.startInd)))>0;
		segs.all.isBalloon = double(string(T.balLev(segs.all.startInd)))>0;
		segs.all.isNominal = segs.all.isSteadyState & not(segs.all.isClamp) & not(segs.all.isBalloon);
		segs.all.isInjection = double(string(T.embVol(segs.all.startInd)))>0;
		
		% Handle injection info: QRedTarget was used to decide is echo should be
		% done, but should for plotting/analysis be 0
		injInd = find(segs.all.isInjection);
		injIndp1 = injInd+1;
		injIndp1 = injIndp1(injIndp1<=numel(segs.all.isInjection));
		segs.all.QRedTarget_pst(segs.all.isInjection) = '-';
		segs.all.QRedTarget_pst(injIndp1) = '-';
		segs.all.isClamp(segs.all.isInjection) = false;
		segs.all.isClamp(injIndp1) = false;
		segs.all.embVol = T.embVol(segs.all.startInd);
		segs.all.embType = T.embType(segs.all.startInd);
		
 	catch err
 		disp(err)
 	end

	% Find boundaries in cases of several Notes were made under same segment
	segs.all.isIntraSeg = ...
		[false;diff(segs.all.isTransitional)==0] & ...
		([false;diff(double(segs.all.event))==0] & not(segs.all.event~='-')) & ...
		[false;diff(segs.all.isEcho)==0] | ...
		([false;diff(segs.all.isWashout)==0] & segs.all.isWashout);
	mainSegRows = unique([1;find(not(segs.all.isIntraSeg))]);%;numel(not(segs.all.isIntraSeg))]);
	segs.main = segs.all(mainSegRows,:);
 	segs.main.StartInd = segs.all.startInd(mainSegRows);

	% TODO: Check possible bug!
 	segs.main.EndInd = [segs.main.StartInd(2:end);height(T)];
 	
	% Add duration info
	if durVar
		segs.all.startDur = round(T.(durVar)(segs.all.startInd));
		segs.all.endDur = round(T.(durVar)(segs.all.endInd));
		segs.all.midDur = segs.all.startDur+(segs.all.endDur-segs.all.startDur)./2;
		segs.main.StartDur = segs.all.startDur(mainSegRows);
		segs.main.EndDur = [segs.main.StartDur(2:end);segs.all.endDur(end)];
		segs.main.MidDur = segs.main.StartDur+(segs.main.EndDur-segs.main.StartDur)./2;
	end