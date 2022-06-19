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
		for j=1:nVars
			var = vars{j};

			multiWaitbar('Calculate RPM order map','Increment',waitIncr);
			
			[map,order,rpm,time] = make_rpm_order_map(T_parts{i}, var, ...
				fs, 'pumpSpeed', res, overlapPst);

			% Make use of map (but for now not needed):
			% if not(contains(accVar,'_NF'))
			%     ordertrack(...,'Amplitude','power')
			% end

			rpmOrderMap{i}.([var,'_map']) = map;

		end

		% Store just one set of order, rpm and time (equal for all variables)
		rpmOrderMap{i}.order = order;
		rpmOrderMap{i}.rpm = rpm;
		rpmOrderMap{i}.time = time;

	end

end
