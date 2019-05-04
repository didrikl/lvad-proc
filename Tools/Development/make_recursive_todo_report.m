function [status,h_browser] = make_recursive_todo_report(base_path, show)
    % make_recursive_todo_report
    % Run dofixrpt recursively by gathering reports in html for each
    % directory into one report. Report will summaries all comment lines with
    % the key words TODO, FIXME or NOTE. The report is displayed in 
    %
    % Usage:
    %     [status,h_browser] = make_recursive_todo_report(base_path, show),
    %     where show is an optional boolean parameter to control if the results
    %     should be displayed in Matlab's build-in web browser
    % 
    % See also dofixrpt, web
    
    if nargin==0
        base_path = '';
    end

    if nargin<2
        show = true;
    end
    
    listing_struct = dir(fullfile(base_path,'**/*.m'));
    listing_table = struct2table(listing_struct);
    folders = unique(listing_table.folder);
    
    results_for_browser = [];
    for i=1:numel(folders)
       results = dofixrpt(folders{i},'dir');
       results_for_browser = [results_for_browser, results]; %#ok<AGROW>
    end

    if show
        [status,h_browser] = web(['text://' results_for_browser],'-noaddressbox');
    end

end