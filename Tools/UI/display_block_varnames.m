function display_block_varnames(T,indent)
    
    if nargin<2, indent = ''; end
    
    if isfield(T.Properties.UserData,'FileName')
        filenames = cellstr(T.Properties.UserData.FileName);
        if numel(filenames)>1
            fprintf('\n%sFilenames:\n\t%s%s\n',...
                indent,strjoin(filenames,[indent,'\n\t']))
            fprintf('\n')
        else
            fprintf('\n%sFilenames: %s\n',...
                indent,filenames{1})
        end
    end
        