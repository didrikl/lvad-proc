function path = get_path(pattern)
    % Get one path from a given suggested path/pattern from using
    % the get_fullpath_filelisting function.
    
    if isfolder(pattern)
        path = fullfile([pattern,'\']);
        return
    end
    
    path = get_fullpath_filelisting(pattern);
    if iscell(path)
        if numel(path)>1
            pattern_str = display_filename(pattern);
            answer = ask_list_ui(path,...
                sprintf(['Multiple directories found for pattern\n\t%s',...
                '\nSelect which experiment directory to use\n'],pattern_str));
            if isempty(answer), abort; end
            path = path{answer};
        elseif numel(path)==0
            fprintf('\n\tNo directory for given path pattern:')
            display_filename('',pattern);
            [root,~,~] = fileparts(pattern);
            path = uigetdir(root,...
                'Select the directory to use...');
        end
    end
    path = fullfile([path,'\']);