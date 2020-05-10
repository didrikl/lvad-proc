function str = display_filename(names,path,msg,indent)

    ILLEGAL_CHARS_FOR_FILENAME = '[/\*:?"<>|]';
    ILLEGAL_CHARS_FOR_PATH = '[\*?"<>|]';
    CHARS_NEED_ESCAPING = '\';
    %CHARS_NEED_ESCAPING = {'\','_'};
    
    if nargin<2
        path = '';
    end
    if nargin<3
        msg = '';
    end
    if nargin<4
        indent = '\t';
    end
    
    [names,path,msg] = convertStringsToChars(names,path,msg);
    if not(iscell(names)), names = {names}; end
        
    str = sprintf(msg);
    for i=1:numel(names)
        % if path not given, check if name contains file path
        [path_in_name,name,ext] = fileparts(names{i});
        
        for j=1:numel(CHARS_NEED_ESCAPING)
            name = strrep(name,CHARS_NEED_ESCAPING(j),['\',CHARS_NEED_ESCAPING(j)]);
            path_in_name = strrep(path_in_name,CHARS_NEED_ESCAPING(j),['\',CHARS_NEED_ESCAPING(j)]);
        end
        
        if not(isempty(name))
            str = sprintf([str,newline,indent,'Name: ',name,ext]);
            if ~isempty(regexp(name, ILLEGAL_CHARS_FOR_FILENAME, 'once'))
                str = [str,sprintf(' (contains illegal characters for saving)')];
            end
        end
        str = [str,newline];
        
        if not(isempty(path_in_name))
            str = [str,sprintf([indent,'Path: ',path_in_name])];
            if ~isempty(regexp(path_in_name, ILLEGAL_CHARS_FOR_PATH, 'once'))
                str = [str,sprintf(' (contains illegal characters for saving)')];
            end
            if not(isempty(name))
                str = [str];%,newline];
            end
            %path = '';
        end
        
    end
    
    if not(isempty(path))
        path = strrep(path,CHARS_NEED_ESCAPING(j),['\',CHARS_NEED_ESCAPING(j)]);
        if numel(names)>1
            str = [str,newline];
        end
        str = [str,sprintf([indent,'Path: ',path])];
        if ~isempty(regexp(path, ILLEGAL_CHARS_FOR_PATH, 'once'))
            str = [str,sprintf(' (contains illegal characters for saving)')];
        end
        %str = [str,newline];
    end
    
    if nargout==0
        fprintf([strrep(str,'\','\\'),'\n'])
    end