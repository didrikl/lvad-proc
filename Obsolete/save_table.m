function [savePath, fileName] = save_table(fileNames, savePath, data, fileType, varargin)
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
	% NOTE: Can implement support for several output types

	% Name of the table as it exist in memory
	dataName = inputname(3);

	% If inputs are given as strings, then parse to char for compability
	% TODO: Test support for fileName given as string?
	[savePath, varargin{:}] = convertStringsToChars(savePath, varargin{:});
	fileType = cellstr(fileType);
	fileNames = cellstr(fileNames);
	if numel(fileNames)==1 
		fileNames = repmat(fileNames{1},numel(fileTypes),1);
	end
	% Initialize persistent boolean switches for saving
	persistent overwrite_existing
	persistent ignore_saving_for_existing
	if isempty(overwrite_existing)
		overwrite_existing = false;
	end
	if isempty(ignore_saving_for_existing)
		ignore_saving_for_existing = false;
	end

	fprintf('\nSaving data from workspace to disc: %s\n',dataName)
	for i=1:numel(fileType)
		isOK = check_file_type_input(fileType{i});
		if not(isOK), continue, end

		switch lower(fileType)
			case {'mat','matlab'}
				ext = '.mat';
			case 'text'
				ext = '.txt';
			case 'csv'
				ext = '.csv';
			case 'spreadsheet'
				ext = '.xls';
			case {'fig','figure'}
				ext = '.fig';
		end
		fileName = convertStringsToChars(fileNames{i});
		[subfolder,fileName,extInName] = fileparts(fileName);
		if not(strcmpi(extInName,ext))
			fileName = [fileName,extInName];
		end
		fileName = [fileName,ext];

		savePath = fullfile(savePath,subfolder);

		% Check if there is already an exsisting file with the same fileName in
		% the saving directory path. If there is an exsisting file, then let the
		% user decide what action to do.
		[savePath, fileName, overwrite_existing, ignore_saving_for_existing] = ...
			save_destination_check(savePath, fileName, overwrite_existing, ...
			ignore_saving_for_existing);

		% If cancelled in user interaction, then just return without saving
		if not(fileName)
			warning('No saving done.')
			return;
		end

		filePath = fullfile(savePath,fileName);
		save_data_type(data,filePath,fileName,fileType)
	end

end

function save_data_type(data,filePath,fileName,fileType)

	try
		switch lower(fileType)

			% NOTE: Could support saving structs and appending with new fields
			% and the possibility of overwriting existing fields. It might be
			% already working with varargin
			% TODO: Test saving structs with varargin
			case {'mat','matlab'}

				eval([inputname(3),'=data;']);
				save(filePath,dataName,varargin{:});

			case {'csv'}

				% Saving time tables is not supported in writetable,
				% but will probably not make any difference
				if istimetable(data)
					data = timetable2table(data);
				end
				writetable(data, filePath, 'FileType', 'text', 'Delimiter', 'comma', varargin{:})

			case {'text','spreadsheet'}

				% Saving time tables is not supported in writetable,
				% but will probably not make any difference
				if istimetable(data)
					data = timetable2table(data);
				end
				writetable(data, filePath, 'FileType', fileType, varargin{:})

		end

		display_filename(fileName,savePath,'\nTable saved to file:');

	catch ME
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

end

function isOK = check_file_type_input(fileType)
	% Input validations
	if not(any(strcmpi(fileType,{'mat','matlab','text','csv','spreadsheet','fig','figure'})))
		warning(['Incorrect filetype is given. Type help save_table ',...
			'to see supported file types.'])
	elseif ~isa(data,'table') && ~isa(data,'timetable') && not(strcmpi(fileType,'matlab'))
		warning('Third input argument is not a table or timetable');
	end
end