function h_leg = add_legend_to_plot_NHA(h_nha,speeds,spec,legTit)
	
	h_leg = legend(h_nha(end:-1:1),string(speeds(end:-1:1)),...
		'Units','points');
	if nargin>=4
		h_legTit = h_leg.Title;
		h_leg.Title.String = legTit;
		set(h_legTit,spec.legTit{:})
	end
	set(h_leg,spec.legTit{:});
	set(h_leg,spec.leg{:});
	