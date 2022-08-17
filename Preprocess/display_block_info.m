function isEmpty = display_block_info(B, iter, nBlocks, asSubFunc, dispFileNames)
	
	if nargin<4, asSubFunc = false; end
	if nargin<5, dispFileNames = false; end
	
	welcome(sprintf('Block (no %d/%d)',iter,nBlocks),'iteration',asSubFunc);
	if dispFileNames
		display_block_varnames(B)
	else
		fprintf('\n')
	end
	isEmpty = isempty(B);
	if isEmpty
		warning('Empty timetable.');
	end
