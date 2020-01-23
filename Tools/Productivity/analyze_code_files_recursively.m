function [status,h_browser] = analyze_code_files_recursively(base_path)
    %
    %
    
    if nargin==0
        base_path = '';
    end
    
    listing_struct = dir(fullfile(base_path,'**/*.m'));
    listing_table = struct2table(listing_struct);
    folders = unique(listing_table.folder);
    
    %files = fullfile(listing_table.folder,listing_table.name);
    %checkcode(files)
    
    results_for_browser = [];
    for i=1:numel(folders)
        results = mlintrpt(folders{i},'dir');
        results_for_browser = [results_for_browser, results{:}]; %#ok<AGROW>
    end
    [status,h_browser] = web(['text://' results_for_browser],'-noaddressbox');
    
end