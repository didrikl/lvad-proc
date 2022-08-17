function welcome(str, type, asSubFunc)
    
    if nargin<2, type = 'function'; end
    if nargin<3, asSubFunc=false; end
    
	% Omit info when function is called as subfunction
    if asSubFunc
        fprintf('\n')
        return
    end
    
    switch lower(type)
        case 'iteration'
            fprintf('\n<strong>%s</strong>',sprintf(str))
        
        case 'function'
            line = repmat('-',1,numel(str)+2);
            fprintf('\n<strong> %s</strong>\n<strong>%s</strong>\n',sprintf(str),line)
            
        case 'module'
            line = repmat('*',1,numel(str)+4);
            fprintf('\n\n<strong>%s</strong>\n<strong>* %s *</strong>\n<strong>%s</strong>\n',line,sprintf(str),line)
            
        case 'program'
            line = repmat('*',1,80);
            fprintf('\n%s\n<strong> %s</strong>\n%s\n',line,sprintf(str),line)
            % NOTE: Could also display info about start of execution, 
            % program version, etc.
            
        otherwise
            error('type is not supported')
    end