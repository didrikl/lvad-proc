function S = fuse_data(notes,PL,US)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables
    
    if nargin<3, US = table; end
    if not(iscell(PL)),PL = {PL}; end
    
    fprintf('\nData fusion:\n')
    
    % Loop over each stored PowerLab file
    h_wait = waitbar(0,'','Name','Data fusion...');
    n_files = numel(PL);
    for i=1:n_files
        
        % Union merging PowerLab timetable with notes
         waitbar((2*i-1)/(2*n_files),h_wait,...
            sprintf('PowerLab file %d/%d: Fusion with notes',i,n_files));
        fprintf('\n\n<strong>PowerLab file no %d</strong>',i)
        
        notes_block = notes(...
            notes.time>=PL{i}.time(1) & notes.time<=PL{i}.time(end),:);
        PL{i} = PL{i}(...
            PL{i}.time>=notes_block.time(1) & PL{i}.time<=notes_block.time(end),:);
        if isempty(notes_block)
            warning('No notes for PowerLab file block')
        end
         
        PL{i} = fuse_timetables(PL{i},notes_block);
        
        % Ultrasound is clipped to time range of B and notes, only (i.e. not
        % clipping of B to achive a union of the two time ranges)
        if isempty(US) || height(US)==0
            warning('No ultrasound data for PowerLab file block')
            continue; 
        end
        waitbar(2*i/(2*n_files),h_wait,...
            sprintf('PowerLab file %d/%d: Fusion with ultrasound',i,n_files));
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        PL{i} = fuse_timetables(PL{i},US_block);
        
    end
    
    S = merge_table_blocks(PL);
    
    fprintf('\nData fusion done.\n')
    clear fuse_timetables
    close(h_wait)

end