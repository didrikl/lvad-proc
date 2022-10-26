function hPlt = plot_curves(T1)
	
	flowColor = [0.07,0.39,0.50];%[0.03,0.26,0.34,1];
	nhaColor = [0.76,0.0,0.2];
	plvadColor = [0.87,0.50,0.13];

	hPlt(1) = plot(T1.dur,T1.Q,'LineWidth',1.75,'Color',flowColor);
	hPlt(2) = plot(T1.dur,T1.P_LVAD,':','LineWidth',2.2,'Color',plvadColor);
	plot(T1.dur,T1.P_LVAD,'LineWidth',3.5,'Color',[plvadColor,0.15]);
	plot(T1.dur,1000*T1.bp,'-','LineWidth',4,'Color',[nhaColor,0.15]);
	hPlt(3) = plot(T1.dur,1000*T1.bp,'-.','LineWidth',2.2,'Color',nhaColor);
