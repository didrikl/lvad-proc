function Notes = add_obstruction_pst(Config, Notes)

	Notes.arealObstr_xRay_pst = ...
		100*(Notes.balDiam_xRay.^2)/(Config.inletInnerDiamLVAD^2);
	Notes.Properties.CustomProperties.Measured('arealObstr_xRay_pst') = true;
	
	% Formula for calculating volume?
	% ...

	Notes = movevars(Notes,"arealObstr_xRay_pst","After","balDiam_xRay");