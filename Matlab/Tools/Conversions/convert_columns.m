function T = convert_columns(T,dataTypes)
    % Convert (cast) all columns in a table according to a given datatype list.
    %
    % Generic datatypes:
    %  * numeric 
    %     - if already numeric format, then do nothing
    %     - otherwise convert to double (as default)
    %  * duration
    %     - if already duration format, then do nothing,
    %     - otherwise convert to duration in seconds(as default)
    %
    % Specific numeric types: 
    %  * int8, int16, int32, int64, uint8, uint16, uint32, uint64, single 
    %    or double
    %
    % Specific numeric types:
    %  * datetime, seconds, minutes, hours, days or years
    %
    % Other datatypes:
    %  * categorical
    %  * cell or cellstr
    %  * string
    %

    varNames = T.Properties.VariableNames;
    for j=1:numel(dataTypes)
        
        type = dataTypes{j};
        if isa(T{:,j},type), continue; end
        
        switch type
            
            case {'categorical','categoric'}
                T.(varNames{j}) = categorical(T{:,j});
            case {'cell','cellstr'}
                T.(varNames{j}) = cellstr(string(T{:,j}));
            case 'string'
                T.(varNames{j}) = string(T{:,j});
                
            case 'numeric'
                T.(varNames{j}) = ensure_numeric(T{:,j});
            case {'int8','int16','int32','int64','uint8','uint16','uint32',...
                    'uint64','single','double'}
                T.(varNames{j}) = ensure_numeric(T{:,j});
                fnc = str2func(type);
                T.(varNames{j}) = fnc(T{:,j});
                
            case 'duration'
                if isduration(T.(varNames{j})), continue; end
                T.(varNames{j}) = ensure_numeric(T{:,j});
                T.(varNames{j}) = seconds(T.(varNames{j}));
            case {'datetime','seconds','minutes','hours','days','years'}  
                fnc = str2func(type);
                T.(varNames{j}) = fnc(T{:,j});
                
            otherwise
                warning('Conversion of column %s to %s is not supported',...
                    varNames{j},type)
                
        end
    end
       
function var = ensure_numeric(var)
    if iscategorical(var)
        var = str2double(string(var));
    elseif not(isnumeric(var))
        var = str2double(string(var));
    end