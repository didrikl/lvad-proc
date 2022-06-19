function T = adjust_for_constant_time_offset_for_filenames(...
		T, filesWithOffset, offsetBehind, timeVar)
	% In cell array of timetable blocks, lookup if initialized filename had
	% time offsets and correct the time with given time offsets

	if nargin<4, timeVar = 'time'; end

	if isempty(T)
		warning('Input data table %s is empty',inputname(1))
		return
	end

	welcome('Adjust for constant time offset')

	if not(isduration(offsetBehind))
		offsetBehind = seconds(offsetBehind);
	end

	[returnAsCell,T] = get_cell(T);

	if numel(offsetBehind)==1
		offsetBehind = repmat(offsetBehind,1,numel(filesWithOffset));
	elseif numel(offsetBehind)~=numel(filesWithOffset)
		warning(['Number of time offsets must equal the number of files',...
			'if multiple time offset are to be used']);
	end

	for i=1:numel(T)
		ii = find(ismember(T{i}.Properties.UserData.FileName,filesWithOffset));
		if not(isempty(ii))
			display_block_varnames(T{i})
			fprintf('\nAdjusting %s\n',(offsetBehind(ii(1))))
			T{i}.time = T{i}.(timeVar)+offsetBehind(ii(1));
		end

	end

	if not(returnAsCell), T = T{1}; end
