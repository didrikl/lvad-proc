function T = merge_table_blocks(blocks)
    % MERGE_TABLE_BLOCKS
    %    Merging blocks stored in a cell array of tables of same set of columns
    %
    % See also table
    
    % TODO: Handle if inconsistency in columns, by appending empty columns (c.f.
    % STAMI AML code for merging ML blocks)
    %
    T = blocks{1};
    B_userdata = cell(numel(blocks),1);
    B_userdata{1} = blocks{1}.Properties.UserData;
    for i=2:numel(blocks)
        % TODO: remove before loop
        if isempty(blocks{i})
            warning('Empty block...')
            continue;
        end
        T = [T;blocks{i}];
        B_userdata{i} = blocks{i}.Properties.UserData;
    end
    
    T.Properties.UserData.block = B_userdata;
    
