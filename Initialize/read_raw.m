function raw = read_raw(filename,read_path)

if nargin==1, read_path = ''; end
filepath = fullfile(read_path,filename);

% Open file and go to first line with a status="ok" record
fid = fopen(filepath, 'r');
[row, n_skipped_rows] = spool_to_status_ok(fid);

% Estimate of no. lines per file size in kb, pluss 5 percent
lines_per_kb = 1274174 / 246143;
s = dir(filepath);         
filesize_in_kb = s.bytes/1024;
n_lines_approx = round(1.05*lines_per_kb*filesize_in_kb);

% Subtract already read lines by the spool_to_status function and preallocate
n_lines_approx = n_lines_approx - n_skipped_rows;
raw = cell(n_lines_approx,5);

% The no of lines read in bulk before updating waitbar. It may also be used if
% parallellization is used
bulk_step = 20000;

end_of_file = false;
h_wait = waitbar(0,'Reading raw data');

for j=1:bulk_step:n_lines_approx
    
    % Stop if end of file was detected within the current bulk of rows below
    if end_of_file
        break
    end
    
    % Within the bulk of rows, read one-by-one
    for i=j:j+bulk_step-1
        
        % If not end of file, split the line into line entries
        if feof(fid)
            end_of_file = true;
            break; 
        end
        row = split(row(4:end-2),'" ')';
        
        % Store frame and t
        raw{i,1} = row{2}(8:end);
        raw{i,2} = row{3}(4:end);
        
        % Skip storing meassurements if status is not OK. Empty placeholders is
        % used instead, as preallocated above
        if strcmp(row{4}(9:10),'ok')
            
            % Store adcscale, accscale, adc, acc (in that order)
            raw{i,3} = row{7}(11:end);
            raw{i,4} = row{8}(11:end);
            raw{i,5} = row{9}(6:end);
            raw{i,6} = row{10}(6:end);
            
        end
        
        % Init next row
        row = fgetl(fid);
        
    end
    
    waitbar(j/n_lines_approx,h_wait)
end
fclose(fid);

% Remove extra preallocated rows, if any 
overshooting_inds = cellfun(@isempty,raw(:,1));
raw(overshooting_inds,:) = [];

raw = cell2table(raw,...
    'VariableNames',{'frame','t','adcscale','accscale','adc','acc'});

% Preset properties
raw.Properties.VariableDescriptions{'t'} = 'The Current Unix Timestamp';
raw.Properties.VariableDescriptions{'adc'} = 'External analog input';
raw.Properties.VariableDescriptions{'adcscale'} = 'Scaling factor for physical scale in voltage (mV)';
raw.Properties.VariableDescriptions{'acc'} = 'Acceleration';
raw.Properties.VariableDescriptions{'accscale'} = 'Scaling factor for gravitational scale (g)';
raw.Properties.VariableUnits{'t'} = 'sec';
raw.Properties.VariableUnits{'adc'} = 'AU';
raw.Properties.VariableUnits{'acc'} = 'AU';
raw.Properties.VariableUnits{'adcscale'} = 'mV';
raw.Properties.VariableUnits{'accscale'} = 'g';

% Userdata to store freely formated info/data
raw.Properties.UserData.read_date = datetime('now');
raw.Properties.UserData.filename = filename;
raw.Properties.UserData.filepath = filepath;
raw.Properties.UserData.source_code = mfilename('fullpath');

close(h_wait)
