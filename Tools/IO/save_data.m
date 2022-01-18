function [savePath, fileName] = save_data(fileNames, savePath, data, types, varargin)
	% SAVE_TABLE
	% Write Matlab table to text files, using writetable, with convenient
	% user interactions.
	%
	% Usage:
	%   save_table(fileName, path, data, filetype, varargin)
	%
	% Input:
	%   filetype must be either
	%       'matlab' for saving to binary .mat file
	%       'spreadsheet' for saving to Excel file
	%       'text' for saving to ascii text file
	%   varargin is used for additional parameter options for filetype is
	%       either 'text' or 'spreadsheet'.
	%
	% Check if there is already an exsisting file with the same fileName in
	% the saving directory path. If there is an exsisting file, then let the
	% user decide what action to do. The persistent variables
	% overwrite_existing og ignore_saving_for_existing allows the program to
	% remember choices goverening future action, in case there is an existing
	% file.
	%
	% See also writetable, save_destination_check, timetable2table

	% Note that save_path is handled as a separate input, instead of the
	% possiblity to be baked into the fileName. This help to avoid unintendent
	% saving in current working directory.

	% NOTE: Can make a new expanded function that also saves figures, using the
	%       same framework
	% TODO: Save multiple data in multiple filenames
	
	% Name of the table as it exist in memory
	dataName = inputname(3);
	if isempty(dataName) 
		dataName = genvarname(fileNames);
		warning(['Data input is a struct field in the caller. ',...
			'Unable to retrieve its name for storage. ',...
			'Data is stored as: ',dataName]);
	end

	% If inputs are given as strings, then parse to char for compability
	[types,fileNames,savePath] = parse_inputs(types,fileNames,savePath);
	
	% Initialize persistent boolean switches for saving
	persistent overwrite_existing
	persistent ignore_save_existing
	if isempty(overwrite_existing), overwrite_existing = false; end
	if isempty(ignore_save_existing), ignore_save_existing = false; end

	fprintf('\nSaving data from workspace to disc: %s\n',dataName)
	for i=1:numel(types)

		isOK = check_inputs(types{i},data);
		if not(isOK), continue, end
		[fileName,savePath] = make_save_destination(savePath,fileNames{i},types{i});

		% Check if there is already an exsisting file with the same fileName in
		% the saving directory path. If there is an exsisting file, then let the
		% user decide what action to do.
		[savePath, fileName, overwrite_existing, ignore_save_existing] = ...
			save_destination_check(savePath, fileName, overwrite_existing, ...
			ignore_save_existing);
		
		% If cancelled in user interaction, then just return without saving
		if not(fileName)
			warning('Saving cancelled.')
			return;
		end

		save_data_type(savePath,fileName,data,dataName,types{i})
	end

end

function save_data_type(savePath,fileName,data,dataName,fileType,varargin)
	
	filePath = fullfile(savePath,fileName);
	data = data;
	try
		
		switch lower(fileType)

			% NOTE: Could support saving structs and appending with new fields
			% and the possibility of overwriting existing fields. It might be
			% already working with varargin
			case {'mat','matlab'}

				eval([dataName,'=data;']);
				save(filePath,dataName,varargin{:});

			case {'csv'}

				% Saving time tables is not supported in writetable,
				% but will probably not make any difference
				if istimetable(data)
					data = timetable2table(data);
				end
				writetable(data,filePath,'FileType','text','Delimiter','comma', varargin{:})

			case {'text','spreadsheet'}

				% Saving time tables is not supported in writetable,
				% but will probably not make any difference
				if istimetable(data)
					data = timetable2table(data);
				end
				writetable(data,filePath,'FileType',fileType,varargin{:})

		end

		display_filename(fileName,savePath,'\nTable saved to file:');

	catch ME
		display_error_msg(ME,fileName)
	end

end

function display_error_msg(ME,fileName)
	msg = sprintf('\nNo data saved for %s\n',display_filename(fileName,''));
	if strcmp(ME.identifier,'MATLAB:table:write:FileOpenInAnotherProcess')
		warning([msg,'File is open in another process.']);
	elseif strcmp(ME.identifier,'MATLAB:table:write:FileOpenError')
		warning([msg,'Could not open/create file for saving.']);
	elseif strcmp(ME.identifier,'MATLAB:table:write:DataExceedsSheetBounds')
		disp(ME)
		warning([msg,'Table has too many columns (max. 256) or rows to be saved as spreadsheet'])
	else
		disp(ME)
		warning(msg)
	end
end

function isOK = check_inputs(fileType,data)
	isOK = true;
	% Input validations
	if not(any(strcmpi(fileType,{'mat','matlab','text','csv','spreadsheet','fig','figure'})))
		warning(['Incorrect filetype is given. Type help save_table ',...
			'to see supported file types.'])
		isOK = false;
	elseif ~isa(data,'table') && ~isa(data,'timetable') ...
			&& any(strcmpi(fileType,{'text','csv','spreadsheet'}))
		warning('Third input argument is not a table or timetable');
		isOK = false;
	elseif ishandle(data) && any(strcmpi(fileType,{'fig','figure'}))
		warning('Third input argument is not a figure handle');
		isOK = false;
	end
end

function ext = get_file_type_ext(fileType)
	switch lower(fileType)
		case 'matlab'
			ext = '.mat';
		case 'text'
			ext = '.txt';
		case 'spreadsheet'
			ext = '.xls';
		case 'figure'
			ext = '.fig';
		otherwise
			ext = ['.',fileType];
	end
end

function [fileName,savePath] = make_save_destination(savePath,fileName,fileType)
	ext = get_file_type_ext(fileType);
	[subfolder,fileName,extInName] = fileparts(fileName);
	if not(strcmpi(extInName,ext))
		fileName = [fileName,extInName];
	end
	fileName = [fileName,ext];
	savePath = fullfile(savePath,subfolder);
end

function [fileTypes, fileNames, savePath] = parse_inputs(fileTypes, fileNames, savePath)
	fileTypes = cellstr(fileTypes);
	fileNames = cellstr(fileNames);
	if numel(fileNames)==1
		fileNames = repmat(fileNames(1),numel(fileTypes),1);
	elseif numel(fileNames)~=numel(fileTypes)
		error('Number of fileNames must eqal the number of fileTypes or one')
	end
	[savePath, fileTypes{:}] = convertStringsToChars(savePath, fileTypes{:});
end