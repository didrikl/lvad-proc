function workspace_from_file = load_workspace(ws_vars)
       
        
    response = ask_list_ui({'Yes','No'},'Initializing from stored workspace file?');
    if response==1
        [fileName,path]=uigetfile(pwd,'*.mat*',...
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