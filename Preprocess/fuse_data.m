function S = fuse_data(notes,PL,US)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables
    
    if nargin<3, US = table; end
    
    fprintf('\nData fusion:')
    
    if not(iscell(PL))
       PL = {PL};
    end
    
    % Loop over each stored PowerLab file
    for i=1:numel(PL)
        
        % Union merging PowerLab timetable with notes
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
        if isempty(US) || height(US)==0, continue; end
        fprintf('\nData fusion of block with ultrasound')
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        PL{i} = fuse_timetables(PL{i},US_block);
         
    end
    
    S = merge_table_blocks(PL);
    
    fprintf('\nData fusion done.\n')
    clear fuse_timetables

end