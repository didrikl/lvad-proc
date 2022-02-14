function h_lab = add_supLabel(lab,spec,ax)
	h_lab = suplabel(lab,ax);
	set(h_lab,spec.supXLab{:});
	h_lab.Units = 'points';
		
		