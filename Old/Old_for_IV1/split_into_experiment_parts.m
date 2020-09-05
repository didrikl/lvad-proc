function signal_parts = split_into_experiment_parts(signal,notes)
    % SPLIT_INTO_EXPERIMENT_PARTS
    %   Extract data for that have a integer value in the column 
    %  .part.
    %
    % Usage:
    %   signal_parts = split_into_experiment_parts(signal,notes)
    %
    
    % Find part numbers (only numbers, not undefined/NA/missing)
    parts = string(unique(notes.part));
    parts = parts(isfinite(str2double(parts)));
        
    % Extract and store each experiement part gathered into one struct
    signal_parts = struct;
    for i=1:numel(parts)
        part_id = char(parts(i));
        fieldname = ['part',part_id];
        signal_parts.(fieldname) = signal(signal.part==part_id,:);
    end
    