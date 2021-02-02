function notes = qc_notes_ver4(notes)
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
    
    welcome('Quality control of notes')
    
    % NOTE: If OO, then this is notes object property
    mustHaveVars = {
        %'part'
        'intervType'
        'event'
        'pumpSpeed'
        };
    
    isNotChrono = check_chronological_time(notes);
    [isNatPause, isNatPart] = check_missing_time(notes);
    isIrregParts = check_irregular_parts(notes);
    isUndefCat = check_missing_essential_info(notes,mustHaveVars);
    
    if any(isNotChrono | isNatPause | isNatPart | isUndefCat | isIrregParts)
        notes = ask_to_reinit(notes, isNotChrono, isNatPause, isNatPart, isUndefCat, isIrregParts);
    else
        fprintf('\n\nAll good :-)')
    end
    
    fprintf('\nQuality control of notes done.\n')
    
function notes = ask_to_reinit(notes, isNotChrono, isNatPause, isNatPart, isUndefCat, isIrregPart)
    % Pause and let user make changes in Excel and re-initialize
    %input(sprintf('\nHit a key to open notes sheet --> '));
    
    filePath = notes.Properties.UserData.FilePath;
    fileName = notes.Properties.UserData.FileName;
    winopen(filePath);
    opts = {
        ['Re-initialize, same filename (',fileName,')']
        'Re-initialize, new filename'
        'Ignore'
        'Abort'
        };
    msg = '\nQuality control of notes found issues\n';
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
    msg = sprintf([msg,'\n\nCheck and save as new notes file revision']);
    
    answer = ask_list_ui(opts,msg,1);
    if answer==1
        notes = init_notes_xlsfile_ver4(filePath);
    elseif answer==2
        [fileName,filePath] = uigetfile(...
            [notes.Properties.UserData.Path,'\*.xls;*.xlsx;*.xlsm'],...
            'Select notes Excel file to re-initialize');
        % TODO: Make OO, so that correct init_notes version is used
        notes = init_notes_xlsfile_ver4(fullfile(filePath,fileName));
    elseif answer==3
        % Do nothing
    elseif answer==4
        abort;
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

    
function isUndefCat = check_missing_essential_info(notes,mustHaveCats)
    % Get and display rows with missing essential categoric info
    
    isUndefCat = any(ismissing(notes(:,mustHaveCats)),2);
    if any(isUndefCat)
        fprintf('\n\nEssential categoric info missing:\n\n')
        missing_categories = notes(isUndefCat,:);
        disp(missing_categories)
    end
    
    