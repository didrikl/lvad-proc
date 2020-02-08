function S = fuse_data(notes,PL,US)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables
    
    fprintf('\nData fusion:')
    
    for i=1:numel(PL)
        
        % merging notes
        fprintf('\nData fusion of block with notes')
        notes_block = notes(...
            notes.time>=PL{i}.time(1) & notes.time<=PL{i}.time(end),:);
        PL{i} = PL{i}(...
            PL{i}.time>=notes_block.time(1) & PL{i}.time<=notes_block.time(end),:);
        if isempty(notes_block)
            warn('No notes for PowerLab block')
        end
        
        PL{i} = fuse_timetables(PL{i},notes_block);
        
        % Ultrasound is clipped to time range of B and notes, only (i.e. not
        % clipping of B to achive a union of the two time ranges)
        fprintf('\nData fusion of block with ultrasound')
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        PL{i} = fuse_timetables(PL{i},US_block);
        
        clear fuse_timetables
        
    end
    
    S = merge_table_blocks(PL);
    
    fprintf('\nData fusion done.\n')
    
end