function y = convert_bandpower_to_decibel(accAsdB, var, F)
	if accAsdB && contains(var,'acc')
		y = pow2db(F.(var)); 
	else
		y = F.(var); 
	end
end