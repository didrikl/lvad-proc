function S = fuse_data(Notes,PL,US,fs_new,interNoteInclSpec,outsideNoteInclSpec)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % interNoteInclSpec and outsideNoteInclSpec:
    %    'none':    Fusion results in LabChart data clipped at nearest note 
    %               within the range of LabChart recording 
    %    'nearest': Fusion results in LabChart data is not clipped, and extended
    %               to the nearest note outside the recording range.
    %    'all':     Fusion results in LabChart data is not clipped, and extended
    %               to the full note range. NB: Use with caution, as very large
    %               timetable may be created when experiment was paused for a
    %               considerate time.
    %
    % See also merge_table_blocks, fuse_timetables, syncronize
    
    % NOTE: Make OO and InclInterRowsInFusion,outsideNoteInclSpec as properties
    if nargin<3, US = table; end
    if nargin<4, fs_new = nan; end
    if nargin<5, interNoteInclSpec = 'nearest'; end
    if nargin<6, outsideNoteInclSpec = 'nearest'; end
        
    welcome('Data fusion of PowerLab data with Notes and ultrasonic data')
            
    [~,PL] = get_cell(PL);
    fuse_opts = make_fuse_opts(fs_new);
    
    % Notes without timestamps can not be used in data fusion
    Notes = Notes(not(isnat(Notes.time)),:);
    
    % Convert from int16, so that missing values may be used as "extrapolant"
    notes_int_vars = get_varname_of_specific_type(Notes,'int16');
    Notes{:,notes_int_vars} = single(Notes{:,notes_int_vars});
        
    % Loop over each stored LabChart file
    nBlocks = numel(PL);
    B = cell(nBlocks,1);
    b_inds = cell(nBlocks,1);
    for i=1:nBlocks
        
        multiWaitbar('Data fusion',(i-1)/nBlocks);
        display_block_info(PL{i},i,nBlocks,false,true);
        
        % Merging LabChart timetable with notes
        [B, b_inds] = determine_notes_block(Notes,PL{i},i,nBlocks,B,b_inds,...
            interNoteInclSpec,outsideNoteInclSpec);
        if isempty(B{i})
            warning('No notes for LabChart block')
        else   
            PL{i} = PL{i}(PL{i}.time>=B{i}.time(1) & PL{i}.time<=B{i}.time(end),:);
        end
        
        % Introducing better names, in case something goes wrong in LabChart_i        % fuse_timetables function
        LabChart_i = PL{i};
        Notes_block_i = B{i};
        PL{i} = fuse_timetables(LabChart_i,Notes_block_i,fuse_opts);
        
        % Ultrasound is clipped to time range of B and notes, only (i.e. not
        % clipping of B to achive a union of the two time ranges)
        if isempty(US) || height(US)==0
            warning('No ultrasounic data for LabChart block\n')
            continue;
        end
        display_block_varnames(US)       
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        PL{i} = fuse_timetables( PL{i},US_block,fuse_opts );
        
        % Put in NaN instead of extrapolated values made by syncronize function
        % called in fuse_timetables
        try
            PL{i}{PL{i}.time>LabChart_i.time(end),LabChart_i.Properties.VariableNames}=NaN;
            PL{i}{PL{i}.time<LabChart_i.time(1),LabChart_i.Properties.VariableNames}=NaN;
            PL{i}{PL{i}.time>US_block.time(end),US_block.Properties.VariableNames}=NaN;
            PL{i}{PL{i}.time<US_block.time(1),US_block.Properties.VariableNames}=NaN;
        catch
        end
        
        PL{i}{:,notes_int_vars} = single(PL{i}{:,notes_int_vars});
        PL{i} = standardizeMissing(PL{i},-9999);
    end
    
    try
        multiWaitbar('Merging table blocks into one timetable','Busy');
        S = merge_table_blocks(PL);
    catch
        warning('Out of memory. Trying now with a cell array split...')
        S1 = merge_table_blocks(PL(1:floor(nBlocks/2)));
        PL(1:floor(nBlocks/2)) = [];
        S2 = merge_table_blocks(PL);
        S = merge_table_blocks(S1,S2);
        clear S1 s2
    end
    multiWaitbar('Merging table blocks into one timetable','Close');
    multiWaitbar('Data fusion',1);
          
    clear fuse_timetables
    
end

function fuse_opts = make_fuse_opts(fs_new)
    fuse_opts = {};
    if not(isnan(fs_new)) 
        fuse_opts = {'regular',...
            'SampleRate',fs_new,...
            %'EndValues',missing...
            };
    end
end

function [B,b_rowInds] = determine_notes_block(Notes,PL_i,i,nBlocks,B,b_rowInds,...
        interNoteInclSpec,outsideNoteInclSpec)
    % Extract a notes block corresponding with (current) PL block
    
    blockRowGap = 1;
    
    if nBlocks==1
        % Use all note rows in "block unioun" if only one PL block
        b_rowInds{i} = 1:height(Notes);

    elseif i==1
        % If first block: Include eventual preceeding notes as well
        b_rowInds{i} = find(Notes.time<=PL_i.time(end));
    
    elseif i==nBlocks
        % If last block: Include eventual proceeding notes as well
        b_rowInds{i} = find(Notes.time>=PL_i.time(1));
    
    else  
        % If intermediate block: Lookup notes row inds with "snap to nearest 
        % second". Also, find number of rows from previous block, in which >1 
        % indicates notes made without any LabChart recording.
        tol = seconds(0.5);
        b_rowInds{i} = find(Notes.time>=PL_i.time(1)-tol & ...
            Notes.time<=PL_i.time(end)+tol);
        
         if numel(b_rowInds{i})>0
             prevBlock = find(cellfun(@(c)not(isempty(c)),b_rowInds(1:i-1)),1,'last');
             blockRowGap = b_rowInds{i}(1)-b_rowInds{prevBlock}(end);
        end
 
   end

    B{i} = Notes(b_rowInds{i},:);
    
    % Include more note rows outside the range of current PL block?
    if i==1 || i==nBlocks
        B{i} = check_for_notes_outside_PL(B{i},PL_i,outsideNoteInclSpec);
    end
    B = check_for_gap_in_note_blocks(Notes,B,blockRowGap,b_rowInds,i,interNoteInclSpec);
    
    % Exclude overlapping note rows
    B = check_for_overlapping_note_blocks(Notes,B,blockRowGap,b_rowInds,i);

    
end

function  B = check_for_overlapping_note_blocks(Notes,B,b_rowStep,b_rowInds,i)
    % Handle notes accosiated with multiple (overlapping) LabChart blocks
    % Should rarely be the case; Initializing PL also checks for overlapping.
    if b_rowStep<1
        overlapping = b_rowInds{i-1}(end):b_rowInds{i}(1);
        fprintf('\n')
        warning(sprintf('\nNote row(s) accosiated to multiple LabChart blocks\n\n'));
        disp(Notes(overlapping,:))
        [B{i},B{i-1}] = handle_overlapping_ranges(B{i},B{i-1},false);
    end
end

function B = check_for_gap_in_note_blocks(Notes,B,b_rowStep,b_inds,i,interNoteInclSpec)
    % Handle intermediate notes, in case LabChart was paused or there are some
    % PowerLab files not being initialized

    
    
    if b_rowStep>1 % i>1 is implied
        intermediateNotes = b_inds{i}(1)-b_rowStep:b_inds{i}(1);
        fprintf('\n')
        warning(sprintf('\n\tIntermediate note row(s) no LabChart recording\n\n'));
        disp(Notes(intermediateNotes,:))

        switch interNoteInclSpec
            case 'nearest'
                B{i} = Notes((b_inds{i}(1)-1):b_inds{i}(end),:);
                B{i-1} = Notes(b_inds{i-1}(1):(b_inds{i-1}(end)+1),:);
            case 'all'
                B{i} = Notes(b_inds{i}(1)-b_rowStep:b_inds{i}(end),:);
            case 'none'
                % Do nothing
        end
        
    end
end

function B = check_for_notes_outside_PL(B,PL_i,outsideNoteInclSpec)
    
    preDataNotes_ind = find(B.time<PL_i.time(1));
    if nnz(preDataNotes_ind)>0    
        fprintf('\n')
        warning(sprintf('\n\tThere are Notes rows before LabChart data starts\n'));
        disp(B(preDataNotes_ind,:))  
    end  
    
    postDataNotes_ind = find(B.time>PL_i.time(end));
    if nnz(postDataNotes_ind)>0       
        fprintf('\n')
        warning(sprintf('\n\tThere are Notes rows after LabChart data starts\n'));
        disp(B(postDataNotes_ind,:))
    end
    
    switch outsideNoteInclSpec
        case 'nearest'
            if numel(postDataNotes_ind)>1 
                B(postDataNotes_ind(2:end),:) = [];
            end
            if numel(preDataNotes_ind)>1 
                B(preDataNotes_ind(1:end-1),:) = [];
            end    
        case 'all'
            % Do nothing. 
            % NOTE: Could alert for a long duration
        case 'none'
            B([preDataNotes_ind;postDataNotes_ind],:) = [];            
    end
    
end
