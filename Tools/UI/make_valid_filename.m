function filename = make_valid_filename(filename)
    
    illegal_char_list = '[/\*:?"<>|]';
    replacement_char = '_';
    
    filename = regexprep(filename, illegal_char_list, replacement_char);