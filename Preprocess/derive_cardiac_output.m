function Notes = derive_cardiac_output(Notes)

	contVar = 'CO_cont';
	termoVar = 'CO_thermo';
	
	Notes.CO = Notes.(termoVar);
	fillFromContCOInd = isnan(Notes.CO) & not(isnan(Notes.(contVar)));
	Notes.CO(fillFromContCOInd) = Notes.(contVar)(fillFromContCOInd);
	
	Notes.Properties.CustomProperties.Measured('CO') = true;
	Notes = movevars(Notes,'CO','After','CO_thermo');