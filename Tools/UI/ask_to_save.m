function ask_to_save(id_tag,varargin)
    % UI for ask to save workspace to mat file, with date in the filename
    %
    % Optional input
    %    id_tag: Prefix string for filename
    %
    
    if nargin==0, id_tag=''; end
    
    response = ask_list_ui({'Yes','No'},'Initializing done, save workspace file?');
    if response==1
        saveTime = datetime(now,'ConvertFrom','datenum','Format','uuuu.MM.dd HH:mm:ss');
        if strcmp(id_tag,'')
            workspace_fileName = [id_tag,' - Workspace - ',datestr(saveTime)];
        else
            workspace_fileName = ['Workspace - ',datestr(saveTime)];
        end
        save(workspace_fileName,varargin{:})
    end
end