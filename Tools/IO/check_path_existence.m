function path = check_path_existence(path)
    
    if not(exist(path,'dir'))
        opts = {
            'Create path'
            'Select another path'
            'Ignore'
            'Abort'
            };
        path_str = display_filename(path,'');
        msg = sprintf(['Path does not exist:\n',path_str]);
        response = ask_list_ui(opts,msg);
        
        if response==1
            mkdir(path)
        elseif response==2
            path = uigetdir('','Select directory to use...');
            path = fullfile([path,'\']);
            display_filename(path,'','\nSelected path');
        elseif response==3
            % Do nothing
        elseif response==4
            abort; 
        end
            
    end
    
    
    