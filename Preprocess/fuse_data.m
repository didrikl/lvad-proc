function S = fuse_data(Notes,PL,US,InclInterRowsInFusion)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables
    
    if nargin<3, US = table; end
    if nargin<4, InclInterRowsInFusion=false; end
    
    welcome('Data fusion')
    
    [returnAsCell,PL] = get_return_type(PL);
    
    % Loop over each stored PowerLab file
    %    h_wait = waitbar(0,'','Name','Data fusion...');
    n_files = numel(PL);
    
    % Notes without timestamps can be used in data fusion
    Notes = Notes(not(isnat(Notes.time)),:);
    
    Blocks = cell(n_files,1);
    block_inds = cell(n_files,1);
    for i=1:n_files
        
        fprintf('\n<strong>PowerLab block (no %d/%d): </strong>\nFilename: %s\n',...
            i,n_files,PL{i}.Properties.UserData.FileName)

        [Blocks, block_inds] = determine_notes_block(Notes,PL{i},i,n_files,Blocks,block_inds,InclInterRowsInFusion);
        
        
        % Union merging PowerLab timetable with notes
        if isempty(Blocks{i})
            warning('No notes for PowerLab file')
        else
            
            % Check for overlapping blocks
            % ...
            
            PL{i} = PL{i}(PL{i}.time>=Blocks{i}.time(1) & ...
                PL{i}.time<=Blocks{i}.time(end),:);
        end
        PL_i = PL{i};
        B_i = Blocks{i};
        PL{i} = fuse_timetables(PL_i,B_i);
        
        
        
        % Ultrasound is clipped to time range of B and notes, only (i.e. not
        % clipping of B to achive a union of the two time ranges)
        fprintf('\n\nFusion with ultrasound')
        if isempty(US) || height(US)==0
            fprintf('\n');
            warning('No ultrasound data for PowerLab file')
            continue;
        end
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        PL{i} = fuse_timetables(PL{i},US_block);
        
        fprintf(newline)
    end
    
    try
        S = merge_table_blocks(PL);
    catch
        warning('Out of memory. Trying now with a cell array split...')
        S1 = merge_table_blocks(PL(1:floor(n_files/2)));
        PL(1:floor(n_files/2)) = [];
        S2 = merge_table_blocks(PL);
        S = merge_table_blocks(S1,S2);
        clear S1 s2
    end
        
    clear fuse_timetables
    %    close(h_wait)
    
end

function [B,block_inds] = determine_notes_block(Notes,PL_i,i,n_files,B,block_inds,InclInterRowsInFusion)
    
    % NOTE: Make block_inds, B and i persitent variables instead?
    
    % Extract notes block associated with PL file
    block_step = NaN;
    if n_files==1
        block_inds{i} = 1:height(Notes);
    elseif i==1
        block_inds{i} = find(Notes.time<=PL_i.time(end));
    elseif i==n_files
        block_inds{i} = find(Notes.time>=PL_i.time(1));
    else
        block_inds{i} = find(Notes.time>=PL_i.time(1) & Notes.time<=PL_i.time(end));
        if numel(block_inds{i})==0
            warning('No notes found for PowerLab data')
            block_step = 1;      
        else
            block_step = block_inds{i}(1)-block_inds{i-1}(end);
        end
    end
    B{i} = Notes(block_inds{i},:);
    
    % Ask to keep or clip block, in case there are notes outside PL time range
    % (NB two separate if tests required, as both test conditions may be true.)
    if i==1, B{i} = check_for_notes_before_PL(B{i},PL_i); end
    if i==n_files, B{i} = check_for_notes_after_PL(B{i},PL_i); end
    
    % Handle intermediate notes, in case LabChart was paused or there are some
    % PowerLab files not being initialized 
    if block_step>1
        intermediateNotes = block_inds{i-1}(end):block_inds{i}(1);
        warning(sprintf('\nIntermediate note row(s) not within in any PowerLab file time ranges:\n\n'));
        disp(Notes(intermediateNotes,:))

        % Ask if they also should be included (default is to exclude)
        % msg = sprintf('\nWhat to do with these intermediate note rows?')
        % resp = ask_list_ui(opts,msg,2);
        % if resp==1
        %     B{i-1} = Notes([block_inds{i-1},intermediateNotes],:);
        %     B{i} = Notes([intermediateNotes,block_inds{i}],:);
        % end
    end
    
    % Handle notes that are accosiated/assigned with more than one PowerLab file
    if block_step<1
        overlappingBlocks = block_inds{i-1}(end):block_inds{i}(1);
        warning(sprintf('\nNote row(s) accosiated to multiple (overlapping) PowerLab files:\n\n'));
        disp(Notes(overlappingBlocks,:))

    end
    
    
    
end

function B = check_for_notes_before_PL(B,PL)
    % Ask to include notes before PL was started, to either get the full
    % span from PL, or to include other than PowerLab data
    
    preDataNotes_ind = find(B.time<PL.time(1));
    if numel(preDataNotes_ind)>0
        
        warning(sprintf(['\nThere are %d timestamp(s) in Notes earlier than '...
            'first timestamp in PowerLab data\n\n'],numel(preDataNotes_ind)));
        
        nearestNote_ind = preDataNotes_ind(end);
        B = ask_to_include(B,preDataNotes_ind,nearestNote_ind);
        
    end    
end

function B = check_for_notes_after_PL(B,PL)
    % Ask to include notes after PL was stopped, to either get the full
    % span from PL, or to include other than PowerLab data
    
    postDataNotes_ind = find(B.time<PL.time(1));
    if numel(postDataNotes_ind)>0
        
        warning(sprintf(['\nThere are %d timestamp(s) in Notes later than '...
            'last timestamp in PowerLab data\n\n'],numel(postDataNotes_ind)));
        nearestNote_ind = postDataNote_ind(1);
        B = ask_to_include(B,postDataNotes_ind,nearestNote_ind);
        
    end    
   
end

function B = ask_to_include(B,outsideNotes_ind,nearestNote_ind)
    
    disp(B(outsideNotes_ind,:))
    
    opts = {'Include all timestamps', 'Ignore'};
    default=1;
    if numel(outsideNotes_ind)>1
        opts = [opts,'Include only the nearest timestamp'];
        default=3;
    end
    
    msg = sprintf('\nWhat to do with notes outside PowerLab time range?');
    resp = ask_list_ui(opts,msg,default);
    if resp==3
        outsideNotes_ind(nearestNote_ind) = [];
        B(outsideNotes_ind,:) = [];
    elseif resp==2
        B(outsideNotes_ind,:) = [];
    end
        
end
    
    
    