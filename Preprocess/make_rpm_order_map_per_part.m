function rpmOrderMap = make_rpm_order_map_per_part(T_parts, vars, Config)

	welcome(['Calculate RPM order map for ',Config.seq],'function')
	
	res = Config.rpmOrderMapRes;%0.011;
	overlapPst = Config.rpmOrderMapOverlapPst;%overlapPst = 80; 
	ordersToTrack = [0.95, 1, 1.05, 1.95, 2, 2.05, 2.95, 3, 3.05, 3.95, 4, 4.05];

	partSpec = Config.partSpec;
	vars = cellstr(vars);
	fs = Config.fs; 
	nParts = size(partSpec,1);
	rpmOrderMap = cell(nParts,1);
	
	[returnAsCell, T_parts] = get_cell(T_parts);
	nVars = numel(vars);
	waitIncr = 1/(nParts*nVars);

	for i=1:nParts
		welcome(['T_parts index ',num2str(i)],'Iteration')
		fprintf(['\nBL parts: ',mat2str(partSpec{i,1})])
		fprintf(['\nparts: ',mat2str(partSpec{i,2})])
		fprintf(['\nlabel: ',partSpec{i,3}])
		if isempty(T_parts{i})
			warning('Part is empty')
			continue
		end

		fprintf('\nvariables: ')
		for j=1:nVars
			var = vars{j};
			
			multiWaitbar('Calculate RPM order map','Increment',waitIncr);
		    fprintf(['\n\t',var]);
			
			zeroSpeed = T_parts{i}.pumpSpeed==0;
			T_parts{i}.pumpSpeed(zeroSpeed) = 2400;
			[map, order, rpm, time] = make_rpm_order_map(T_parts{i}, var, ...
				fs, 'pumpSpeed', res, overlapPst);
			rpmOrderMap{i}.([var,'_map']) = map;
			
			% Make use of map to track specific orders
			if not(isempty(map))
				
				if not(contains(var,'_NF'))
					mags = ordertrack(db2pow(map), order, rpm, time, ordersToTrack);
					rpmOrderMap{i}.([var,'_mags']) = mags;
				end

				map = check_and_interpolate_nonfinite_artifacts(map);

				% Make use of map to calculate spectrum
				[spectrum, specorder] = orderspectrum(map, order);
				rpmOrderMap{i}.([var,'_spectrum']) = spectrum;
				rpmOrderMap{i}.([var,'_spectrum_order']) = specorder;
			end

		end

		% Store just one set of order, rpm and time (equal for all variables)
		rpmOrderMap{i}.order = order;
		rpmOrderMap{i}.rpm = rpm;
		rpmOrderMap{i}.time = time;
		
		fprintf('\n');
	end

	if not(returnAsCell), rpmOrderMap = rpmOrderMap{1}; end
	multiWaitbar('CloseAll');
	
end

function map = check_and_interpolate_nonfinite_artifacts(map)

	nonFinInd = find(not(isfinite(map)));
	if not(isempty(nonFinInd))
		fprintf('\n\t\t')
		warning("RPM order map contains " ...
			+string(numel(nonFinInd))+" nonfinite values: " ...
			+strjoin(string(unique(map(nonFinInd))),', '));
		map(nonFinInd) = nan;
		map = fillmissing(map,'movmean',5);
	end
end