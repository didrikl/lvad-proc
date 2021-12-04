function [h_ax,h_xax,h_yax] = offset_main_ax(h_ax,h_xax,h_yax,mainXAxGap,mainYAxGap)
	% Make neccessary formating and offsets for extra set of common axis to 
	% sets of plot panels
	
	nPanelRows = size(h_ax,1);
	nPanelCols = size(h_ax,2);
	
	set([h_xax,h_yax],'box','off')
	set([h_xax,h_yax],'Color','none');
	set([h_xax,h_yax],'YGrid','off');
	set([h_xax,h_yax],'XGrid','off');
	set(h_yax,'YColor',[0,0,0])
	set(h_xax,'XColor',[0,0,0])

	for i=1:nPanelRows
		h_yax(i).Position = h_ax(i,1).Position;
		h_yax(i).XAxis.Visible = 'off';
		h_yax(i).YLim = h_ax(i,1).YLim;

		h_yax(i).Position(1) = h_yax(i).Position(1)-mainYAxGap;
	end

	for j=1:nPanelCols
		h_xax(j).YAxis.Visible = 'off';
		h_xax(j).XLim = h_ax(nPanelRows,j).XLim;
		h_xax(j).XTick = h_ax(nPanelRows,j).XTick;
		h_xax(j).XTickLabel = h_ax(nPanelRows,j).XTickLabel;
		h_xax(j).Position = h_ax(nPanelRows,j).Position;

		h_xax(j).Position(2) = h_xax(j).Position(2)-mainXAxGap;
		h_xax(j).Position(4) = h_ax(j).Position(4);
	end

	set(h_ax,'XTickLabel',{});
	set(h_ax,'YTickLabel',{});
%  	set([h_ax],'XColor',h_ax(1,1).GridColor);%h_fig.Color);
% 	set([h_ax],'YColor',h_ax(1,1).GridColor);%h_fig.Color);
	set(h_ax,'TickLength',[0 0]);
	