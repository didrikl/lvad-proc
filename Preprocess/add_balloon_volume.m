function Notes = add_balloon_volume(Notes)

	Notes.balVol_xRay = (4/3)*pi.*(Notes.balDiam_xRay.^2).*Notes.balHeight_xRay;
	
	Notes.Properties.CustomProperties.Measured('balVol_xRay') = true;
	Notes = movevars(Notes,"balVol_xRay","After","balHeight_xRay");