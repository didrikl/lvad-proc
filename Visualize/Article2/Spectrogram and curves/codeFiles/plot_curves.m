function h = plot_curves(hAx, hAxNHA, T, segs, fs, yLims, yLimsNHA)
	
	flowColor = [0.03,0.26,0.34,1];%Colors.Fig.Cats.Speeds4(1,:);
	plvadColor = [0.9961,0.4961,0];%Colors.Fig.Cats.Speeds4(2,:);
	qlvadColor = [0.39,0.83,0.07];%[0.00,0.78,0];%Colors.Fig.Cats.Speeds4(4,:);

	h(1) = plot(hAx, T.dur, T.Q_relDiff,...
 		'LineWidth',.9,'Color',flowColor);  	
	
	nha_bl = calc_nha_at_baseline(segs, T, fs);
	h(4) = plot_nha(hAxNHA, segs, T, nha_bl, yLimsNHA, fs);
	
	h(2) = plot(hAx, T.dur,T.Q_LVAD_relDiff,...
 		':','LineWidth',2,'Color',[qlvadColor,1]);
	h(3) = plot(hAx, T.dur,T.P_LVAD_relDiff,...
 		'-.','LineWidth',2,'Color',[plvadColor,1]);
	
	hAx.Clipping = 'off';
	ylim(yLims);
	xlim([0,max(T.dur)])
