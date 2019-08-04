function selection = ask_list_ui(options, question, default)
	% User-input menu, that enumerates the options and let the user select a option
	% number. It user does not select a proper number, then the menu is re-displayed
	% with a message about wrong input. The option selection number is returned.
	%
	% Arguments:
	%   options (cell arr): Text strings with the options written out
	%   question (string):  Menu title/enquiry for the user-input needed (optional)
	%
	% Option arguments:
	%   default (num):      An option number equal to the given default, can be
	%                       selected by just hitting enter (to give a better/more
	%                       efficient user experience) If default number will not
	%                       have a corresponding option number, then it will be the
	%                       same as not having any default option. Thus e.g.
	%                       default=-1 will is a way to say that there is no default
	%                       option.
	%
	% See also Print_Ask_List_Menu
	
    % TODO: Use varargin and input parsing for default and for selection mode
    
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
    if default>numel(options) | default<1 | not(isfinite(default))   
        warning('Default specification is invalid.')
        default = [];
        init_val = 1;
    end
    
    % Make option list show which is default
    if default
        options{default} = [options{default},' (default)'];
    end
    
    % Set/adjust windows size
    width = 220;
    height = 100;
    n_opt_char = max(cellfun(@length,options));
    width = max(width,width*n_opt_char/55);
    height = max(height,height*(numel(options)/7.2));
    
    question = {'';question;'';''};
    fprintf('\nUser input required in separate window...\n')   
    [selection, ~] = listdlg(...
        'PromptString',question,...
        'SelectionMode','single',...
        'OKString','Select',...
        'CancelString','Cancel',...
        'ListString',options,...
        'ListSize',[width, height],...
        'InitialValue',init_val,...
        'Name','Input required');
    
    % Documenting user selection in command window
    print_ask_list_menu(options, '', question)
    fprintf('--> %d\n',selection)
    
end

function print_ask_list_menu(options, indent, question, default)
	
    if nargin<4, default=0; end
    
	% If question is given as cell, then it is likely it was contructed for GUI
	% mode and multiline print, and thus a conversion to regular string is
	% neccessary.
	if iscell(question), question = strjoin(question,[indent,'\n']); end
	if isstring(options), options = char(options); end
    
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



