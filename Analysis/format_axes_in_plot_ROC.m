function format_axes_in_plot_ROC(h_ax,spec)
	set(h_ax,spec.ax{:});
	
	nRows = size(h_ax,1);
	nCols = size(h_ax,2);
	
	for i=1:nRows
		set(h_ax(i,1).YAxis,spec.axTick{:})
	end
	for j=1:nCols
		set(h_ax(nRows,j).XAxis,spec.axTick{:})
	end
	
	set(h_ax,'XTick',0:0.2:1);
	set(h_ax,'YTick',0:0.2:1);
		
%  	set(h_ax(:,2:end),'YTickLabel',{})
% 	set(h_ax(1:end-1,:),'XTickLabel',{})
%	set(h_ax(:,2:nCols),'YColor',[1,1,1])
% 	set(h_ax(1:nRows-1,:),'XColor',[1,1,1])
 	set(h_ax,'YTickLabel',{})
 	set(h_ax,'XTickLabel',{})
	set(h_ax,'YColor',[1,1,1])
 	set(h_ax,'XColor',[1,1,1])
	set(h_ax,spec.rocAx{:})
% 	set(h_ax(:,2:end),'YTick',[])
% 	set(h_ax(1:end-1,:),'XTick',[])
		
	
		