function T = merge_table_blocks(varargin)
    % merge_table_blocks 
    %  Merge blocks stored in a cell array of tables of same set of columns,
    %  typically where one block correspond to one file on disc.
    %
    %  Empty/undefined columns are appended if missing, either in the merged 
    %  table or in specific block.  
    % 
    % See also table
    
    % TODO: T = S_parts{[1,2]} automatically merges the to parts, and it seems
    % to be quick. Special handling with column mismatch is done with this code,
    % while simple merge as with the example.
    
    if numel(varargin)==1
        blocks = varargin{1};
    else 
        blocks = varargin;
    end
    
    if numel(blocks)==1
        warning('No table block merging. There is only one table block')
    elseif numel(blocks)==0
        warning('No table block merging. There are no table blocks')
    end
    
    T = blocks{1};
    ii=0;
    for i=1:numel(blocks)
        
        if isempty(blocks{i})
            warning(sprintf('\n\tBlock no. %d is empty\n',i))
        end
        if not(istable(blocks{i})) && not(istimetable(blocks{i}))
            warning(sprintf('\n\tBlock no. %d is not a table\n',i))
        end

        if i==1+ii 
            if isempty(blocks{i}) || ( not(istable(blocks{i})) && not(istimetable(blocks{i})) )
                ii = ii+1;
            else
                T = blocks{i};
            end
            continue; 
        end
       
        if isempty(blocks{i}) || ( not(istable(blocks{i})) && not(istimetable(blocks{i})) )
            continue
        end
        
        T.Properties.UserData.Blocks{i} = blocks{i}.Properties.UserData;
        
        if istimetable(blocks{i})
            T.Properties.UserData.Blocks{i}.SampleRate = blocks{i}.Properties.SampleRate;
        end
              
        [T, blocks{i}] = fill_in_missing_cols(T, blocks{i});
        T = [T;blocks{i}];
        
        % Save some memory
        blocks{i}=[];
        
    end
    
    
end

function [T, new_block] = fill_in_missing_cols(T, new_block)
    % First, find possible non-matching col vars in both tables
    mis_vars_bef = find_missing_vars(T, new_block);
    mis_vars_aft = find_missing_vars(new_block, T);
    
    % Pre-fill missing cols in table1
    if not(isempty(mis_vars_bef))
        fprintf(['\n\tNew columns present in new block.',...
            '\n\tTable is expanded with extra column(s):',... 
            '\n\t\t',strjoin(mis_vars_bef),'\n'])
        T = fill_cols(T, new_block, mis_vars_bef);
    end
    
    % Pre-fill missing cols in table2
    if not(isempty(mis_vars_aft))
        fprintf(['\n\tColumn(s) not present in new block.',...
            '\n\tThe new block is expanded with extra column(s):',... 
            '\n\t\t',strjoin(mis_vars_aft),'\n'])    
        new_block = fill_cols(new_block, T, mis_vars_aft);
    end
end

function vars = find_missing_vars(table1, table2)
    % Determine which variables in table1 that is not in table2.
    h1 = table1.Properties.VariableNames;
    h2 = table2.Properties.VariableNames;
    vars = setdiff(h2,h1);
end

function T = fill_cols(T, new_block, mis_vars)  
    % make a new column filled with values 
        
    n_rows = height(T);
    for i=1:length(mis_vars)
        val = new_block{1,mis_vars{i}};
        class(val)
        if isdatetime(val)
            fillCol = NaT(n_rows,1);
        elseif isnumeric(val)
            fillCol = nan(n_rows,1);
        elseif islogical(val)
            fillCol = false(n_rows,1);
        elseif iscategorical(val)
            fillCol = categorical(repmat({''},n_rows,1));
        elseif iscell(val)
            fillCol = cell(n_rows,1);
        elseif ischar(val)
            fillCol = char(n_rows,1);
        elseif isstring(val)
            fillCol = repmat("",n_rows,1);
        else
            error('\nNot implemented: Merging columns of class %s\n',class(val))
        end

        T.(mis_vars{i}) = fillCol;
    end
end