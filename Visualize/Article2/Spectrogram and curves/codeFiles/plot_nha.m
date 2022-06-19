function h = plot_nha(hAx, segs, T, nha_bl, yLims, fs, segType)
	
	if nargin<7, segType = 'main'; end

	nha = nan(height(T),1);
	for i=1:height(segs.(segType))-1
		if segs.(segType).isTransitional(i), continue; end
		if segs.(segType).isEcho(i), continue; end
		inds = segs.(segType).startInd(i):segs.(segType).startInd(i+1);%segs.main.endInd(i);
		nha(inds) = calc_nha(T, inds, fs);	
	end
	if not(segs.(segType).isTransitional(end))
		inds = segs.(segType).startInd(end):height(T);
		nha(inds) = calc_nha(T, inds, fs);
	end

	nha_relDiff = calc_diff_from_baseline_avg(nha, nha_bl, 'relative');
	
	nhaColor = [0.76,0.0,0.2];
	h(1) = plot(hAx, T.dur, nha_relDiff,...
 		'-','LineWidth',2.5,'Color',[nhaColor,0.85]);
	
	hAx.Clipping = 'off';
	ylim(yLims);
	xlim([0,max(T.dur)])
