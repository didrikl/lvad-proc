function [path, fileName, overwrite_all, ignore_all] = ...
        save_destination_check(path, fileName, overwrite_all, ignore_all)
    % SAVE_DESTINATION_CHECK
    %   Checks and initialize destination for saving, with user interaction and
    %   printed information the command line window.
    % 
    %   Check if directory exsists
    %   If saving directory does not exist: Create the directory
    %
    %   If saving directory  exist: 
    %   - Check if file already exists in the directory
    %   - If fileName exist, then the user is given the following options:
    %
    %       Overwrite
    %       Overwrite all
    %       Save to ...
    %       Ignore
    %       Ignore all
    %       Abort
    %
    %   For the 'Overwrite all' and 'Ignore all' options to work in practice,
    %   the output variables overwrite_all and ignore_all must persist in
    %   memory, e.g. declared as a persistent variables in the calling code.
    %
    % See also uiputfile, save_data

    
    % Check existence of saving directory and create new if not existing
    if not(exist(path,'dir'))
        fprintf(['\nSaving directory does not exist:\n',strrep(path,'\','\\')])
        fprintf('\nDirectory will be created.')
        mkdir(path);
    end
    
    % Check if file exists in given directory
    if exist(fullfile(path,fileName),'file')
             
        % Start with using overwrite_all and ignore_all. If they both are false,
        % then we enter the user interaction part below, allowing the user to
        % change these parameters
        overwrite=overwrite_all;
        ignore=ignore_all;
        
        % New fileName or path is not yet given
        new_fileName_selected = false;
        new_path_selected = false;
        
        % First, check with user about what to do, if not previously done 
        if not(overwrite) && not(ignore)
            
            overwrite_all=false;
            ignore_all=false;
            
            % Display warning and open user interaction menu
            user_opts = {
                'Overwrite'
                'Overwrite all'
                'Save to ...'
                'Ignore'
                'Ignore all'
                'Abort'
                };
            
            message = display_filename(fileName,path,'\nOutput file already exist:','\t');
            response = ask_list_ui(user_opts, message);
        
            if response==1
                overwrite=true;
            end
            
            % Ask no more about for the above options with option 2 or 4
            if response==2 
                overwrite_all = true; 
                overwrite = true;
            elseif response==4
                fileName = 0;
            elseif response==5
                ignore_all = true; 
                fileName = 0;
            elseif response==6
                error('Aborted')
            end
            
            % Open build-in browser for saving, giving full flexibility for filePath
            if response==3
                [new_fileName,new_path] = uiputfile(...
                    fullfile(path,fileName),'Save as');
                
                new_fileName_selected = strcmp(new_fileName, fileName);
                new_path_selected = strcmp(new_path, path);
        
                % If new fileName and/or new path was not given
                if not(new_fileName_selected) && not(new_path_selected)
                    overwrite = true;                   
                elseif not(isnumeric(new_fileName)) && not(isnumeric(new_path))
                    fileName = new_fileName;
                    path = new_path;
                    overwrite = false;
                end
                
            end
            
            % Interperate user-closed window or 'Cancel' as ignore=true
            if isempty(response)
                fileName = 0;
            end
            
        end
        
        % Display info after user interaction
        if new_fileName_selected || new_path_selected
            display_filename(new_fileName,new_path,...
                '\nSaving to new destination');
        elseif isnumeric(fileName)
            fprintf('\nSaving will not be done.\n');   
        end
        
    end
    
   