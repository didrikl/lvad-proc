function files = get_fullpath_filelisting(pattern)
    % List files with full path. A pattern for what to list (like in Unix)
    % may be given as input. If not given, all files, in all durdirectories, 
    % will be listed.
    
    if nargin==0
        pattern = '**/*';
    end
    
    listing_struct = dir(pattern);
    listing_table = struct2table(listing_struct);
    files = fullfile(listing_table.folder,listing_table.name);
end