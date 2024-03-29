function segs = get_segment_info(T, durVar)
	
	if nargin<2, durVar = ''; end

	segs = struct;
	segs.all = table;
	segs.main = table;
	
	% Find start and end indices for each segment
	segs.all.endInd = [find(diff(T.noteRow));height(T)];
	segs.all.startInd = [1;segs.all.endInd(1:end-1)+2];
	if segs.all.startInd(end)>height(T)
		warning('Last segment in part is empty')
		segs.all.startInd(end) = segs.all.endInd(end);
	end
	segs.all.midInd = round((segs.all.endInd-segs.all.startInd)./2);
	
	% Protocol values/info
	segs.all.event = T.event(segs.all.startInd);
	segs.all.analysis_id = T.analysis_id(segs.all.startInd);
	segs.all.bl_id = T.bl_id(segs.all.startInd);
	segs.all.pumpSpeed = T.pumpSpeed(segs.all.startInd);
	segs.all.intervType = T.intervType(segs.all.startInd);
	
	% Segment type
	segs.all.isTransitional = ismember(T.intervType(segs.all.startInd),'Transitional');
	segs.all.isEcho = contains(lower(string(T.event(segs.all.startInd))),'echo');
	segs.all.isWashout = ismember(lower(string(T.event(segs.all.startInd))),'washout');
	segs.all.isSteadyState = ismember(T.intervType(segs.all.startInd),'Steady-state') & not(segs.all.isEcho);
	segs.all.isBaseline = ismember(T.intervType(segs.all.startInd),'Baseline') & not(segs.all.isEcho);
	
	% Parse additional model-dependent column info
	segs = fill_obstruction_info(segs, T);
	segs = fill_clamp_info(segs, T);
	segs = fill_injection_info(segs, T);
	
	segs.all.isNominal = segs.all.isSteadyState & not(segs.all.isClamp) & not(segs.all.isBalloon);
	
	% Handle injection info: QRedTarget was used to decide is echo should be
	% done, but should for plotting/analysis be 0
	injInd = find(segs.all.isInjection);
	injIndp1 = injInd+1;
	injIndp1 = injIndp1(injIndp1<=numel(segs.all.isInjection));
	segs.all.QRedTarget_pst(segs.all.isInjection) = '-';
	segs.all.QRedTarget_pst(injIndp1) = '-';
	segs.all.isClamp(segs.all.isInjection) = false;
	segs.all.isClamp(injIndp1) = false;
		
	% Find boundaries in cases of several Notes were made under same segment
	segs.all.isIntraSeg = ...
		[false;diff(segs.all.isTransitional)==0] & ...
		([false;diff(double(segs.all.event))==0] & not(segs.all.event~='-')) & ...
		[false;diff(segs.all.isEcho)==0] | ...
		([false;diff(segs.all.isWashout)==0] & segs.all.isWashout);
	segs.all.isIntraSeg(end) = false;

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

function segs = fill_obstruction_info(segs, T)
	try
		segs.all.balLev_xRay = T.balLev_xRay(segs.all.startInd);
		segs.all.arealObstr_xRay_pst = T.arealObstr_xRay_pst(segs.all.startInd);
		segs.all.isBalloon = double(string(T.balLev_xRay(segs.all.startInd)))>0;
	catch
		% X-ray measurement not done
		segs.all.balLev_xRay = T.balLev(segs.all.startInd);
		segs.all.isBalloon = double(string(T.balLev(segs.all.startInd)))>0;
		%segs.all.arealObstr_xRay_pst = T.arealObstr_pst(segs.all.startInd);
	end

function segs = fill_clamp_info(segs, T)
	segs.all.QRedTarget_pst = T.QRedTarget_pst(segs.all.startInd);
	segs.all.isClamp = double(string(T.QRedTarget_pst(segs.all.startInd)))>0;
	
function segs = fill_injection_info(segs, T)
	segs.all.isInjection = false(height(segs.all),1);
	segs.all.embVol = nan(height(segs.all),1);
	segs.all.embType = string(nan(height(segs.all),1));
	if ismember(T.Properties.VariableNames, 'embVol')
		segs.all.isInjection = not(ismissing(T.embVol(segs.all.startInd))) & ...
			not(ismember(T.embVol(segs.all.startInd),'-'));	
		segs.all.embVol = T.embVol(segs.all.startInd);
		segs.all.embType = T.embType(segs.all.startInd);
	end
