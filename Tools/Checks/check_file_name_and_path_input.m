function [filePaths,fileNames,paths] = check_file_name_and_path_input(fileNames,path)
    path = cellstr(repmat(path,numel(fileNames),1));
    filePaths = cellstr(fullfile(path,fileNames));
    [paths,fileNames,exts] = fileparts(filePaths);
    fileNames = cellstr(string(fileNames)+string(exts));
    paths = cellstr(paths);
    
    rem_inds = false(numel(filePaths),1);
    for i=1:numel(filePaths)
        if not(exist(filePaths{i},'file'))
            str = display_filename(filePaths{i},'','','\t\t');
            msg = sprintf(['\n\tFile does not exists\n\t\t%s'...
                '\n\n\tFile path/name is removed from list of files.'],str);
            warning(msg)
            warndlg(msg)
            pause
            rem_inds(i) = true;
        end
    end
    
    filePaths(rem_inds) = [];
    fileNames(rem_inds) = [];
    paths(rem_inds) = [];