function [filePaths,fileNames,paths] = check_file_name_and_path_input(fileNames,path,ext)
    
    % TODO: Check for duplicates in file list
    
    if nargin<3, ext = {}; end
    
    return_as_cell = iscell(fileNames);
    
    if not(isempty(ext))
        fileNames = ensure_filename_extension(fileNames,ext);
        ext = cellstr(ext);
    end
    
    path = cellstr(repmat(path,numel(fileNames),1));
    filePaths = cellstr(fullfile(path,fileNames));
    [paths,fileNames,exts] = fileparts(filePaths);
    fileNames = cellstr(string(fileNames)+string(exts));
    paths = cellstr(paths);
    
    rem_inds = false(numel(filePaths),1);
    for i=1:numel(filePaths)
        if not(exist(filePaths{i},'file'))
            str = display_filename(filePaths{i},'','','\t\t');
            msg = sprintf('\n\tFile does not exists\n\t\t%s',str);
            warning(msg)
            rem_inds(i) = true;
        end
    end
    
    if any(rem_inds)
        msg = display_filename(fileNames(rem_inds),'','','\t\t');
        msg = strjoin(strsplit(erase(msg,newline),'\t'),'\n\t');
        msg = sprintf('\n\tFile(s) does not exists:\n%s',msg);
        
        % Pause with GUI-warning if filelists are not going to be updated,
        % otherwise give user possiblity to browse for files
        if nargout==0
            warndlg(msg)
        else
            file_filter = make_ext_filter(ext);
            title = 'Browse for and select new file(s)';
            [newFileNames,newPaths] = uigetfile(file_filter,title,...
                'Multiselect','on');
            
            % If no new filenames/cancelled, remove missing file from list
            if not(iscell(newFileNames)) & not(newFileNames)
                opts = {
                    'Remove missing from file specification'
                    'Ignore'
                    'Abort execution'
                    };
                resp = ask_list_ui(opts,'File selection cancelled',1);
                if resp==1
                    filePaths(rem_inds) = [];
                    fileNames(rem_inds) = [];
                    paths(rem_inds) = [];
                    fprintf('\nMissing files removed from list of files.\n')
                elseif resp==3
                    abort
                end

            else
                % TODO: Do not replace, but correct/append file list
                fileNames = newFileNames;
                paths = newPaths;
                if not(iscell(paths)), paths = {paths}; end
                if not(iscell(fileNames)), fileNames = {fileNames}; end
                filePaths = fullfile(newPaths,fileNames)';
                display_filename(newFileNames,newPaths,'\nSelected files','\t');
            end
        end
    end
    
    if not(return_as_cell) && numel(fileNames)==1
        fileNames = fileNames{1};
        paths = paths{1};
        filePaths = filePaths{1};
    end
    
function ext_filter = make_ext_filter(ext)
    
    ext_filter = cell(numel(ext)+1,2);
    for i=1:numel(ext)
        ext_filter{i,1} = ['*.',ext{i}];
        ext_filter{i,2} = ['(*.',ext{i},')'];
    end
    ext_filter(numel(ext)+1,:) = {'*.*',  'All Files (*.*)'};
