function signal = init_m3_raw_textfile(filename,read_path)
    
    timestamp_fmt = 'dd-MMM-uuuu HH:mm:ss.SSS';
    
    filepath = fullfile(read_path, filename);
    signal = init_m3_raw_textfile_read(filepath);
    signal.time = datetime(signal{:,1},...
        'InputFormat',"yyyy/MM/dd HH:mm:ss",...
        'Format',timestamp_fmt,...
        'TimeZone','Europe/Oslo');
    
    % Make timetable, and add properties metadata
    signal = table2timetable(signal,'RowTimes','timestamp');
    
    signal = retime(signal,'regular','fillwithmissing','SampleRate',1);
    
    % Metadata used for populating non-matched rows when syncing
    signal.Properties.VariableContinuity(:) = 'continuous';
    
    % Add metadata for picking out sensor-messured data, when analysing
    signal.Properties.VariableUnits = {'L/min','uL/sec','','uL'};
    signal = addprop(signal,'MeassuredSignal','variable');
    signal.Properties.CustomProperties.MeassuredSignal(:) = true;
    
   
function signal = init_m3_raw_textfile_read(filename)
    % Import read function based on Matlab's import tool code autogeneration.
    % Read columns of data as text, c.f. the TEXTSCAN documentation.
    
    startRow = 1;
    endRow = inf;
    formatSpec = '%q%*q%*q%*q%*q%*q%*q%q%*q%*q%*q%*q%*q%*q%q%q%q%[^\n\r]';
    
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '\t', 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for block=2:length(startRow)
        frewind(fileID);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '\t', 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end
    fclose(fileID);
    
    % Convert the contents of columns containing numeric text to numbers.
    % Replace non-numeric text with NaN.
    raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
    for col=1:length(dataArray)-1
        raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
    end
    numericData = NaN(size(dataArray{1},1),size(dataArray,2));
    
    for col=[2,3,4,5]
        % Converts text in the input cell array to numbers. Replaced non-numeric text
        % with NaN.
        rawData = dataArray{col};
        for row=1:size(rawData, 1)
            % Create a regular expression to detect and remove non-numeric prefixes and
            % suffixes.
            regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
            try
                result = regexp(rawData(row), regexstr, 'names');
                numbers = result.numbers;
                
                % Detected commas in non-thousand locations.
                invalidThousandsSeparator = false;
                if numbers.contains(',')
                    thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                    if isempty(regexp(numbers, thousandsRegExp, 'once'))
                        numbers = NaN;
                        invalidThousandsSeparator = true;
                    end
                end
                % Convert numeric text to numbers.
                if ~invalidThousandsSeparator
                    numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                    numericData(row, col) = numbers{1};
                    raw{row, col} = numbers{1};
                end
            catch
                raw{row, col} = rawData{row};
            end
        end
    end
    
    
    % Split data into numeric and string columns and exclude rows with 
    % non-numeric cells
    rawNumericColumns = raw(:, [2,3,4,5]);
    rawStringColumns = string(raw(:, 1));
    I = ~all(cellfun(@(x) (isnumeric(x) || islogical(x)) && ~isnan(x),rawNumericColumns),2); % Find rows with non-numeric cells
    rawNumericColumns(I,:) = [];
    rawStringColumns(I,:) = [];
    
    % Create output variable
    signal = table;
    signal.time = rawStringColumns(:, 1);
    signal.flow = cell2mat(rawNumericColumns(:, 1));
    signal.emboliVolume = cell2mat(rawNumericColumns(:, 2));
    signal.emboliTotalCount = cell2mat(rawNumericColumns(:, 3));
    signal.emboliTotalVolume = cell2mat(rawNumericColumns(:, 4));
    