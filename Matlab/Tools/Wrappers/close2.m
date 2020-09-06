function close2(h_fig, varargin)
    % Wrapper function to Matlab's close function, just to make the closing of
    % windows more robust.
	% 
	% See also close.m
    
    try
		if strcmpi(h_fig,'all')
			F = findall(0,'type','figure');
			delete(F);
		else
			close(h_fig, varargin);
		end
    catch ME
        warning('Figure window could not be closed:')
        disp(ME.message)
    end
    
end