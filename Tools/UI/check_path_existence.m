function path = check_path_existence(path)
    
    if not(exist(path,'dir'))
        opts = {
            'Select new directory'
            'Ignore'
            'Abort'
            };
        message = display_filename(path,'','\nPath does not exist:');
        response = ask_list_ui(opts,message);
        
        if response==1
            path = uigetdir('','Select directory to use...');
            path = fullfile([path,'\']);
            display_filename(path,'','\nSelected path');
        elseif response==3
            abort; 
        end
            
    end
    
    
    