function T = exclude_bad_signal(T, vars, exclRanges)

	if isempty(vars), return; end
	[returnAsCell,T] = get_cell(T);
	
	welcome('Exclude data','function')
	fprintf('Variables: %s\n',strjoin(vars,', '))		
	
	zone = T{1}.time.TimeZone;
	tr = make_timeranges(zone, exclRanges);
	for k=1:numel(T)
		T{k} = exclude(T{k}, vars, tr);
	end

	if not(returnAsCell), T = T{1}; end

function T = exclude(T, vars, tr)
	for j=1:numel(vars)
		var=vars{j};
		for i=1:numel(tr)	
			[rangeInT,whichRows] = overlapsrange(T,tr{i});
			if rangeInT
				T.(var)(whichRows) = nan;
			end
		end
	end

function tr = make_timeranges(zone, exclRanges)
	tr = cell(size(exclRanges,1),1);
	for i=1:size(exclRanges,1)
		t1 = datetime(exclRanges{i,1},...
			'TimeZone',zone,...
			'InputFormat','MM/dd/uuuu HH:mm:ss');
		t2 = datetime(exclRanges{i,2},...
			'TimeZone',zone,...
			'InputFormat','MM/dd/uuuu HH:mm:ss');
		fprintf('Range: %s to %s\n',t1,t2);
		tr{i} = timerange(t1,t2);
	end
