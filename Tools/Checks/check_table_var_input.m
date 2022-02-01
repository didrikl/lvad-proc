function [vars, removedVars] = check_table_var_input(T, vars)

	persistent always_remove always_ignore
	if isempty(always_remove), always_remove = false; end
	if isempty(always_ignore), always_ignore = false; end

	[returnAsCell,vars] = get_cell(vars);

	removeInds = false(numel(vars),1);
	for i=1:numel(vars)

		if not(ismember(vars{i},T.Properties.VariableNames))

			msg = sprintf('\nVariable %s does not exist\n',vars{i});

			response = [];
			if always_remove
				response = 1;
			elseif always_ignore
				response = 3;
			end

			opts = {
				'Remove from list'
				'Remove from list, always'
				'Ignore, keep as is'
				'Ignore, keep as is, always'
				'Select another name for input variable'
				'Abort'
				};
			if isempty(response)
				response = ask_list_ui(opts,msg);
			end

		if response==1
			removeInds(i) = true;

		elseif response==2
			always_remove = true;
			warning('Always remove (Reset by "clear check_table_var_input")');
			removeInds(i) = true;

		elseif response==3
			% Do nothing

		elseif response==4
			always_ignore = true;
			warning('Always ignore (Reset by "clear check_table_var_input")');

		elseif response==5
			msg2 = sprintf('\n\tSelect which variable to use');
			response2 = ask_list_ui(T.Properties.VariableNames,msg2);
			vars{i} = T.Properties.VariableNames{response2};

		elseif response==6
			abort;
		end
		
	end

end

removedVars = vars(removeInds);
vars = vars(not(removeInds));

if not(returnAsCell), vars = vars{1}; end