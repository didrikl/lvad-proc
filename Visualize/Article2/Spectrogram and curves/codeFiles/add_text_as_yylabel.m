function hYyTxt = add_text_as_yylabel(hSub)
	hYyTxt = text(hSub,max(xlim(hSub(1))),mean(ylim(hSub(1))),'Hz',...
		'Rotation',90,'FontName','Arial');
	hYyTxt.Units = 'pixels'; 
