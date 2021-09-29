function PL = swap_channel_names(PL,channelsToswap,blocksForChannelSwap)
	
	if isempty(channelsToswap), return; end
	welcome('Swap channel names to correspond to actual input')
	
	if isempty(blocksForChannelSwap)
		blocks = 1:numel(PL);
	else
		blocks = blocksForChannelSwap;
	end
	
	
	for i=blocks
		
		isEmpty = display_block_info(PL{i},i,numel(PL));
		if isEmpty, continue; end
		
		fprintf('Swapped channel names: %s with %s\n',...
			channelsToswap{1},channelsToswap{2})
		
		var1 = PL{i}.(channelsToswap{1});
		PL{i}.(channelsToswap{1}) = PL{i}.(channelsToswap{2});
		PL{i}.(channelsToswap{2}) = var1;
		if isfield(PL{i}.Properties.UserData,'Swapped_Channel_Names')
			PL{i}.Properties.UserData.Swapped_Channel_Names{end+1} = channelsToswap;
		else
			PL{i}.Properties.UserData.Swapped_Channel_Names = {channelsToswap};
		end
		
	end
	
	