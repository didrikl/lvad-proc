function add_steady_state_annotations(hSub, segs, y)
	
	if nargin<3
		yLims = ylim(hSub);
		y = yLims(2);
	end

	% RPM levels and segment baselines
	speeds = unique(segs.all.pumpSpeed);
	speeds = speeds(not(ismember(speeds,0)));
	if numel(speeds)>1
		for i=1:numel(speeds)
			
			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isNominal & not(ismember(lower(string(segs.all.event)),'hands on'));
			lab = ['',num2str(speeds(i)),'\rm'];
			add_segment_annotation(hSub, segs, whichSegs, lab, 0, [0 0 0], y)

			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isBaseline;
			lab = {['',num2str(speeds(i)),'\rm'],'BL\rm'};
			add_segment_annotation(hSub, segs, whichSegs, lab, 0, [0 0 0], y)

		end
	else
		whichSegs = segs.all.isBaseline;
		lab = 'BL\rm';
		add_segment_annotation(hSub, segs, whichSegs, lab, 0, [0 0 0], y)
	end

	% balloon levels
	try
		levs = unique(segs.all.balLev_xRay);
		for i=1:numel(levs)
			whichSegs = segs.all.balLev_xRay==levs(i) & segs.all.isBalloon & segs.all.isSteadyState;
			lab = ""+"level "+string(levs(i));
			add_segment_annotation(hSub, segs, whichSegs, lab, 0, [0 0 0], y)
		end
	catch
		levs = unique(segs.all.balLev);
		for i=1:numel(levs)
			whichSegs = segs.all.balLev==levs(i) & segs.all.isBalloon & segs.all.isSteadyState;
			lab = ""+"level "+string(levs(i));
			add_segment_annotation(hSub, segs, whichSegs, lab, 0, [0 0 0], y)
		end
	end
	
	% clamp levels
	try
		levs = unique(segs.all.QRedTarget_pst);
		for i=1:numel(levs)
			whichSegs = segs.all.QRedTarget_pst==levs(i) & segs.all.isSteadyState & segs.all.isClamp;
			lab = ""+string(levs(i))+"%";
			add_segment_annotation(hSub, segs, whichSegs, lab, 0, [0 0 0], y)
		end
	catch
	end

	add_segment_annotation(hSub, segs, segs.all.isEcho, 'echo', 90, [0 0 0], y)
