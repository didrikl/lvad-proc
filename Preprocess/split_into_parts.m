function S_parts = split_into_parts(S,fs)
        
    % Sample rate for re-sampling down to highest signal content frequency 
    if nargin<2, fs=get_sampling_rate(S); end
    
    welcome('Splitting into cell array of regular part tables')
    
    n_parts = max(double(string(categories(S.part))));
    
    S_parts = cell(n_parts,1); 
    for i=1:n_parts
        
        welcome(sprintf('Part %d\n',i),'iteration')
        multiWaitbar('Splitting into parts',(i-1)/n_parts);

        S_parts{i} = S(S.part==string(i),:);
        if height(S_parts{i})==0
            warning('No data');
            continue; 
        end
        S_parts{i}.Properties.UserData = rmfield(S_parts{i}.Properties.UserData,'FileName');
        S_parts{i}.Properties.UserData = rmfield(S_parts{i}.Properties.UserData,'FilePath');

        fprintf('%s duration\n',string(S_parts{i}.time(end)-S_parts{i}.time(1)))

        % In case part extraction results in gaps that prevents even sampling
        if isnan(S_parts{i}.Properties.SampleRate) || ...
                S_parts{i}.Properties.SampleRate~=fs
            %S_parts{i} = resample_signal(S_parts{i}, fs_parts);
            
            S_parts{i}.pumpSpeed = double(S_parts{i}.pumpSpeed);
            gap_starts = find(diff(S_parts{i}.time)>seconds(1));
            for j=1:numel(gap_starts)
                gap_start_time(j) = S_parts{i}.time(gap_starts(j));
                gap_end_time(j) = S_parts{i}.time(gap_starts(j)+1);
            end
            
            S_parts{i} = retime(S_parts{i},'regular','nearest','SampleRate',fs);
            
            for j=1:numel(gap_starts)
                fprintf(['\nRecorded balues in the regular table are set as ',...
                    'missing within gap between \n\tStart:%s\n\tEnd: %s\n\n'],...
                    gap_start_time(j),gap_end_time(j));
                gap_times = timerange(gap_start_time(j),gap_end_time(j));
                vars_as_missing = ...
                    not(ismember(S_parts{i}.Properties.VariableNames,...
                    {'Q','noteRow'}));
                S_parts{i}{gap_times,vars_as_missing} = missing;
            end
            
        end
            S_parts{i}.pumpSpeed = int16(S_parts{i}.pumpSpeed);

        
        % Remove possible first/last row(s) with undefined part after re-sampling
%         S_parts{i}(isundefined(S_parts{i}.part),:) = [];
%         if isnan(S_parts{i}.Properties.SampleRate)
%             [fs,S_parts{i}] = get_sampling_rate(S_parts{i});
%         end
        
        % Remove excessive info to save memory
        %S_parts{i}.part = [];
        
    end
    
    multiWaitbar('Splitting into parts',1);

    