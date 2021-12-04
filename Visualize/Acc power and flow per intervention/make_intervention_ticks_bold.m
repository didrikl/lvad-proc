function h_ax = make_intervention_ticks_bold(h_ax)
	nRows = size(h_ax,1);
	for j=1:size(h_ax,2)
		xt = h_ax(nRows,j).XTickLabels;
		for k=2:numel(xt)-1
			h_ax(nRows,j).XTickLabels{k} =  "\bf"+xt{k};
		end
	end
end
