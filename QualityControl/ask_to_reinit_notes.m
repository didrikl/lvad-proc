function notes = ask_to_reinit_notes(notes, fnc, ask, notChrono, natPause, natPart, ...
		undefCat, irregPart, irregID, misNum)
	% Pause and let user make changes in Excel and re-initialize
	%input(sprintf('\nHit a key to open notes sheet --> '));

	if not(any(notChrono | natPause | natPart | undefCat | irregPart ...
			| misNum | irregID))
		fprintf('\nAll good :-)\n')
		return
	elseif not(ask)
		return;
	end

	filePath = notes.Properties.UserData.FilePath;
	fileName = notes.Properties.UserData.FileName;

	msg = '';
	if any(notChrono)
		msg=[msg,'\nNon-chronical timestamps at row(s): ',...
			mat2str(notes.noteRow(find(notChrono)))];
	end
	if any(natPause)
		msg=[msg,'\nMissing timestamps at start of pauses at row(s): ',...
			mat2str(notes.noteRow(find(natPause)))];
	end
	if any(natPart)
		msg=[msg,'\nMissing timestamps at within parts at row(s): ',...
			mat2str(notes.noteRow(find(natPart)))];
	end
	if any(undefCat)
		msg=[msg,'\nMissing essential categoric info at row(s): ',...
			mat2str(notes.noteRow(find(undefCat)))];
	end
	if any(irregPart)
		msg=[msg,'\nIrregular part numbering order at row(s): ',...
			mat2str(notes.noteRow(find(irregPart)))];
	end
	if any(irregPart)
		msg=[msg,'\nIrregular part numbering order at row(s): ',...
			mat2str(notes.noteRow(find(irregPart)))];
	end
	if any(irregID)
		msg=[msg,'\nIrregular analysis IDs or corresponding event entries at row(s): ',...
			mat2str(notes.noteRow(find(irregID)))];
	end
	if any(misNum)
		msg=[msg,'\nMissing numerical note(s) at row(s): ',...
			mat2str(notes.noteRow(find(misNum)))];
	end

	winopen(filePath);
	if not(isempty(msg))
		fprintf('\n<strong>Issues to revise in notes Excel file</strong>')
	end

	notes = user_interaction(fileName, msg, notes, fnc, filePath);

function varMapFile = get_var_map_filename_from_userdata(notes)
	if isfield(notes.Properties.UserData,'VarMapFile')
		varMapFile = notes.Properties.UserData.VarMapFile;
	else
		error('Var map filename is not stored in Notes.Properties.UserData')
	end

function notes = user_interaction(fileName, msg, notes, fnc, filePath)
	opts = {
		['Re-initialize, same filename (',fileName,')']
		'Re-initialize, new filename'
		'Ignore'
		'Abort'
		};
	answer = ask_list_ui(opts,sprintf(msg),1);
	
	if answer==1
		varMapFile = get_var_map_filename_from_userdata(notes);
		notes = fnc(filePath, '', varMapFile);
	elseif answer==2
		varMapFile = get_var_map_filename_from_userdata(notes);
		[fileName,filePath] = uigetfile(...
			[notes.Properties.UserData.Path,'\*.xls;*.xlsx;*.xlsm'],...
			'Select notes Excel file to re-initialize');
		notes = fnc(fullfile(filePath,fileName),'',varMapFile);
	elseif answer==3
		% Do nothing
	elseif answer==4
		abort;
	end
