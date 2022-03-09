function hPlt = plot_curves_G1(T1)
	Colors_IV2
	nhaColor = [228,26,28]/256;
	flowColor = Colors.Fig.Cats.Speeds4(1,:);
	plvadColor = Colors.Fig.Cats.Speeds4(2,:);

	hPlt(1) = plot(T1.dur,T1.Q,'LineWidth',1.75,'Color',flowColor);
	hPlt(2) = plot(T1.dur,T1.P_LVAD,'--','LineWidth',2.2,'Color',plvadColor);
	plot(T1.dur,T1.P_LVAD,'LineWidth',3.5,'Color',[plvadColor,0.15]);
	plot(T1.dur,1000*T1.bp,'-','LineWidth',4,'Color',[nhaColor,0.15]);
	hPlt(3) = plot(T1.dur,1000*T1.bp,':','LineWidth',2.2,'Color',nhaColor);
	
