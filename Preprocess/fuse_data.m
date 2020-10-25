function S = fuse_data(Notes,PL,US)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables
    
    if nargin<3, US = table; end
    
    welcome('Data fusion')
    
    if not(iscell(PL)),PL = {PL}; end
    
    % Loop over each stored PowerLab file
    %    h_wait = waitbar(0,'','Name','Data fusion...');
    n_files = numel(PL);
    
    % Notes without timestamps can be used in data fusion
    Notes = Notes(not(isnat(Notes.time)),:);
    
    Blocks = cell(n_files,1);
    block_inds = cell(n_files,1);
    for i=1:n_files
        
        fprintf('\n<strong>PowerLab file (no %d/%d): </strong>\nFilename: %s\n',...
            i,n_files,PL{i}.Properties.UserData.FileName)

        [Blocks, block_inds] = determine_notes_block(Notes,PL{i},i,n_files,Blocks,block_inds);
        
        
        % Union merging PowerLab timetable with notes
        %fprintf('\n\nFusion with notes')
        %         waitbar((2*i-1)/(2*n_files),h_wait,...
        %             sprintf('PowerLab file %d/%d: Fusion with notes',i,n_files));
    
        if isempty(Blocks{i})
            warning('No notes for PowerLab file')
        else
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
        %         waitbar(2*i/(2*n_files),h_wait,...
        %             sprintf('PowerLab file %d/%d: Fusion with ultrasound',i,n_files));
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        PL{i} = fuse_timetables(PL{i},US_block);
        
        fprintf(newline)
    end
    
    S = merge_table_blocks(PL);
    
    clear fuse_timetables
    %    close(h_wait)
    
end

function [Block,block_inds] = determine_notes_block(Notes,PL,i,n_files,Block,block_inds)
    
    opts = {'Include time for data fusion', 'Ignore time for data fusion'};

    % Include notes before/after PL was started/stopped
    % TODO: Check for previous iteration if there are intermediate gaps
    % in notes and include the gaps
    block_step = 0;
    if n_files==1
        block_inds{i} = 1:height(Notes);
    elseif i==1
        block_inds{i} = find(Notes.time<=PL.time(end));
    elseif i==n_files
        block_inds{i} = find(Notes.time>=PL.time(1));
    else
        block_inds{i} = find(Notes.time>=PL.time(1) & Notes.time<=PL.time(end));
        block_step = block_inds{i}(1)-block_inds{i-1}(end);
        
    end
    if block_step>1
        exclNotes = block_inds{i-1}(end):block_inds{i}(1);
        warning(sprintf('\nIntermediate note row(s) not within in any PowerLab file time ranges:\n\n'));
        disp(Notes(exclNotes,:))
%         resp = ask_list_ui(opts,sprintf('\nWhat to do with these intermediate note rows?'),1);
%         if resp==1
%             Block{i-1} = Notes([block_inds{i-1},exclNotes],:);
%             Block{i} = Notes([exclNotes,block_inds{i}],:);
%         end
    end
    Block{i} = Notes(block_inds{i},:);
    
    % Ask to include before/after PL was started/stopped, to get the full
    % span from PL
    preDataNotes = Block{i}.time<PL.time(1);
    if any(preDataNotes)
        warning(sprintf('\nNotes timestamp(s) exist before first timestamp in PowerLab data\n\n'));
        disp(Block{i}(preDataNotes,:))
        resp = ask_list_ui(opts,sprintf('\nWhat to do with notes before PowerLab recording?'),1);
        if resp==2
            Block{i} = Block{i}(not(preDataNotes),:);
        end
    end
    postDataNotes = Block{i}.time>PL.time(end);
    if any(postDataNotes)
        warning(sprintf('\nNotes timestamp(s) exist after last timestamp in PowerLab data\n\n'));
        disp(Block{i}(postDataNotes,:))
        resp = ask_list_ui(opts,sprintf('\nWhat to do with notes after PowerLab recording?'),1);
        if resp==2
            Block{i} = Block{i}(not(postDataNotes),:);
        end
    end
    
end