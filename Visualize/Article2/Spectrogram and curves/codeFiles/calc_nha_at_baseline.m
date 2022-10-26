function bp_bl = calc_nha_at_baseline_G1B(segs, T, fs)
	% TODO: Change to use of find baseline function!?!
	blSeg = find(segs.all.isBaseline);
	inds_bl = [];
	for i=1:numel(blSeg)
		inds_bl = [inds_bl,segs.all.startInd(blSeg(i)):segs.all.endInd(blSeg(i))];
	end
	if isempty(inds_bl)
		inds_bl = segs.main.startInd(1):segs.main.endInd(1);
	end
	bp_bl = calc_nha_G1B(T, inds_bl, fs);
