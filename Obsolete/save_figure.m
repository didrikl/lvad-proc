function save_figure(varargin)
    % SAVE_FIGURE Saves figure as graphics file, and as Matlab fig-file.
    %
    % Check if there is already an exsisting file with the same fileName in 
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. The persistent variables
    % overwrite_existing og ignore_saving_for_existing allows the program to
    % remember choices goverening future action, in case there is an existing
    % file.
    % 
    % Usage: 
    %     save_figure(path, fileName, resolution) 
    %     save_figure(h_fig, path, fileName, resolution)
    % 
    % If figure handle is not give as first argument input, then current figure
    % will be saved.
    %
    % See also writetable, save_destination_check
    
    % TODO: Support key word for maximizing the figure
    % TODO: Support key word for saving fig file
    % TODO: Support for fileName given as string
    % TODO: Input parsing
    
    % Persistent boolean switches for storing info about future actions
    persistent alwaysOverwriteExisting
    persistent alwaysIgnoreSaveExisting
    persistent alwaysSaveFigFile
    
    % Initialize the persistent variables, if not done before
    if isempty(alwaysOverwriteExisting)
        alwaysOverwriteExisting = false;
    end
    if isempty(alwaysIgnoreSaveExisting)
        alwaysIgnoreSaveExisting = false;
    end
    if isempty(alwaysSaveFigFile)
        alwaysSaveFigFile = false;
    end
    
    % First argument may be a figure handle for a specific figure to save,
    % otherwise use current figure as the figure to save.
    if numel(varargin)==3
        [path, fileName, resolution] = varargin{:};
        h_fig = gcf;
    elseif numel(varargin)==4
        [h_fig, path, fileName, resolution] = varargin{:};
    end
    
    % Replace illegal characters in fileName with a valid replacement char
    fileName = make_valid_filename(fileName);

	fprintf('\nSaving Figure %d %s',h_fig.Number,h_fig.Name)
    fprintf('\n\tAs .png with resolution: %d\n',resolution)
    if alwaysSaveFigFile
        fprintf('\tAs .fig\n')
    end
    
    % Check if there is already an exsisting file with the same fileName in 
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do.
    [path, png_fileName, alwaysOverwriteExisting, alwaysIgnoreSaveExisting] = ...
        save_destination_check(path, [fileName,'.png'], alwaysOverwriteExisting, ...
        alwaysIgnoreSaveExisting);
    if png_fileName  
        print(h_fig, fullfile(path, png_fileName),...
            '-dpng', ['-r',num2str(resolution)])
        display_filename(png_fileName,path,'Saved file','\t');
    end

    % The same persistent variables are used to keep track of future actions,
    % also for .fig files. If e.g. overwrite_existing was set to true for .png,
    % then this will also apply for .fig files. In addition, use dedicated
    % persistent variable if saving fig file nevertheless should be relevant.
    [path, fig_fileName, alwaysOverwriteExisting, alwaysIgnoreSaveExisting] = ...
        save_destination_check(path, [fileName,'.fig'], alwaysOverwriteExisting, ...
        alwaysIgnoreSaveExisting);  
    if fig_fileName & alwaysSaveFigFile
        savefig(h_fig, fullfile(path, fig_fileName))
        display_filename(fig_fileName,path,'Saved file','\t');
    end
    

    