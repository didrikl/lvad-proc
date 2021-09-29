function selection = ask_list_ui(options, question, default)
	% User-input menu, that enumerates the options and let the user select a
	% option number.
    %
    % If the user does not select a proper number, then the menu is re-displayed
	% with a message about wrong input. The option selection number is returned.
    % If the user hits the cancel buttom or just closes the question dialouge
    % window, the selection number is set to false.
	%
	% Arguments:
	%   options (cell arr): Text strings with the options written out question
	%   (string):  Menu title/enquiry for the user-input needed (optional)
	%
	% Option arguments:
	%   default (num):      An option number equal to the given default, can be
	%                       selected by just hitting enter (to give a
	%                       better/more efficient user experience) If default
	%                       number will not have a corresponding option number,
	%                       then it will be the same as not having any default
	%                       option. Thus e.g. default=-1 will is a way to say
	%                       that there is no default option.
	
    if nargin<3
        default = [];
        init_val = 1;
    else
        if isa(default,'char'),default = str2double(default); end
        init_val = default;
    end
    if nargin<2
        question='';
    end
	
    % Parse input
	[options,question] = convertStringsToChars(options,question);
    if ~isa(options,'cell'), options = {options}; end
	if isa(default,'char'), default = str2double(default); end
    
    % Validate default spec
    if default>numel(options) | default<1 | not(isfinite(default))    %#ok<OR2>
        warning('Default specification is invalid.')
        default = [];
        init_val = 1;
    end
    
    % Make option list show which is default
    if default
        options{default} = [options{default},' (default)'];
    end
    
    % Set/adjust windows size
    width = 200;
    height = 110;
    n_char_opts = max(cellfun(@length,options));
    n_char_question = max(cellfun(@length,strsplit(question,'\n')));
    n_char = max(n_char_opts,n_char_question);
    width = max(width,n_char*6);
    height = max(height,height*(numel(options)/7.2));
    
    % Splitting into cell array, so that enough space is made for the question
    % (prompt diaglouge).
    prompt_string = strsplit(question,'\n',"CollapseDelimiters",false);
    
    disp(question);
	fprintf('\t(User input required in popup window...)\n')   
    [selection, ~] = listdlg(...
        'PromptString',prompt_string,...
        'SelectionMode','single',...
        'OKString','Select',...
        'CancelString','Cancel',...
        'ListString',options,...;
        'ListSize',[width, height],...
        'InitialValue',init_val,...
        'Name','Input required');
	
    % Documenting user selection in command window
    print_ask_list_menu(options, default)
    fprintf('\t--> %d\n',selection)
    if isempty(selection)
        fprintf('\n\tCancelled\n')
        selection = false;
    end
    
end

function print_ask_list_menu(options, default)
	
    if isstring(options)
        options = char(options); 
    end
    
	n_option = length(options);
	M = zeros(n_option,1);
	for i=1:n_option, M(i) = length(options{i}); end
	M_max = max(M);
	max_num_width = floor(log10(n_option));
	
    for i=1:n_option
		num_width = floor(log10(i));
		num_str = ['\n\t[',num2str(i),']',repmat(' ',(max_num_width-num_width))];
        if i==default, options{i} = strrep(options{i},'(default)',''); end
        fprintf([num_str,' ',strrep(options{i},'\','\\')]);
		space = repmat(' ',1,M_max-M(i)+1);
		if i==default, fprintf([space,'{default <enter>}']); end
    end
    
    fprintf('\n')
    
end



