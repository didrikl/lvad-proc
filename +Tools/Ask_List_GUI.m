function selection = Ask_List_GUI(options, question, default, indent, ~)
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
	%   indent (string):    String formatting to given extra indentation for the
	%                       menu, e.g. '\t\t'
	%
	% If a global variable named CHOOSE_ALWAYS_DEFAULT_IN_OPTION_LIST is defined as
	% true, then the default options is always selected, and thus no user-input from
	% the menu display is possible. This is suitable for e.g. batch processing.
	%
	% See also Ask_List
	
	
	if nargin==5
		Warn('Figure focus when asking for input is not any longer supported');
	end
	if nargin<4
		indent = '';
	end
	if nargin<3
        default = 1;
    end
    
	if nargin<2
		question='';
	end
	
	if ~isa(options,'cell'), options = {options}; end
	if isa(default,'char'), default = str2double(default); end
	
    n_opt_char = max(cellfun(@length,options));
    n_opt = length(options);
    
    listsize = [150,150];
    listsize(1) = listsize(1)*ceil(n_opt_char/28);
    listsize(2) = listsize(2)*ceil(n_opt/9);
    
    question = strrep(strrep(question,'\n',''),'\t','');  
    fprintf('\nUser input required in separate window...\n')   
    [selection, ~] = listdlg(...
        'PromptString',question,...
        'SelectionMode','single',...
        'CancelString','Cancel',...
        'ListString',options,...
        'ListSize',listsize,...
        'InitialValue',default,...
        'Name','User-input required');
    
    % Documenting user selection in command window
    Print_Ask_List_Menu(options, indent, question)
    fprintf('--> %d\n',selection)
    
end

