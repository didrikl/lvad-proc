function S = fuse_data_parfor(notes,PL,US)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables
    
    if nargin<3, US = table; end
    
    welcome('Data fusion')
    
    if not(iscell(PL)),PL = {PL}; end
    
    % Loop over each stored PowerLab file
    n_files = numel(PL);
    notes_block = cell(n_files,1);
    US_block = cell(n_files,1);
    notes_merge_cols = not(ismember(notes.Properties.VariableContinuity,...
        {'unset','event'}));
    notes = notes(:,notes_merge_cols);
    for i=1:n_files
        
        % Union merging PowerLab timetable with notes
        notes_block{i} = notes(notes.time>=PL{i}.time(1) & ...
            notes.time<=PL{i}.time(end),:);
        if isempty(notes_block{i})
            warning('No notes for PowerLab file')
        end
        
        % Ultrasound is clipped to time range of B and notes, only (i.e. not
        % clipping of B to achive a union of the two time ranges)
        if isempty(US) || height(US)==0
            fprintf('\n');
            warning('No ultrasound data for PowerLab file')
            continue;
        end
        US_block{i} = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        
    end
    
    hbar = parfor_progressbar(n_files,'Data fusion...');
    parfor i=1:n_files
        
        PL{i} = PL{i}(PL{i}.time>=notes_block{i}.time(1) & ...
            PL{i}.time<=notes_block{i}.time(end),:);
        PL{i} = synchronize(PL{i},notes_block{i});
        
        if not(isempty(PL{i})) && not(isempty(US_block{i}))
            PL{i} = synchronize(PL{i},US_block{i});
        end
        hbar.iterate(1);
        
    end
    close(hbar);
    
    n = floor(n_files/2);
    S1 = merge_table_blocks(PL{1:n});
    S2 = merge_table_blocks(PL);
    clear PL
    S = merge_table_blocks(S1,S2);
end
