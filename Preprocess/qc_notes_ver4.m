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
    mustHaveCats = {'part','intervType','event'};
    
    isNotChrono = check_chronological_time(notes);
    [isNatPause, isNatPart] = check_missing_time(notes);
    isIrregParts = check_irregular_parts(notes);
    isUndefCat = check_missing_essential_info(notes,mustHaveCats);
    
    if any(isNotChrono | isNatPause | isNatPart | isUndefCat | isIrregParts)
        notes = ask_to_reinit(notes);
    else
        fprintf('\n\nAll good :-)')
    end
    
    fprintf('\nQuality control of notes done.\n')
    
function notes = ask_to_reinit(notes)
    % Pause and let user make changes in Excel and re-initialize
    input(sprintf('\nHit a key to open notes sheet --> '));
    filePath = notes.Properties.UserData.FilePath;
    fileName = notes.Properties.UserData.FileName;
    winopen(filePath);
    
    opts = {
        ['Re-initialize, with same filename (',fileName,')']
        'Re-initialize, with new filename'
        'Ignore'
        'Abort'
        };
    msg = sprintf('\nCheck and save as new notes file revision');
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
    notes_parts = notes(notes.part~='-',:);
    parts = str2double(string(notes_parts.part));
    irregularParts_ind = find(diff(parts)<0)+1;
    if any(irregularParts_ind)
        fprintf('\nIrregular decreasing parts numbering found:\n\n')
        notes_parts(irregularParts_ind,:)
    end
    isIrregularParts = false(height(notes),1);
    isIrregularParts(irregularParts_ind) = true;
    
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

function [isNatPauseStart, isNatPart] = check_missing_time(notes)
    % Get and display essiential note rows with missing time stamps
    
    natPause_rows = find(isnat(notes.time) & notes.intervType=='Pause');
    first_part_row = find(notes.part~='-',1,'first');
    natPause_rows = natPause_rows(natPause_rows>first_part_row);
    natPauseStart_rows = natPause_rows(notes.intervType(natPause_rows-1)~='Pause');
    
    if any(natPauseStart_rows)
        fprintf('\nTimestamps missing for start of pauses:\n\n')
        missing_pause_timestamps = notes(natPauseStart_rows,:);
        disp(missing_pause_timestamps)
    end
    isNatPauseStart = false(height(notes),1);
    isNatPauseStart(natPauseStart_rows)=true;
    
    isNatPart = isnat(notes.time) & notes.part~='-';
    if any(isNatPart)
        fprintf('\nTimestamps missing for Part notes:\n\n')
        missing_part_timestamps = notes(isNatPart,:);
        disp(missing_part_timestamps)
    end
    
    if not(any(isnat(notes.time)))
        fprintf('\nNo missing time stamps.')
    end
    
function isUndefCat = check_missing_essential_info(notes,mustHaveCats)
    % Get and display rows with missing essential categoric info
    
    isUndefCat = any(isundefined(notes{:,mustHaveCats}),2);
    if any(isUndefCat)
        fprintf('\n\nEssential categoric info missing:\n\n')
        missing_categories = notes(isUndefCat,:);
        disp(missing_categories)
    else
        fprintf('\nAll rows have essential categoric info')
    end
        
            
    