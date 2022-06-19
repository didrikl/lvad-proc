function T_parts = add_in_parts(fnc,T_parts,inVars,outVars,varargin)
	% Checks calculation input and output variable name existence in timetable,
	% with formatted info displayed in the commnand window.
	%
	% In case input does not exist, relevant options are given to user,
	% according to the function check_table_var_input.
	%
	% In case output already exist, relevant options are given to user according
	% to the function check_table_var_output.
	%
	% User selected option may be persistent for all parts, and options are
	% reset once all the parts are processed.
	%
	% See also check_table_var_input, check_table_var_output

	% NOTE: This function could e.g. be made generic or common in master class.
	% Function handle can then be passed as input
	
	if is_in_parallel
		T_parts = add_without_ui(fnc, T_parts, inVars, outVars, varargin{:});
	else
		T_parts = add_with_ui(fnc, T_parts, inVars, outVars, varargin{:});
	end
end

function T_parts = add_without_ui(fnc,T_parts,inVars,outVars,varargin)
	welcome(['Running: ',func2str(fnc)],'iteration');
	for i=1:numel(T_parts)
		if height(T_parts{i})==0
			warning('Empty part: %d',i)
			continue;
		end
		T_parts{i} = fnc(T_parts{i},inVars,outVars,varargin{:});
	end
end

function T_parts = add_with_ui(fnc,T_parts,inVars,outVars,varargin)

	[returnAsCellOutput,outVars] = get_cell(outVars);
	[returnAsCellInput,inVars] = get_cell(inVars);

	waitStr = ['Running: ',func2str(fnc)];
	multiWaitbar(waitStr,0);

	for i=1:numel(T_parts)

		if numel(T_parts)>1
			welcome(sprintf('Part %d',i),'iteration')
			waitStr = ['Running: ',func2str(fnc)];
			multiWaitbar(waitStr,(i-1)/numel(T_parts));
		end

		if height(T_parts{i})==0
			fprintf(newline)
			welcome(sprintf('Part %d',i),'iteration')
			warning('Empty part')
			continue;
		end

		[inVarsChecked,remVars] = check_table_var_input(T_parts{i}, inVars);
		if not(isempty(remVars))
			fprintf('\n')
			warning('%s is not added in part %d',strjoin(remVars,', '),i)
			continue;
		end

		outVarsChecked = check_table_var_output(T_parts{i}, outVars);
		isNoOutput = cellfun(@isempty,inVarsChecked);
		if all(isNoOutput)
			fprintf('\n')
			warning('%s is not added in part %d',strjoin(outVars,', '),i)
			continue
		elseif any(isNoOutput)
			fprintf('\n')
			warning('%s is not added in part %d',...
				strjoin(outVars(outVars),', '),i)
		end

		if not(returnAsCellOutput), outVarsChecked = outVarsChecked{1}; end
		if not(returnAsCellInput), inVarsChecked = inVarsChecked{1}; end
		T_parts{i} = fnc(T_parts{i},inVarsChecked,outVarsChecked,varargin{:});

	end
	clear check_table_var_output check_table_var_input

	%dbs = dbstack;
	%fprintf('\n%s done.\n',dbs(end).name);
	fprintf('\n')
	multiWaitbar(waitStr,'Close');
end

function answer = is_in_parallel()
	try
		answer = ~isempty(getCurrentTask());
	catch err
		if ~strcmp(err.identifier, 'MATLAB:UndefinedFunction')
			rethrow(err);
		end
		answer = false;
	end
end
