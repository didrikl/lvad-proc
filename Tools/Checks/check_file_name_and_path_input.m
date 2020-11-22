function [filePaths,fileNames,paths] = check_file_name_and_path_input(fileNames,path)
    
    return_as_char = not(iscell(fileNames));
    
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
            [newFileNames,newPaths] = uigetfile(...
                '','Browse for and select new files','Multiselect','on');
            
            % If no new filenames/cancelled, remove missing file from list
            if not(iscell(newFileNames)) & not(newFileNames)
                filePaths(rem_inds) = [];
                fileNames(rem_inds) = [];
                paths(rem_inds) = [];
                fprintf('\nMissing files removed from list of files.\n')
            else
                paths = cellstr(newPaths);
                fileNames = newFileNames;
                filePaths = fullfile(newPaths,newFileNames)';
                display_filename(newFileNames,newPaths,'\nSelected files','\t');
            end
        end
    end
    
    if return_as_char && numel(fileNames)==1
        fileNames = fileNames{1};
        paths = paths{1};
        filePaths = filePaths{1};
    end
