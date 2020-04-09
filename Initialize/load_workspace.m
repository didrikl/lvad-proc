function workspace_from_file = load_workspace
    
    response = ask_list_ui({'Yes','No'},'Initializing from stored workspace file?');
    if response==1
        [fileName,path]=uigetfile(pwd,'*.mat*',...
            'Select workspace file to load...');
        filePath = fullfile(path,fileName);
        display_filename(filePath);
        load(filePath);
        workspace_from_file = true;
    elseif response==2
        workspace_from_file = false;
    else
        abort
    end