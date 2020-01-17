
read_path = 'C:\Data\IVS\Marte';
file_name_1 = 'test TAVI 001';
file_name_2 = 'TAVI test 002.txt';

%     file_path_1 = fullfile(read_path,file_name_1);
%     testTAVI001 = importfile(file_path_1);
%testTAVI002 = importfile(file_path_2);

file_path_1 = fullfile(read_path,file_name_1);
TAVItest001 = importfile(file_path_1);

file_path_2 = fullfile(read_path,file_name_2);
TAVItest002 = import_file_format2(file_path_2);


function testTAVI001 = importfile(filename, startRow, endRow)

    %% Initialize variables.
    delimiter = ';';
    if nargin<=2
        startRow = 29;
        endRow = inf;
    end
    
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
    
    %% Open the text file.
    fileID = fopen(filename,'r');
    
    %% Read columns of data according to the format.
    % This call is based on the structure of the file used to generate this code. If
    % an error occurs for a different file, try regenerating the code from the
    % Import Tool.
    textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for block=2:length(startRow)
        frewind(fileID);
        textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end
    
    %% Close the text file.
    fclose(fileID);
    
    %% Post processing for unimportable data.
    % No unimportable data rules were applied during the import, so no post
    % processing code is included. To generate code which works for unimportable
    % data, select unimportable cells in a file and regenerate the script.
    
    %% Create output variable
    testTAVI001 = table(dataArray{1:end-1}, 'VariableNames', {'aVL','I','aVR','II','aVF','III','V1','V2','V3','V4','V5','V6','QRS','STIM','AO','AO1'});
    
end

function TAVItest002 = import_file_format2(filename, startRow, endRow)

    
    %% Initialize variables.
    delimiter = ';';
    if nargin<=2
        startRow = 28;
        endRow = inf;
    end
    
    formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
    
    %% Open the text file.
    fileID = fopen(filename,'r');
    
    %% Read columns of data according to the format.
    % This call is based on the structure of the file used to generate this code. If
    % an error occurs for a different file, try regenerating the code from the
    % Import Tool.
    textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for block=2:length(startRow)
        frewind(fileID);
        textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end
    
    %% Close the text file.
    fclose(fileID);
    
    %% Post processing for unimportable data.
    % No unimportable data rules were applied during the import, so no post
    % processing code is included. To generate code which works for unimportable
    % data, select unimportable cells in a file and regenerate the script.
    
    %% Create output variable
    TAVItest002 = table(dataArray{1:end-1}, 'VariableNames', {'aVL','I','aVR','II','aVF','III','QRS','AO'});
    
end