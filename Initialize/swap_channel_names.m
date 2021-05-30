function PL = swap_channel_names(PL,vars_to_swap,restrictBlockChannelSwap)
    
    if isempty(restrictBlockChannelSwap)
        blocks = 1:numel(PL);
    else
        blocks = restrictBlockChannelSwap;
    end
        
    if isempty(vars_to_swap), return; end
    
    fprintf('\nSwapping channel names: %s with %s\n',...
        vars_to_swap{1},vars_to_swap{2})
    
    for i=blocks
        var1 = PL{i}.(vars_to_swap{1});
        PL{i}.(vars_to_swap{1}) = PL{i}.(vars_to_swap{2});
        PL{i}.(vars_to_swap{2}) = var1;
        if isfield(PL{i}.Properties.UserData,'Swapped_Channel_Names')    
            PL{i}.Properties.UserData.Swapped_Channel_Names{end+1} = vars_to_swap;
        else
            PL{i}.Properties.UserData.Swapped_Channel_Names = {vars_to_swap};
        end
        
    end
    
    