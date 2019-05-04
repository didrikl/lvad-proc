function [status,h_browser] = make_recursive_code_analysis_report(base_path)
    % make_recursive_code_analysis_report
    %   Run dofixrpt recursively by gathering reports in html for each
    %   directory into one report. Report will summaries all comment lines with
    %   the key words TODO, FIXME or NOTE. The report is displayed in 
    %
    % Usage:
    %   [status,h_browser] = make_recursive_todo_report(base_path, show),
    %   where show is an optional boolean parameter to control if the results
    %   should be displayed in Matlab's build-in web browser
    % 
    % See also mlintrpt, web
    
    
    if nargin==0
        base_path = '';
    end
    
    listing_struct = dir(fullfile(base_path,'**/*.m'));
    listing_table = struct2table(listing_struct);
    folders = unique(listing_table.folder);
    
    results_for_browser = [];
    tag_results_for_browser = [];
    for i=1:numel(folders)
       tag_results = dofixrpt(folders{i},'dir');
       tag_results_for_browser = [tag_results_for_browser, tag_results]; %#ok<AGROW>
       
       results = mlintrpt(folders{i},'dir');
       results_for_browser = [results_for_browser, results{:}]; %#ok<AGROW>
    end
    web(['text://' tag_results_for_browser],'-noaddressbox');
    [status,h_browser] = web(['text://' results_for_browser],'-noaddressbox','-new');
    
end