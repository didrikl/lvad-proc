function h_leg = add_legend_to_plot_NHA(h_nha,speeds,legSpec,legTitSpec,legTit)
	
	h_leg = legend(h_nha,string(speeds));
	if nargin>=5
		h_leg.Title.String = legTit;
	end
	set(h_leg,legTitSpec{:});
	set(h_leg,legSpec{:});
	