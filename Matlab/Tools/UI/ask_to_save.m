function ask_to_save(varList,id_tag)
    % UI for ask to save workspace to mat file, with date in the filename
    %
    % Optional input
    %    id_tag: Prefix string for filename
    %
    
    if nargin<2, id_tag=''; end
    
    welcome('Save workspace')
    msg = sprintf('\nSave variables?\n\t%s\n',strjoin(varList,','));
    
    saveTime = datetime(now,...
        'ConvertFrom','datenum',...
        'Format','uuuu.MM.dd HHmmss');
    saveTimeString = char(string(saveTime));
    if not(strcmp(id_tag,''))
        workspace_fileName = [id_tag,' - Workspace ',saveTimeString,'.mat'];
    else
        workspace_fileName = ['Workspace - ',saveTimeString,'.mat'];
    end
        
    opts = {
        ['Save as ',workspace_fileName]
         'Save as ... '
         'No'
        };
    response = ask_list_ui(opts,msg);
    if response==2
        workspace_file = input(sprintf('\n\tGive filename --> '),'s');
        [~,name,~] = fileparts(workspace_file);
        workspace_fileName = [name,'.mat'];
    end
    if response==1 || response==2
        saveCode = sprintf("save('%s',%s)", ...
            workspace_fileName, join("'"+varList+"'",','));
        evalin('base',saveCode)
    end
end
