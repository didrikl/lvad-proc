function h_ax = add_shaded_boxes_and_subtitles(h_ax,subTitles,...
		panelHeight,panelWidth,yGap,spec)
	
	for j=1:size(h_ax,2)
		titBoxPos = [
			h_ax(1,j).Position(1)
			h_ax(1,j).Position(2)+panelHeight+1
			panelWidth
			22]';
		annotation('textbox',[0,0.5,0.2,0.1],...
			spec.titBox{:},...
			'Position',titBoxPos,...
			'String',subTitles{j} ...
			);
		for i=2:size(h_ax,1)
			sepBoxPos = [
				h_ax(i,j).Position(1)
				h_ax(i,j).Position(2)+panelHeight
				panelWidth
				yGap-1]';
			annotation('textbox',[0,0.5,0.2,0.1],...
				spec.sepBox{:},...
				'Position',sepBoxPos);
		end
	end
end