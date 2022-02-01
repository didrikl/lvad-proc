function notes = qc_notes_G1(notes, idSpecs, askToReInit)
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

	mustHaveVars = {
		'intervType'
		'event'
		'pumpSpeed'
		};
	numVarsNotToCheck = {
		'embVol'
		'Q_noted'
		'SvO2'
		'CO_thermo'
		'CO_cont'
		'MAP'
		};

	% Content of event category not to check with idSpecs
	eventsToNotCheck = {
		'-'
		'Echo'
		'Injection'
		'Text note'
		'Thombolysis'
		'Anticoagulant'
		'Calibration'
		};
	
	notChrono = check_chronological_time(notes);
	[natPause, natPart] = check_missing_notes_time(notes);
	misNum = check_missing_numeric_data(notes, numVarsNotToCheck);
	irregParts = check_irregular_notes_parts(notes);
	undefCat = check_missing_essential_info(notes, mustHaveVars);
	irregRows = check_analysis_ids_and_notes(notes, idSpecs, eventsToNotCheck);
	notes = ask_to_reinit_notes(notes, @init_notes_xls, askToReInit, ...
		notChrono, natPause, natPart, undefCat, irregParts, irregRows, misNum);
		
function irregID = check_analysis_ids_and_notes(Notes, idSpecs, eventsToCheckID)
	% Verify event and intervType are always respectively '-' and 'Steady-state'
	
	if height(idSpecs)==0
		irregID = false(height(Notes),1);
		return;
	end
	
	Notes.analysis_id = standardizeMissing(Notes.analysis_id,'-');
	id_inds = not(ismissing(Notes.analysis_id));
	
	irregID = not(contains(string(Notes.event),eventsToCheckID)) & id_inds;
	
	if height(idSpecs)>0
		
		misBLIds = check_for_missing_baseline_ids(Notes);
		irregID = irregID | misBLIds;
	
		check_for_missing_ids_in_data(idSpecs, Notes, id_inds);
		check_for_unlisted_notes_ids(Notes, idSpecs, id_inds);
		
		% Non-matching ID parameters with those in specfication file?
		isOK = check_parameters_with_id_specs(idSpecs, Notes);
		check_baseline_id_ref_integrity(idSpecs, Notes);
		
		notify_about_notes_issues_found(isOK, Notes);
		
	end
	
	if any(irregID)
		fprintf('\nNote rows with analysis ID irregularities:\n\n')
		disp(Notes(irregID,:));
	end
	
function isOK = check_parameters_with_id_specs(idSpecs, Notes)
	isOK = nan(height(idSpecs),1);
	for i=1:height(idSpecs)
		idNote_inds = Notes.analysis_id==idSpecs.analysis_id(i);
		isOK(i) = check_id_parameter_consistency_G1(...
			Notes(idNote_inds,:), idSpecs(i,:));
	end
