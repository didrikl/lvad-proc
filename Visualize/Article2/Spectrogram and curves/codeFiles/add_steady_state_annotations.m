function add_steady_state_annotations(hSub, segs)
	
	% RPM levels and segment baselines
	speeds = unique(segs.all.pumpSpeed);
	speeds = speeds(not(ismember(speeds,0)));
	if numel(speeds)>1
		for i=1:numel(speeds)
			
			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isNominal & not(ismember(lower(string(segs.all.event)),'hands on'));
			lab = ['\bf',num2str(speeds(i)),'\rm'];
			add_segment_annotation(hSub, segs, whichSegs, lab, 0)

			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isBaseline;
			lab = {['\bf',num2str(speeds(i)),'\rm'],'\bfBL\rm'};
			add_segment_annotation(hSub, segs, whichSegs, lab, 0)

		end
	else
		whichSegs = segs.all.isBaseline;
		lab = '\bfBL\rm';
		add_segment_annotation(hSub, segs, whichSegs, lab, 0)
	end

	% balloon levels
	try
		levs = unique(segs.all.balLev_xRay);
		for i=1:numel(levs)
			whichSegs = segs.all.balLev_xRay==levs(i) & segs.all.isBalloon & segs.all.isSteadyState;
			lab = "\bf"+"level "+string(levs(i));
			add_segment_annotation(hSub, segs, whichSegs, lab, 0)
		end
	catch
		levs = unique(segs.all.balLev);
		for i=1:numel(levs)
			whichSegs = segs.all.balLev==levs(i) & segs.all.isBalloon & segs.all.isSteadyState;
			lab = "\bf"+"level "+string(levs(i));
			add_segment_annotation(hSub, segs, whichSegs, lab, 0)
		end
	end
	
	% clamp levels
	try
		levs = unique(segs.all.QRedTarget_pst);
		for i=1:numel(levs)
			whichSegs = segs.all.QRedTarget_pst==levs(i) & segs.all.isSteadyState & segs.all.isClamp;
			lab = "\bf"+string(levs(i))+"%";
			add_segment_annotation(hSub, segs, whichSegs, lab, 0)
		end
	catch
	end

	add_segment_annotation(hSub, segs, segs.all.isEcho, 'echo', 90)
