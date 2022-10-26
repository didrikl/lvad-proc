function isEmpty = display_block_info(B, iter, nBlocks, asSubFunc, dispFileNames)
	
	if nargin<4, asSubFunc = false; end
	if nargin<5, dispFileNames = false; end
	
	if not(asSubFunc) || dispFileNames
		welcome(sprintf('Block (no %d/%d)', iter, nBlocks), 'iteration', asSubFunc);
	end
	if dispFileNames
		display_block_varnames(B)
	elseif not(asSubFunc)
		fprintf('\n')
	end
	isEmpty = isempty(B);
	if isEmpty
		warning('Empty timetable.');
	end
