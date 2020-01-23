function fileName = make_valid_fileName(fileName)
    
    illegal_char_list = '[/\*:?"<>|]';
    replacement_char = '_';
    
    fileName = regexprep(fileName, illegal_char_list, replacement_char);