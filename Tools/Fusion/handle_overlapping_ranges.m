function [TT_cur,TT_prev] = handle_overlapping_ranges(TT_cur,TT_prev,parMerge)
	
	if nargin<3, parMerge=true; end
	
	% First, check how current timetable overlaps with previous file
	[isOverlap, isOverlapRows] = overlapsrange(TT_cur,TT_prev);
	
	if isOverlap
		
		% Check also how previous timetable overlaps with current file
		[~, isOverlapRows_prev] = overlapsrange(TT_prev,TT_cur);
		
		% Case 1: Indentical time ranges, and merge according to parMerge
		if all(isOverlapRows) && all(isOverlapRows_prev)
			
			fprintf('Time range is indentical with previous file. ')
			if parMerge
				fprintf('Previous file is merged into current file.')
				
				[TT_prev,TT_cur] = handle_duplicate_varnames(TT_prev,TT_cur);
				prev_filename = string(TT_prev.Properties.UserData.FileName);
				cur_filename = string(TT_cur.Properties.UserData.FileName);
				prev_filepath = string(TT_prev.Properties.UserData.FilePath);
				cur_filepath = string(TT_cur.Properties.UserData.FilePath);
				
				TT_cur=[TT_prev,TT_cur];
				
				TT_cur.Properties.UserData.FileName = cellstr(...
					[prev_filename,cur_filename]);
				TT_cur.Properties.UserData.FilePath = cellstr(...
					[prev_filepath,cur_filepath]);
				
			end
			fprintf('\n')
			TT_prev = [];
			
		elseif all(isOverlapRows_prev)
			
			warning(['Previous file''s timerange is fully ',...
				'incorporated within current file''s timerange, ',...
				'but current file contains additional timestamps. ',...
				'Overlapping rows in current file is deleted'])
			TT_cur(isOverlapRows,:) = [];
			
		elseif all(isOverlapRows)
			
			warning(['Current file''s timerange is fully ',...
				'incorporated within previous file timerange, but ',...
				'previous file contains additional timestamps. ',...
				'Overlapping rows in previous file is deleted'])
			TT_prev(isOverlapRows_prev,:) = [];
			
		else
			
			warning(sprintf(...
				['Timerange is partially overlapping with %d of %d rows ',...
				'contained within timerange of previous file. ',...
				'Overlapping rows in current file is deleted'],...
				nnz(isOverlapRows),height(TT_cur)));
			TT_cur(isOverlapRow) = [];
			
		end
		
	end