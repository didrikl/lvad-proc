function T = exclude_bad_signal(T, vars, exclRanges)

	if isempty(vars), return; end
	[returnAsCell,T] = get_cell(T);

	for k=1:numel(T)
		T{k} = exclude(T{k}, vars, exclRanges);
	end

	if not(returnAsCell), T = T{1}; end

function T = exclude(T, vars, exclRanges)
	for j=1:numel(vars)
		var=vars{j};
		for i=1:size(exclRanges,1)
			t1 = datetime(exclRanges{i,1},'TimeZone',T.time.TimeZone);
			t2 = datetime(exclRanges{i,2},'TimeZone',T.time.TimeZone);
			tr = timerange(t1,t2);
			[tf,whichRows] = overlapsrange(T,tr);
			if tf
				T.(var)(whichRows) = nan;
			end
		end
	end
