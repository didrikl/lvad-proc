function save_figure(varargin)
    % SAVE_FIGURE Saves figure as graphics file, and as Matlab fig-file.
    %
    % Check if there is already an exsisting file with the same filename in 
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. The persistent variables
    % overwrite_existing og ignore_saving_for_existing allows the program to
    % remember choices goverening future action, in case there is an existing
    % file.
    % 
    % Usage: 
    %     save_figure(path, filename, resolution) 
    %     save_figure(h_fig, path, filename, resolution)
    % 
    % If figure handle is not give as first argument input, then current figure
    % will be saved.
    %
    % See also writetable, save_destination_check
    
    % TODO: Support key word for maximizing the figure
    
    % Persistent boolean switches for storing info about future actions
    persistent always_overwrite
    persistent always_ignore_save_existing
    
    % Initialize the persistent variables, if not done before
    if isempty(always_overwrite)
        always_overwrite = false;
    end
    if isempty(always_ignore_save_existing)
        always_ignore_save_existing = false;
    end
    
    % First argument may be a figure handle for a specific figure to save,
    % otherwise use current figure as the figure to save.
    [hFig, path, filename, figTypes, resolution] = parse_inputs(varargin{:});
	
    % Replace illegal characters in filename with a valid replacement char
    filename = make_valid_filename(filename);

    fprintf('\nSaving Figure %d %s',hFig.Number,hFig.Name)
	
	for i=1:numel(figTypes)
		
		[path, saveName, always_overwrite, always_ignore_save_existing] = ...
			save_destination_check(path, [filename,'.',figTypes{i}], always_overwrite, ...
			always_ignore_save_existing);
		
		if not(saveName)
			display_filename(filename, path, 'File not saved.','\t');
			continue
		end
		
		filePath = fullfile(path, saveName);
		switch figTypes{i}
	
			    case 'eps'
					saveas(hFig, filePath, 'epsc')

				case 'svg'
					print(hFig, filePath, '-dsvg');
	
				case 'pdf'
					print(hFig, filePath, '-dpdf', '-vector')
					
				case 'fig'
					savefig(hFig, filePath)
					
				case 'png'
					%exportgraphics(h_fig,fullfile(path, png_filename),'Resolution',resolution)
					print(hFig, filePath,'-dpng', ['-r',num2str(resolution)])
					fprintf('\tResolution: %d\n',resolution);

				case {'tif','tiff'}
					print(hFig, filePath,'-dtiff', ['-r',num2str(resolution)])
					fprintf('\tResolution: %d\n',resolution);

			    case {'jpeg','jpg'}
					print(hFig, filePath,'-djpeg', ['-r',num2str(resolution)])
					fprintf('\tResolution: %d\n',resolution);

			otherwise
				warning('Saving format as %s is not supported',figTypes{i})
			
			end
			
			display_filename(saveName,path,'\nFile saved.','\t');

	end
			
end

function [hFig, path, filename, figTypes, res] = parse_inputs(varargin)
	if ishandle(varargin{1})
		hFig = varargin{1};
		varargin(1) = [];
	else
		hFig = gcf;
	end
	[path, filename, figTypes] = varargin{1:3};
	[~,figTypes] = get_cell(figTypes);
	if numel(varargin)==4
        res = varargin{4};
	else
		res = 300;
	end

end   
    

    