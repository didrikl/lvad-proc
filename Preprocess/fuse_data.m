function S = fuse_data(notes,PL,US)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables
    
    if nargin<3, US = table; end
    
    welcome('Data fusion')
    
    if not(iscell(PL)),PL = {PL}; end
    
    % Loop over each stored PowerLab file
    h_wait = waitbar(0,'','Name','Data fusion...');
    n_files = numel(PL);
    for i=1:n_files
        
        fprintf('\n<strong>PowerLab file no %d: </strong>\nFilename: %s',...
            i,PL{i}.Properties.UserData.FileName)
        
        % Union merging PowerLab timetable with notes
        fprintf('\n\nFusion with notes')
        waitbar((2*i-1)/(2*n_files),h_wait,...
            sprintf('PowerLab file %d/%d: Fusion with notes',i,n_files));
        notes_block = notes(...
            notes.time>=PL{i}.time(1) & notes.time<=PL{i}.time(end),:);
        PL{i} = PL{i}(...
            PL{i}.time>=notes_block.time(1) & PL{i}.time<=notes_block.time(end),:);
        if isempty(notes_block)
            warning('No notes for PowerLab file')
        end  
        PL{i} = fuse_timetables(PL{i},notes_block);
        
        % Ultrasound is clipped to time range of B and notes, only (i.e. not
        % clipping of B to achive a union of the two time ranges)
        fprintf('\n\nFusion with ultrasound')
        if isempty(US) || height(US)==0
            fprintf('\n');
            warning('No ultrasound data for PowerLab file')
            continue; 
        end
        waitbar(2*i/(2*n_files),h_wait,...
            sprintf('PowerLab file %d/%d: Fusion with ultrasound',i,n_files));
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        PL{i} = fuse_timetables(PL{i},US_block);
        
        fprintf(newline)
    end
    
    S = merge_table_blocks(PL);
    
    clear fuse_timetables
    close(h_wait)

end