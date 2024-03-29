function h = plot_nha(hAx, segs, T, nha_bl, yLims, fs, segType, nhaColor, vars)
	
	if nargin<7, segType = 'main'; end
	if nargin<8, nhaColor = [0.76,0.0,0.2]; end
	if nargin<9, vars = {'accA_x_NF_HP','accA_y_NF_HP','accA_z_NF_HP'}; end
	[~, vars] = get_cell(vars);
	
	
	nha = nan(height(T),1);
	for i=1:height(segs.(segType))-1
		if segs.(segType).isTransitional(i), continue; end
		if segs.(segType).isEcho(i), continue; end
		inds = segs.(segType).startInd(i):segs.(segType).startInd(i+1);%segs.main.endInd(i);
		nha(inds) = calc_nha(T, inds, fs, vars);	
	end
	if not(segs.(segType).isTransitional(end))
		inds = segs.(segType).startInd(end):height(T);
		nha(inds) = calc_nha(T, inds, fs, vars);
	end

	nha_relDiff = calc_diff_from_baseline_avg(nha, nha_bl, 'relative');
	
	h(1) = plot(hAx, T.dur, nha_relDiff,...
 		'-','LineWidth',2.5,'Color',[nhaColor,0.85]);
	
	hAx.Clipping = 'off';
	ylim(yLims);
	xlim([0,max(T.dur)])
