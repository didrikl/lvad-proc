function rpmOrderMap = make_rpm_order_map_per_part(T_parts, vars, Config)

	welcome('Calculate RPM order map','function')
	
	res = Config.rpmOrderMapRes;%0.011;
	overlapPst = Config.rpmOrderMapOverlapPst;%overlapPst = 80; 
	
	partSpec = Config.partSpec;
	vars = cellstr(vars);
	fs = Config.fs; 
	nParts = size(partSpec,1);
	rpmOrderMap = cell(nParts,1);
	
	nVars = numel(vars);
	waitIncr = 1/(nParts*nVars);

	for i=1:nParts
		welcome(['Part ',num2str(i)],'Iteration')
			
		for j=1:nVars
			var = vars{j};
			
			multiWaitbar('Calculate RPM order map','Increment',waitIncr);

			[map,order,rpm,time] = make_rpm_order_map(T_parts{i}, var, ...
				fs, 'pumpSpeed', res, overlapPst);
			rpmOrderMap{i}.([var,'_map']) = map;
			
			% Make use of map to track specific orders
			if not(isempty(map))
				if not(contains(var,'_NF'))
					mags = ordertrack(db2pow(map),order,rpm,time,Config.rpmOrdersToTrack);
					rpmOrderMap{i}.([var,'_mags']) = mags;
				end

				% Make use of map to calculate spectrum
				[spectrum,specorder] = orderspectrum(map, order);
				rpmOrderMap{i}.([var,'_spectrum']) = spectrum;
				rpmOrderMap{i}.([var,'_spectrum_order']) = specorder;
			end

		end

		% Store just one set of order, rpm and time (equal for all variables)
		rpmOrderMap{i}.order = order;
		rpmOrderMap{i}.rpm = rpm;
		rpmOrderMap{i}.time = time;
	
	end

	fprintf('\n');
end
