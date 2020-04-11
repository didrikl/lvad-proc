function files = get_fullpath_filelisting(pattern,filter)
    % List files with full path. A pattern for what to list (like in Unix)
    % may be given as input. If not given, all files, in all durdirectories, 
    % will be listed.
    %
    % Optional input
    %    pattern: string of unix like pattern for listing files
    %    filter: string for filtering out any listing entries that contains 
    %            this string. (For more advanced filtering, use regexp
    %            separately from this function.)
    
    if nargin<1, pattern = '**/*'; end
    if nargin<2, filter={'..','.'}; end
    
    listing_struct = dir(pattern);
    if isempty(listing_struct) 
        files={};
        return; 
    end
    
    % Apply filter
    filter_inds = ismember({listing_struct(:).name}',filter);
    listing_struct = listing_struct(not(filter_inds));
    
    listing_table = struct2table(listing_struct);
    files = fullfile(listing_table.folder,listing_table.name);

