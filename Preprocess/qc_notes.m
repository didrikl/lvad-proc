function notes = qc_notes(notes)
    % Checks of Excel file for misssing and chronological time, and that 
    % essential categoric info is not missing
    % * time not missing for intervType equal 'Pause'
    % * time not missing for part with number
    % * time not chronological
    % * part, intervType and event are not undefined (i.e. missing)
    % 
    % (Checks of notes in relation to recorded signal data are not done here.)
    
    welcome('Quality control of notes')
        
    notChrono_ind = check_chronological_time(notes);
    [natPause_inds, natPart_inds] = check_missing_time(notes);
    undefCat_inds = check_missing_part(notes);
    
    if any(notChrono_ind | natPause_inds | natPart_inds | undefCat_inds)
        notes = ask_to_reinit(notes);
    end
    
    fprintf('\nQuality control of notes done.\n')
    
function notes = ask_to_reinit(notes)
    % Pause and let user make changes in Excel and re-initialize
    winopen(notes.Properties.UserData.FilePath);
    answer = ask_list_ui({'Re-initialize', 'Ignore', 'Abort'},...
        sprintf('\nPause: Check and save as new notes file revision'),1);
    if answer==1
        [fileName,filePath] = uigetfile(...
            [notes.Properties.UserData.Path,'\*.xls;*.xlsx;*.xlsm'],...
            'Select notes Excel file to re-initialize');
        % TODO: Make OO, so that correct init_notes version is used
        notes = init_notes_xlsfile_ver3_11(fullfile(filePath,fileName));
    elseif answer==3
        abort;
    end
    
function notChrono_ind = check_chronological_time(notes)
    % Get and display note (set of) rows for which the time is not increasing
    
    notChrono_ind = [diff(notes.time)<0;0];
    if any(notChrono_ind)
        notChrono_rows = find(notChrono_ind);
        for i=1:numel(notChrono_rows)
            fprintf('\nNon-chronological timestamps found:\n\n')
            non_chronological_timestamps = ...
                notes(notChrono_rows(i):notChrono_rows(i)+1,:);
            disp(non_chronological_timestamps);
            %openvar non_chronological_timestamps
        end
    else
        fprintf('\nAll time stamps are chronological')
    end

function [natPause_inds, natPart_inds] = check_missing_time(notes)
    % Get and display essiential note rows with missing time stamps
    
    natPause_inds = isnat(notes.time) & notes.intervType=='Pause';
    natPart_inds = isnat(notes.time) & notes.part~='-'; 
    if any(natPause_inds)
        fprintf('\nTimestamps missing for Pause notes:\n\n')
        missing_pause_timestamps = notes(natPause_inds,:);
        disp(missing_pause_timestamps)
        %openvar missing_pause_timestamps
    end
    if any(natPart_inds)
        fprintf('\nTimestamps missing for Part notes:\n\n')
        missing_part_timestamps = notes(natPart_inds,:);
        disp(missing_part_timestamps)
        %openvar missing_part_timestamps
    end
    
    if not(any(isnat(notes.time)))
        fprintf('\nNo missing time stamps.')
    end
    
function undefCat_inds = check_missing_part(notes)
    % Get and display rows with missing essential categoric info
    
    % NOTE: If OO, then this is notes object property
    mustHaveCats = {'part','intervType','event'};
    
    undefCat_inds = any(isundefined(notes{:,mustHaveCats}),2);
    if any(undefCat_inds)
        fprintf('\n\nEssential categoric info missing:\n\n')
        missing_categories = notes(undefCat_inds,:);
        disp(missing_categories)
        %openvar missing_categories
    else
        fprintf('\nAll rows have essential categoric info')
    end
        
            
    