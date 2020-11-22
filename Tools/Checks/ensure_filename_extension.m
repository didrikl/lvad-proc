function fileNames = ensure_filename_extension(fileNames, exts)
    
    exts = cellstr(exts);
    exts = ensure_dot_in_extension(exts);
    
    return_as_char = not(iscell(fileNames));
    fileNames = cellstr(fileNames);
    
    for i=1:numel(fileNames)
        while true
            fileName = fileNames{i};
            [path,~,ext] = fileparts(fileName);
            if not(ismember(ext,exts))
                warning('Filename extension was not given or incorrect');
                opts = ["Change to "+exts,'Give new extension','Ignore'];
                %TODO: Implement these options:
                % opts = ["Substitute "+old_ext"+ with"+new_exts,"Add "+new_ext, 'Give new extension','Ignore'];
                
                resp = ask_list_ui(opts);
                if resp==numel(opts)-1
                    ext = input(sprintf('\n\tGive extension --> '),'s');
                    ext = ensure_dot_in_extension(ext);
                elseif resp==numel(opts) || isempty(resp)
                    return
                else
                    ext = exts{resp};
                end
                fileName = string(fileName)+ext;
                
                % Check for file existence, and let user to try again if it not exists
                if not(isempty(path))
                    if not(exist(fileName,'file'))
                        warning('File (with full path) does not exist')
                        resp = ask_list_ui({'Yes','No, try again...'},...
                            sprintf('\n\tContinue?'));
                        if resp==2
                            continue;
                        end
                    end
                end
                %             break
                
            else
                break
            end
            
        end
        
        fileNames{i} = convertStringsToChars(fileName);
    end
    
    if return_as_char
        fileNames = fileNames{1};
    end
    
    
    
function extension = ensure_dot_in_extension(extension)
    extension = strrep(extension,'.','');
    extension = "."+string(extension);
