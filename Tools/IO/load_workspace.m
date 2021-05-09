function workspace_from_file = load_workspace(ws_vars, path)
          
    if nargin<2
        path = pwd; 
    else
        mat_files = get_fullpath_filelisting(fullfile(path,'*.mat'));
        if numel(mat_files)==0
            workspace_from_file = false;
            return; 
        end
    end
    
    %path_disp = display_filename('',path);
    msg = sprintf('Initializing from stored workspace file?');
    response = ask_list_ui({'Yes','No'},msg);
    if response==1
        [fileName,path]=uigetfile(path,'*.mat*',...
            'Select workspace file to load...');
        filePath = fullfile(path,fileName);
        display_filename(filePath);
        s = load(filePath,ws_vars{:});
        s_names = fieldnames(s);
        for i=1:numel(s)
            assignin('base',s_names{i},s.(s_names{i}))
        end
        workspace_from_file = filePath;
    elseif response==2
        workspace_from_file = false;
    else
        abort
    end