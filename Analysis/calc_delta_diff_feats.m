function F_del = calc_delta_diff_feats(F)
	% Calculate "delta" difference from corresponding baseline for
	% numeric columns in the feat table.
	
	welcome('Calculate delta differences of features','function')
	
	F_del = make_feats_diff(F,@calc);
	
	function feat_diff_row = calc(feat_row,feat_row_bl)
		feat_diff_row = feat_row-feat_row_bl;