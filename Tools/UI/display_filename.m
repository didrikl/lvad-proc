function str = display_filename(name,path,msg,indent)

    ILLEGAL_CHARS_FOR_FILENAME = '[/\*:?"<>|]';
    ILLEGAL_CHARS_FOR_PATH = '[\*?"<>|]';
    CHARS_NEED_ESCAPING = '\';
    
    % if path not given, check if name contains file path
    [path_in_name,name,ext] = fileparts(name);
    if nargin<2 || isempty(path)
        path = path_in_name;
    end
    if nargin<4
        indent = '\t';
    end
    if nargin<3
        msg = '';
    end
        
    for i=1:numel(CHARS_NEED_ESCAPING)
        name = strrep(name,CHARS_NEED_ESCAPING(i),['\',CHARS_NEED_ESCAPING(i)]);
        path = strrep(path,CHARS_NEED_ESCAPING(i),['\',CHARS_NEED_ESCAPING(i)]);
    end
    
    str = sprintf([msg,newline,indent,'Name: ',name,ext]);
    if ~isempty(regexp(name, ILLEGAL_CHARS_FOR_FILENAME, 'once'))
        str = [str,sprintf(' (contains illegal characters for saving)')];
    end
    str = [str,newline];
    
    if not(isempty(path))
        str = [str,sprintf([indent,'Path: ',path])];
        if ~isempty(regexp(path, ILLEGAL_CHARS_FOR_PATH, 'once'))
            str = [str,sprintf(' (contains illegal characters for saving)')];
        end
        str = [str,newline];
    end
    
    if nargout==0
        disp(str)
    end