function F_rel = calc_relative_feats(F)
	% Calculate absolute "delta" difference from corresponding baseline for
	% numeric columns in the feat table.
	
	welcome('Calculate relative1 differences of features','function')
	
	F_rel = make_feats_diff(F,@calc);
	
	function feat_diff_row = calc(feat_row,feat_row_bl)
		feat_diff_row = (feat_row-feat_row_bl)./feat_row_bl;