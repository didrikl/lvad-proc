function S = fuse_data(Notes,PL,US,fs_new,InclInterRowsInFusion)
    % fuse_data Fuse notes and ultrasound into PowerLab data
    %
    %    S = fuse_data(notes,PL,US)
    %
    % See also merge_table_blocks, fuse_timetables, syncronize
    
    if nargin<3, US = table; end
    if nargin<4, fs_new = nan; end
    if nargin<5, InclInterRowsInFusion=false; end
      
    welcome('Data fusion')
    
    [~,PL] = get_cell(PL);
    fuse_opts = make_fuse_opts(fs_new);
    
    % Notes without timestamps can not be used in data fusion
    Notes = Notes(not(isnat(Notes.time)),:);

    % Loop over each stored LabChart file
    %    h_wait = waitbar(0,'','Name','Data fusion...');
    n_files = numel(PL);
    B = cell(n_files,1);
    b_inds = cell(n_files,1);
    for i=1:n_files
        
        welcome(sprintf('\nPowerLab block (no %d/%d)',i,n_files),'iteration')
        fprintf('\nFilename: %s\n',PL{i}.Properties.UserData.FileName)

        % Merging LabChart timetable with notes
        [B, b_inds] = determine_notes_block(Notes,PL{i},i,n_files,B,b_inds);       
        PL{i} = PL{i}(PL{i}.time>=B{i}.time(1) & PL{i}.time<=B{i}.time(end),:);
        
        % Introducing better names, in case something goes wrong in
        % fuse_timetables function
        LabChart_i = PL{i};
        Notes_block_i = B{i};   
        PL{i} = fuse_timetables(LabChart_i,Notes_block_i,fuse_opts);
        
        % Ultrasound is clipped to time range of B and notes, only (i.e. not
        % clipping of B to achive a union of the two time ranges)
        if isempty(US) || height(US)==0
            warning('No ultrasound data for LabChart block\n')
            continue;
        end
        US_block = US(US.time>=PL{i}.time(1) & US.time<=PL{i}.time(end),:);
        %LabChart_i = PL{i};
        PL{i} = fuse_timetables( PL{i},US_block,fuse_opts);
        
        PL{i}{PL{i}.time>LabChart_i.time(end),LabChart_i.Properties.VariableNames}=NaN;
        
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

%    S.part = addcats(S.part,categories(notes.part));
    
end

function fuse_opts = make_fuse_opts(fs_new)
    fuse_opts = {};
    if not(isnan(fs_new)) 
        fuse_opts = {'regular','SampleRate',fs_new};
    end
end

function [B,b_inds] = determine_notes_block(Notes,PL_i,i,nBlocks,B,b_inds)
    % Extract a notes block corresponding with (current) PL block
    
    % NOTE: Make block_inds, B and i persitent variables instead?
    
    b_rowStep = 1;
    
    if nBlocks==1
        % Use all note rows in "block unioun" if only one PL block
        b_inds{i} = 1:height(Notes);

    elseif i==1
        % If first block: Include eventual preceeding notes as well
        b_inds{i} = find(Notes.time<=PL_i.time(end));
    
    elseif i==nBlocks
        % If last block: Include eventual proceeding notes as well
        b_inds{i} = find(Notes.time>=PL_i.time(1));
    
    else  
        % If intermediate block: Lookup notes row inds with "snap to nearest 
        % second". Also, find number of rows from previous block, in which >1 
        % indicates notes made without any LabChart recording.
        tol = seconds(0.5);
        b_inds{i} = find(Notes.time>=PL_i.time(withtol(PL_i.time(1),tol)) & ...
            Notes.time<=PL_i.time(withtol(PL_i.time(end),tol)));
        
         if numel(b_inds{i})>0
             lastNonEmptyBlock = find(cellfun(isempty(b_inds{1:i-1})),1,'last');
             b_rowStep = b_inds{i}(1)-lastNonEmptyBlock(end);
        end
 
   end

    B{i} = Notes(b_inds{i},:);
    
    % Display info if there are extra note row before or after LabChart data
    % (NB two separate if tests required, as both test conditions may be true.)
    if i==1, B{i} = check_for_notes_before_PL(B{i},PL_i); end
    if i==nBlocks, B{i} = check_for_notes_after_PL(B{i},PL_i); end
    
    % Handle intermediate notes, in case LabChart was paused or there are some
    % PowerLab files not being initialized 
    if b_rowStep>1
        intermediateNotes = b_inds{i-1}(end):b_inds{i}(1);
        warning('\nIntermediate note row(s) no LabChart recording:\n\n');
        disp(Notes(intermediateNotes,:))

        % Ask if they also should be included (default is to exclude)
        % msg = sprintf('\nWhat to do with these intermediate note rows?')
        % resp = ask_list_ui(opts,msg,2);
        % if resp==1
        %     B{i-1} = Notes([block_inds{i-1},intermediateNotes],:);
        %     B{i} = Notes([intermediateNotes,block_inds{i}],:);
        % end
    end
    
    % Handle notes accosiated with multiple (overlapping) LabChart blocks
    if b_rowStep<1
        overlappingBlocks = b_inds{i-1}(end):b_inds{i}(1);
        warning('\nNote row(s) accosiated to multiple LabChart blocks:\n\n');
        disp(Notes(overlappingBlocks,:))
        [B{i},B{i-1}] = handle_overlapping_ranges(B{i},B{i-1},false);
    end
    
    if isempty(B{i})
        warning('No notes for LabChart block')
    end
    
end

function B = check_for_notes_before_PL(B,PL)
    
    preDataNotes_ind = find(B.time<PL.time(1));
    if numel(preDataNotes_ind)>0    
        warning(sprintf(['\nThere are %d rows in Notes before LabChart was',...
            'recording data\n\n'],numel(preDataNotes_ind)));
        disp(B(preDataNotes_ind,:))  
        %B = B(preDataNotes_ind(end):end,:);
    end    
end

function B = check_for_notes_after_PL(B,PL)
    
    postDataNotes_ind = find(B.time>PL.time(end));
    if numel(postDataNotes_ind)>0       
        warning(sprintf(['\nThere are %d rows in Notes after LabChart was',...
            'recording data\n\n'],numel(postDataNotes_ind)));
        disp(B(postDataNotes_ind,:))
        %B = B(1:postDataNotes_ind(1),:);
        %TODO: If more than one post-rows: ask to only keep the nearest, none or
        %all
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
    
    
    