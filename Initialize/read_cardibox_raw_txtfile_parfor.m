function raw = read_cardiaccs_raw_txtfile_parfor(fileName,read_path)

if nargin==1, read_path = ''; end
filePath = fullfile(read_path,fileName);

% Open file and go to first line with a status="ok" record
fid = fopen(filePath, 'r');
[first_row, n_skipped_rows] = spool_to_status_ok(fid);

% no of lines / size in kb
lines_per_kb = 1274174 / 246143;
s = dir(filePath);         
filesize_in_kb = s.bytes/1024;
n_lines_approx = round(2*lines_per_kb*filesize_in_kb);
n_lines_approx = n_lines_approx - n_skipped_rows;

lines = cell(n_lines_approx,1);
lines{1} = first_row;
i = 1;
while true
    
    % If not end of file, split the line into line entries
    if feof(fid), break; end    
    
    % Init next row
    i = i+1;
    lines{i} = fgetl(fid);
    
end
fclose(fid);

% Remove extra preallocated rows, if any 
overshooting_inds = cellfun(@isempty,lines);
lines(overshooting_inds,:) = [];


n_lines = numel(lines);
raw_adcscale = cell(n_lines,1);
raw_accscale = cell(n_lines,1);
raw_adc = cell(n_lines,1);
raw_acc = cell(n_lines,1);
raw_t = cell(n_lines,1);
raw_frame = cell(n_lines,1);

parfor i=1:n_lines
    row = split(lines{i}(4:end-2),'" ')';
    
    % Store frame and t
    raw_frame{i} = row{2}(8:end);
    raw_t{i} = row{3}(4:end);
    
    % Skip storing meassurements if status is not OK. Empty placeholders is
    % used instead, as preallocated above
    if strcmp(row{4}(9:10),'ok')
        
        % Store adcscale, accscale, adc, acc (in that order)
        raw_adcscale{i} = row{7}(11:end);
        raw_accscale{i} = row{8}(11:end);
        raw_adc{i} = row{9}(6:end);
        raw_acc{i} = row{10}(6:end);
        
    end
    
end    

raw = table(raw_frame, raw_t, raw_adcscale, raw_accscale, raw_adc, raw_acc,...
    'VariableNames',{'frame','t','adcscale','accscale','adc','acc'});

raw = add_cardibox_raw_variable_properties(raw);
raw.Properties.UserData = make_init_userdata(fileName,read_path);

