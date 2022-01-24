function notes = qc_notes_ver4(notes, idSpecs, askToReInit)
	% QC_NOTES_VER4 checks notes file intergrity.
	%
	% Checks and displays rows of notes file that have
	% * timestamps that are not chronological
	% * misssing time stamp
	%   (timestamps without explicit dates given are missing)
	% * missing essential categoric info
	% * timestamps missing for start of pauses
	%   (first of consequtive rows of intervType=='Pause'
	% * time not missing for irregular segment part order
	%
	% (Timestamp validation against recorded data is not done.)
	
	welcome('Quality control of Notes')
	
	if nargin<3, askToReInit = true; end
	if nargin<2
		warning('No ID parameter specfications given, thus not checked');
		idSpecs = table;
	end
	
	% NOTE: If OO, then this is notes object property
	mustHaveVars = {
		'intervType'
		'event'
		'pumpSpeed'
		};
	numVarsNotToCheck = {
		'Q_noted'
		};
	
	notChrono = check_chronological_time(notes);
	[natPause, natPart] = check_missing_time(notes);
	misNum = check_missing_numeric_data(notes,numVarsNotToCheck);
	irregParts = check_irregular_parts(notes);
	undefCat = check_missing_essential_info(notes,mustHaveVars);
	
	irregRowsWithID = check_analysis_ids(notes,idSpecs);
	
	if any(notChrono | natPause | natPart | undefCat | irregParts | ...
			irregRowsWithID | misNum)
		if askToReInit
			notes = ask_to_reinit(notes, notChrono, natPause, natPart, ...
				undefCat, irregParts, irregRowsWithID, misNum);
		end
	else
		fprintf('\n\nAll good :-)')
	end
	
	fprintf('\nQuality control of notes done.\n')
	
function misNum = check_missing_numeric_data(notes, numVarsNotToCheck)
	notes(:,numVarsNotToCheck) = [];
	misNum = any(notes{:,vartype('numeric')}==-9999,2) & ...
		contains(string(notes.intervType),{'steady','baseline'},'IgnoreCase',true);
	
function irregID = check_analysis_ids(Notes, idSpecs)
	% Verify event and intervType are always respectively '-' and 'Steady-state'
	
	if height(idSpecs)==0
		irregID = false(height(Notes),1);
		return;
	end
	
	analyse_events = {'-'};
	Notes.analysis_id = standardizeMissing(Notes.analysis_id,'-');
	id_inds = not(ismissing(Notes.analysis_id));
	
	% Any id-rows not as steady-state/baseline?
	% unique(Notes.intervType(id_inds))
	
	irregID = not(ismember(Notes.event,analyse_events)) & id_inds;
	
	% TODO: Make separate funcions for IV2 and G1
	if height(idSpecs)>0
		
		irregID = check_for_missing_baseline_ids(Notes, irregID);
		
		check_for_missing_ids_in_data(idSpecs, Notes, id_inds);
		%check_for_duplicate_id_rows(Notes, id_inds);
		check_for_unlisted_ids(Notes, idSpecs, id_inds);
		
		% Non-matching ID parameters with those in specfication file?
		for i=1:height(idSpecs)
			idNote_inds = Notes.analysis_id==idSpecs.analysis_id(i);
			isOK(i) = check_id_parameter_consistency_IV2(Notes(idNote_inds,:), idSpecs(i,:));
			
			if numel(unique(Notes.bl_id(idNote_inds)))>1
				warning('There are disparate baseline IDs in Notes with same Analysis ID')
			end
			
		end
		
		%[isOK(i), irregID] = check_pump_speed_id_consistency(Notes, irregID, 2);
		
		notify_about_issues_found(isOK, Notes);
		
	end
	
	if any(irregID)
		fprintf('\nNote rows with analysis ID irregularities:\n\n')
		disp(Notes(irregID,:));
	end
	
function notes = ask_to_reinit(notes, isNotChrono, isNatPause, isNatPart, ...
		isUndefCat, isIrregPart, irregIDs, misNum)
	% Pause and let user make changes in Excel and re-initialize
	%input(sprintf('\nHit a key to open notes sheet --> '));
	
	filePath = notes.Properties.UserData.FilePath;
	fileName = notes.Properties.UserData.FileName;
	
	msg = '';
	if any(isNotChrono)
		msg=[msg,'\nNon-chronical timestamps at row(s): ',...
			mat2str(notes.noteRow(find(isNotChrono)))];
	end
	if any(isNatPause)
		msg=[msg,'\nMissing timestamps at start of pauses at row(s): ',...
			mat2str(notes.noteRow(find(isNatPause)))];
	end
	if any(isNatPart)
		msg=[msg,'\nMissing timestamps at within parts at row(s): ',...
			mat2str(notes.noteRow(find(isNatPart)))];
	end
	if any(isUndefCat)
		msg=[msg,'\nMissing essential categoric info at row(s): ',...
			mat2str(notes.noteRow(find(isUndefCat)))];
	end
	if any(isIrregPart)
		msg=[msg,'\nIrregular part numbering order at row(s): ',...
			mat2str(notes.noteRow(find(isIrregPart)))];
	end
	if any(isIrregPart)
		msg=[msg,'\nIrregular part numbering order at row(s): ',...
			mat2str(notes.noteRow(find(isIrregPart)))];
	end
	if any(irregIDs)
		msg=[msg,'\nIrregular analysis IDs or corresponding event entries at row(s): ',...
			mat2str(notes.noteRow(find(irregIDs)))];
	end
	if any(misNum)
		msg=[msg,'\nMissing numerical note(s) at row(s): ',...
			mat2str(notes.noteRow(find(misNum)))];
	end
	
	winopen(filePath);
	if not(isempty(msg)) 
		fprintf('\n<strong>Issues to revise in notes Excel file</strong>')
	end
	
	opts = {
		['Re-initialize, same filename (',fileName,')']
		'Re-initialize, new filename'
		'Ignore'
		'Abort'
		};
	answer = ask_list_ui(opts,sprintf(msg),1);
	
	if answer==1
		varMapFile = get_var_map_filename_from_userdata(notes);
		notes = init_notes_xlsfile_ver4(filePath,'',varMapFile);
	elseif answer==2
		varMapFile = get_var_map_filename_from_userdata(notes);
		[fileName,filePath] = uigetfile(...
			[notes.Properties.UserData.Path,'\*.xls;*.xlsx;*.xlsm'],...
			'Select notes Excel file to re-initialize');
		% TODO: Make OO, so that correct init_notes version is used
		notes = init_notes_xlsfile_ver4(fullfile(filePath,fileName),'',varMapFile);
	elseif answer==3
		% Do nothing
	elseif answer==4
		abort;
	end
	
function varMapFile = get_var_map_filename_from_userdata(notes)
	if isfield(notes.Properties.UserData,'VarMapFile')
		varMapFile = notes.Properties.UserData.VarMapFile;
	else
		error('Var map filename is not stored in Notes.Properties.UserData')
	end
	
function isIrregularParts = check_irregular_parts(notes)
	% Part categories must be positive integer in increasing order, as they are
	% used in creating cell array of timetables for each part, for which the
	% indices would correspond to the part numbering.
	
	notes_parts = notes(notes.part~='-',:);
	parts = str2double(string(notes_parts.part));
	
	irregularParts_ind = find(diff(parts)<0)+1;
	if any(irregularParts_ind)
		fprintf('\nIrregular decreasing parts numbering found:\n\n')
		notes_parts(irregularParts_ind,:)
	end
	
	nonPosInt_ind = find(mod(not(isnan(parts)),1));
	if any(nonPosInt_ind)
		fprintf('\nNon positiv integer parts numbering found:\n\n')
		notes_parts(nonPosInt_ind,:)
	end
	
	isIrregularParts = false(height(notes),1);
	isIrregularParts(irregularParts_ind) = true;
	isIrregularParts(nonPosInt_ind) = true;
	
function isNotChrono = check_chronological_time(notes)
	% Get and display note (set of) rows for which the time is not increasing
	
	isNotChrono = [diff(notes.time)<0;0];
	if any(isNotChrono)
		notChrono_rows = find(isNotChrono);
		fprintf('\nNon-chronological timestamps found:\n\n')
		for i=1:numel(notChrono_rows)
			non_chronological_timestamps = ...
				notes(notChrono_rows(i):notChrono_rows(i)+1,:);
			disp(non_chronological_timestamps);
		end
	else
		fprintf('\nAll time stamps are chronological')
	end
	
function [isNatPauseStart, isMissingTimestamp] = check_missing_time(notes)
	% Get and display essiential note rows with missing time stamps
	
	natPause_rows = find(isnat(notes.time) & notes.intervType=='Pause');
	first_part_row = find(notes.part~='-',1,'first');
	natPause_rows = natPause_rows(natPause_rows>first_part_row);
	natPauseStart_rows = natPause_rows(notes.intervType(natPause_rows-1)~='Pause');
	isPart = notes.part~='-' & not(isundefined(notes.part));
	
	% All pause intervals should start with a timestamp
	if any(natPauseStart_rows)
		fprintf('\nTimestamps missing for start of pauses:\n\n')
		missing_pause_timestamps = notes(natPauseStart_rows,:);
		disp(missing_pause_timestamps)
	end
	isNatPauseStart = false(height(notes),1);
	isNatPauseStart(natPauseStart_rows)=true;
	
	% Check for missing timestamps at rows associated with a recording part,
	% but not because of missing date info
	isMissingTimestamp = isnat(notes.time) & isPart;
	if any(isMissingTimestamp)
		fprintf('\nTimestamps missing for part-defined rows:\n\n')
		missing_part_timestamps = notes(isMissingTimestamp,:);
		disp(missing_part_timestamps)
	end
	
	
function isUndefCat = check_missing_essential_info(notes, mustHaveCats)
	% Get and display rows with missing essential categoric info
	
	isUndefCat = any(ismissing(notes(:,mustHaveCats)),2);
	if any(isUndefCat)
		fprintf('\n\nEssential categoric info missing:\n\n')
		missing_categories = notes(isUndefCat,:);
		disp(missing_categories)
	end
	
function check_for_unlisted_ids(Notes, idSpecs, id_inds)
	extraIDs = not(ismember(Notes.analysis_id,idSpecs.analysis_id)) & id_inds;
	if any(extraIDs)
		fprintf('\n\nExtra analysis IDs that are not defined:\n\n');
		disp(Notes(extraIDs,:))
	end

function check_for_duplicate_id_rows(Notes, id_inds)
	[~, dups] = find_cellstr_duplicates(cellstr(Notes.analysis_id(id_inds)));
	if not(isempty(dups))
		dup_inds = ismember(Notes.analysis_id,dups);
		fprintf('\n\n\tDuplicate IDs:\n\t\t%s\n\n',strjoin(unique(dups),'\n\t\t'))
		disp(Notes(dup_inds,:))
	end
	
function check_for_missing_ids_in_data(idSpecs, Notes, id_inds)
	misIDs = not(ismember(idSpecs.analysis_id,Notes.analysis_id(id_inds)))...
		& not(idSpecs.contingency);
	if any(misIDs)
		fprintf('\n\nMissing analysis IDs defined as:\n\n');
		disp(idSpecs(misIDs,:))
	end
	
function irregID = check_for_missing_baseline_ids(Notes, irregID)
	% check for any rows with analysis_id, but without baseline_id
	% (Vice-versa, baseline_id without analysis_id is ok.)
	misBaselineIds = ismissing(Notes.bl_id);
	if any(misBaselineIds)
		fprintf('\n')
		warning(sprintf('\n\tMissing baseline IDs at rows %s\n',...
			mat2str(Notes.noteRow(misBaselineIds))));
		irregID = irregID | misBaselineIds;
	end
	
function notify_about_issues_found(isOK, Notes)
	if any(not(isOK))
		opts = struct('WindowStyle','non-modal','Interpreter','none');
		msg = sprintf('ID parameter issues detected in Notes.\n\n%s\n',...
			display_filename(Notes.Properties.UserData.FilePath));
		warndlg(msg,'Warning, Notes',opts)
	end
