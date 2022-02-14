function notes = qc_notes_IV2(notes, idSpecs, askToReInit)
	% qc_notes_IV2 checks notes file intergrity.
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

	% Protocol info that always must be given
	mustHaveVars = {
		'intervType'
		'event'
		'pumpSpeed'
		'balLev'
		'catheter'
		'QRedTarget'
		};
	
	% Variable that are ok to be missing
	numVarsNotToCheck = {
		'Q_noted'
		};

	% Content of event category not to check with idSpecs
	eventsToNotCheck = {
		'-'
		'Text note'
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
		check_for_duplicate_id_rows(Notes, id_inds);
		check_for_unlisted_notes_ids(Notes, idSpecs, id_inds);
		
		% Non-matching ID parameters with those in specfication file?
		isOK = check_parameters_with_id_specs(idSpecs, Notes);
		check_baseline_id_ref_integrity(idSpecs, Notes);
		
		irregSpeed = check_pump_speed_id_consistency(Notes, 2);
		irregID = irregID | irregSpeed;
		isOK = any(isOK) & any(not((irregSpeed)));
	
		notify_about_notes_issues_found(isOK, Notes);
		
	end
	
	if any(irregID)
		fprintf('\nNote rows with analysis ID irregularities:\n\n')
		disp(Notes(irregID,:));
	end

function irregSpeed = check_pump_speed_id_consistency(T, speedDigitPos)
	T.analysis_id(ismissing(T.analysis_id)) = '-';
	T.bl_id(ismissing(T.bl_id)) = '-';

	analysis_id = char(string(T.analysis_id));
	bl_id = char(string(T.bl_id));
	irregSpeed = bl_id(:,speedDigitPos)~=analysis_id(:,speedDigitPos);

	% ignore nominal recording intervals and intervals with only bl_id
	irregSpeed = irregSpeed & analysis_id(:,4)~='0' & analysis_id(:,1)~='-';

	if any(irregSpeed)
		fprintf('\n')
		warning('Inconsistent pump speed id in analysis ID and baseline ID\n')
		if nargout==0
			fprintf('\n')
			disp(T(irregSpeed,:))
		end
	end
		
function isOK = check_parameters_with_id_specs(idSpecs, Notes)
	isOK = nan(height(idSpecs),1);
	for i=1:height(idSpecs)
		idNote_inds = Notes.analysis_id==idSpecs.analysis_id(i);
		isOK(i) = check_id_parameter_consistency_IV2(...
			Notes(idNote_inds,:), idSpecs(i,:));
	end
