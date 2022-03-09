function fileName = make_valid_filename(fileName)
    
    illegal_char_list = '[/\*:?"<>|]';
    replacement_char = '_';
    fileName = regexprep(fileName, illegal_char_list, replacement_char);

	% Remove TeX and more
	fileName = strrep(fileName,'{','');
	fileName = strrep(fileName,'}','');
	fileName = strrep(fileName,'\it','');
	fileName = strrep(fileName,'\bf','');
	fileName = strrep(fileName,'\rm','');
	fileName = strrep(fileName,'\newline','');
	fileName = strrep(fileName,'\n','');
	fileName = strrep(fileName,'\t','');
