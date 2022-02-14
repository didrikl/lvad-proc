function Notes = calc_obstruction(pc, Notes)

	Notes.arealObstr_pst = 100*(Notes.balDiam_xRay.^2)/(pc.inletInnerDiamLVAD^2);
	
	% Formula for calculating volume?
	% ...
