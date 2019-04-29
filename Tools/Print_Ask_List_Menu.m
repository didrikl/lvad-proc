function Print_Ask_List_Menu(options, indent, question, default)
	
    if nargin<4, default=0; end
    
	% If question is given as cell, then it is likely it was contructed for GUI
	% mode and multiline print, and thus a conversion to regular string is
	% neccessary.
	if iscell(question), question = strjoin(question,[indent,'\n']); end
	
	n_option = length(options);
	M = zeros(n_option,1);
	for i=1:n_option, M(i) = length(options{i}); end
	M_max = max(M);
	max_num_width = floor(log10(n_option));
	
    fprintf([indent,question]);
	for i=1:n_option
		num_width = floor(log10(i));
		num_str = ['\n',indent,'[',num2str(i),']',repmat(' ',(max_num_width-num_width))];
		fprintf([num_str,' ',options{i}]);
		space = repmat(' ',1,M_max-M(i)+1);
		if i==default, fprintf([space,'{default <enter>}']); end
    end
    
    fprintf('\n')
    
end