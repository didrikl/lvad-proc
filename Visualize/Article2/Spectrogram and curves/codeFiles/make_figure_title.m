function tit = make_figure_title(rpms, seqID, partSpec, accVar, mapColScale, colorMapName, suffix)
	
	if not(isempty(partSpec{1}))
		parts = [partSpec{1}(1),partSpec{2}];
	else
		parts = partSpec{2};
	end	
	parts = strjoin(string(parts),',');
	rpm = strjoin(string(rpms),',');
	mapColScale = mat2str(mapColScale);
	tit = sprintf('%s - Part [%s] - %s - [%s] RPM - %s - %s %s - %s', ...
		seqID, parts, partSpec{3}, rpm, accVar, colorMapName, mapColScale, suffix);
