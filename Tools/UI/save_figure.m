function save_figure(varargin)
    % SAVE_FIGURE 
    % Saves figure as graphics file, and as Matlab fig-file.
    %
    % Check if there is already an exsisting file with the same filename in 
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. The persistent variables
    % overwrite_existing og ignore_saving_for_existing allows the program to
    % remember choices goverening future action, in case there is an existing
    % file.
    % 
    % Usage: 
    %     save_figure(path, filename, resolution) or 
    %     save_figure(h_fig, path, filename, resolution)
    % 
    % If figure handle is not give as first argument input, then current figure
    % will be saved.
    %
    % See also writetable, save_destination_check
    
    % First argument may be a figure handle for a specific figure to save,
    % otherwise use current figure as the figure to save.
    if numel(varargin)<4
        [path, filename, resolution] = varargin{:};
        h_fig = gcf;
    elseif numel(varargin)==4
        [h_fig, path, filename, resolution] = varargin{:};
    end
    
    fprintf('\nSaving figure %s...',h_fig.Name)
    
    % TODO: Support key word for maximizing the figure
    % TODO: Support key word for saving fig file
    % TODO: Support for filename given as string
    % TODO: Input parsing
    
    % Persistent boolean switches for storing info about future actions
    persistent always_overwrite_existing
    persistent always_ignore_save_existing
    persistent always_save_fig_file
     
    % Initialize the persistent variables, if not done before
    if isempty(always_overwrite_existing)
        always_overwrite_existing = false;
    end
    if isempty(always_ignore_save_existing)
        always_ignore_save_existing = false;
    end
    if isempty(always_save_fig_file)
        always_save_fig_file = false;
    end

    % Check if there is already an exsisting file with the same filename in 
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do.
    [path, png_filename, always_overwrite_existing, always_ignore_save_existing] = ...
        save_destination_check(path, [filename,'.png'], always_overwrite_existing, ...
        always_ignore_save_existing);
    if png_filename      
        print(h_fig, fullfile(path, png_filename),...
            '-dpng', ['-r',num2str(resolution)])
        fprintf('\nSaved as %s, with %d dpi resolution.',...
            png_filename,resolution);
    end
    
    % The same persistent variables are used to keep track of future actions,
    % also for .fig files. If e.g. overwrite_existing was set to true for .png,
    % then this will also apply for .fig files. In addition, use dedicated
    % persistent variable if saving fig file nevertheless should be relevant.
    [path, fig_filename, always_overwrite_existing, always_ignore_save_existing] = ...
        save_destination_check(path, [filename,'.fig'], always_overwrite_existing, ...
        always_ignore_save_existing);  
    if fig_filename && always_save_fig_file
        savefig(h_fig, fullfile(path, fig_filename))
        fprintf('\nSaved as %s\n',fig_filename);
    end
    

    